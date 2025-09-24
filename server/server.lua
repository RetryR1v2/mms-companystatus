-- Server Side
local VORPcore = exports.vorp_core:GetCore()

local CompanyBlips = {}

Citizen.CreateThread(function ()
    for h,v in ipairs(Config.CompanyBlips) do
        table.insert(CompanyBlips, v)
    end

    for h,v in ipairs(CompanyBlips) do
        print(v.Status)
    end
end)


RegisterServerEvent('mms-companystatus:server:GetDataFromServer',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local MyJob = Character.job
    TriggerClientEvent('mms-companystatus:client:SendDataToClient',src,MyJob,CompanyBlips)
end)

RegisterServerEvent('mms-companystatus:server:ToggleCompanyStatus',function(Index)
    if CompanyBlips[Index].Status then
        CompanyBlips[Index].Status = false
    else
        CompanyBlips[Index].Status = true
    end
    for h,v in ipairs(GetPlayers()) do
        TriggerClientEvent('mms-companystatus:client:ReloadData',v,CompanyBlips)
    end
end)

RegisterServerEvent('mms-companystatus:server:AnnounceMyCompany',function(Index,CompanyName)
    if CompanyBlips[Index].Status then
        for h,v in ipairs(GetPlayers()) do
            VORPcore.NotifySimpleTop(v,_U('CompanyIsOpen'), CompanyName, 15000)
        end
    else
        for h,v in ipairs(GetPlayers()) do
            VORPcore.NotifySimpleTop(v,_U('CompanyIsClosed'), CompanyName, 15000)
        end
    end
end)