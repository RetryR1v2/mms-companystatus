local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(15000)
    TriggerServerEvent('mms-companystatus:server:GetDataFromServer')
end)

if Config.Debug then
    Citizen.CreateThread(function ()
        Citizen.Wait(3000)
        TriggerServerEvent('mms-companystatus:server:GetDataFromServer')
    end)
end

local Job = nil

CompanyBlips = {}

CreatedCompanyBlips = {}

RegisterCommand(Config.StatusCommand, function()
    for h,v in pairs(CompanyBlips) do
        if v.Job == Job then
            TriggerServerEvent('mms-companystatus:server:ToggleCompanyStatus',h)
            VORPcore.NotifyRightTip(_U('CompanyStatusChanged'),5000)
        end
    end
end)

RegisterCommand(Config.AnnounceCommand, function()
    for h,v in pairs(CompanyBlips) do
        if v.Job == Job and v.CanAnnounce then
            TriggerServerEvent('mms-companystatus:server:AnnounceMyCompany',h,v.Company)
        elseif v.Job == Job and not v.CanAnnounce then
            VORPcore.NotifyRightTip(_U('YouCantAnnounce'),5000)
        end
    end
end)

RegisterNetEvent('mms-companystatus:client:SendDataToClient')
AddEventHandler('mms-companystatus:client:SendDataToClient',function(MyJob,CompanyBlipsFromServer)
    Job = MyJob
    local BlipColor = nil
    CompanyBlips = CompanyBlipsFromServer
    local ChangeCompanyStatusGroup = BccUtils.Prompts:SetupPromptGroup()
    local ChangeCompanyStatus = ChangeCompanyStatusGroup:RegisterPrompt(_U('ChangeCompanyStatusLabel'), 0x760A9C6F, 1, 1, true, 'click')--, {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- KEY G

    for h,v in pairs(CompanyBlips) do
        if not v.Status then
            BlipColor = 'BLIP_MODIFIER_MP_COLOR_10'
        else
            BlipColor = 'BLIP_MODIFIER_MP_COLOR_8'
        end
        local Blip = BccUtils.Blips:SetBlip(v.Company, v.BlipSprite, 2.0, v.Coords.x,v.Coords.y,v.Coords.z)
        local blipModifier = BccUtils.Blips:AddBlipModifier(Blip, BlipColor)
        blipModifier:ApplyModifier()
        CreatedCompanyBlips[#CreatedCompanyBlips + 1] = Blip
    end

    while true do
        Wait(5)
        for h,v in pairs(CompanyBlips) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - v.Coords)
            if dist < 3 and v.Job == MyJob then
                ChangeCompanyStatusGroup:ShowGroup(v.Company)
        
                if ChangeCompanyStatus:HasCompleted() then
                    TriggerServerEvent('mms-companystatus:server:ToggleCompanyStatus',h)
                    VORPcore.NotifyRightTip(_U('CompanyStatusChanged'),5000)
                end
            end
        end
    end
end)

RegisterNetEvent('mms-companystatus:client:ReloadData')
AddEventHandler('mms-companystatus:client:ReloadData',function(CompanyBlipsFromServer)
    CompanyBlips = CompanyBlipsFromServer
    for _, blips in ipairs(CreatedCompanyBlips) do
        blips:Remove()
    end
    for h,v in pairs(CompanyBlips) do
        if not v.Status then
            BlipColor = 'BLIP_MODIFIER_MP_COLOR_10'
        else
            BlipColor = 'BLIP_MODIFIER_MP_COLOR_8'
        end
        local Blip = BccUtils.Blips:SetBlip(v.Company, v.BlipSprite, 2.0, v.Coords.x,v.Coords.y,v.Coords.z)
        local blipModifier = BccUtils.Blips:AddBlipModifier(Blip, BlipColor)
        blipModifier:ApplyModifier()
        CreatedCompanyBlips[#CreatedCompanyBlips + 1] = Blip
    end
end)

----------------- Utilities -----------------

---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
        for _, blips in ipairs(CreatedCompanyBlips) do
            blips:Remove()
        end
    end
end)