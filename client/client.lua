ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

    Citizen.Wait(5000)

    SpawnPedestrians()
end)

RegisterCommand('spawnpeds', function(source, args)
    SpawnPedestrians()
end)

function SpawnPedestrians()
    for _, v in pairs(Config.Peds) do
        print('try: ' .. v.ped)

        local model = GetHashKey(v.ped)

        if TryToRequestModel(model) then
            local ped = CreatePed(28, model, v.coords.x, v.coords.y, v.coords.z + 1, v.coords.w, false, false)
            SetEntityHeading(ped, v.coords.w)
            FreezeEntityPosition(ped, true)
            SetPedCanRagdoll(ped, true)
            SetEntityInvincible(ped, true)
            SetEntityProofs(ped, true, true, true, true, true, true, true, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            Citizen.Wait(200)

            print('task: ' .. v.task)

            if v.task == 'animation' then
                FreezeEntityPosition(ped, false)

                Citizen.Wait(1000)

                FreezeEntityPosition(ped, true)

                if TryToRequestAnimDict(v.animdict) then
                    TaskPlayAnim(ped, v.animdict, v.animation, 8.0, 8.0, -1, 9, 1.0, false, false, false)
                else
                    DeletePed(ped)
                end
            elseif v.task == 'wander' then
                FreezeEntityPosition(ped, false)
                TaskWanderInArea(ped, v.coords.x, v.coords.y, v.coords.z + 1, v.wanderradius, v.wanderlength, v.wanderwait)
            end
        end

        SetModelAsNoLongerNeeded(model)

        print('spawned: ' .. v.ped)
    end
end

function TryToRequestModel(model)
    RequestModel(model)

    local i = 0
    while not HasModelLoaded(model) do
        if i > 200 then
            return false
        end

        Citizen.Wait(50)

        i = i + 1
    end

    return true
end

function TryToRequestAnimDict(animdict)
    RequestAnimDict(animdict)

    local i = 0
    while not HasAnimDictLoaded(animdict) do
        if i > 200 then
            return false
        end

        Citizen.Wait(50)

        i = i + 1
    end

    return true
end