local RSGCore = exports['rsg-core']:GetCoreObject()

-------------------------------------------------------------------------------------------
-- prompts and blips
-------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for _, v in pairs(Config.RanchAnimalDealer) do
        exports['rsg-core']:createPrompt(v.id, v.coords, RSGCore.Shared.Keybinds[Config.Keybind], 'Open Dealer Shop', {
            type = 'client',
            event = 'rsg-ranch:client:dealershopMenu',
            args = { v.animalspawn },
        })
        if v.showblip == true then
            local RanchDealerBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(RanchDealerBlip, joaat(Config.RanchDealerBlip.blipSprite), true)
            SetBlipScale(Config.RanchDealerBlip.blipScale, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, RanchDealerBlip, Config.RanchDealerBlip.blipName)
        end
    end
end)

RegisterNetEvent('rsg-ranch:client:dealershopMenu', function(animalspawn)
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local playerjob = PlayerData.job.name

    for i, v in ipairs(Config.AuthorisedJobs) do
        if v ~= playerjob then
            lib.notify({ title = 'Not Allowed', description = 'only rancher\'s are able to do this!', type = 'error' })
            return
        end
    end

    lib.registerContext({
        id = 'ranchdealer_mainmenu',
        title = 'Ranch Dealer Menu',
        options = {
            {
                title = 'Buy Cow',
                description = 'access boss menu',
                icon = 'fa-solid fa-hat-cowboy',
                serverEvent = 'rsg-ranch:server:newanimal',
                args = {
                    animal = 'cow',
                    hash = joaat('A_C_Cow'),
                    product = 'milk',
                    cost = Config.CowPrice,
                    animalspawn = animalspawn,
                    playerjob = playerjob
                },
                arrow = true
            },
        }
    })
    lib.showContext('ranchdealer_mainmenu')
    
end)

