Config = {}

Config.Blips = {
    -- Blip without job
    {
        BlipName = "Big Bank",
        BlipColor = 0,
        BlipID = 108,
        BlipScale = 0.6,
        BlipCoords = vector3(252.33, 218.11, 106.29),
        -- jobs = {"bankjob"} do this if you want all the server will see the blip
    },
    -- blip with job
    {
        BlipName = "Gang House 1",
        BlipColor = 0,
        BlipID = 40,
        BlipScale = 0.9,
        BlipCoords = vector3(-762.1431, 804.20831, 215.18853),
        jobs = {"GangJob"} -- do this if you want just the job you put will see the blip
        -- you can put more then 1 job in the config,
        -- like this, jobs = {"JobName1", "JobName2"}
    },
}