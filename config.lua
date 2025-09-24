Config = {}

Config.Debug = true
Config.defaultlang = "de_lang"

-- Script Settings

Config.CompanyBlips = {
    {
        Company = 'Waffenladen',
        BlipSprite = 'blip_hat',
        Coords = vector3(2803.21, 1354.55, 71.92),
        Job = 'gunsbw',
        Status = false, -- Status on Server Restart by Default ( False = Red Closed )
        CanAnnounce = true,
    },
    {
        Company = 'Doktor',
        BlipSprite = 'blip_hat',
        Coords = vector3(2811.17, 1371.5, 71.7),
        Job = 'doctor',
        Status = false, -- Status on Server Restart by Default ( False = Red Closed )
        CanAnnounce = true,
    },
}

Config.StatusCommand = 'CompanyStatus'
Config.AnnounceCommand = 'Open'