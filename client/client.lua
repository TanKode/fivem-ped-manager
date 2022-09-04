Citizen.CreateThread(function()
    Citizen.Wait(10000)

    SpawnPedestrians()
end)

function SpawnPedestrians()
    for _, v in pairs(Config.Peds) do
        local model = GetHashKey(v.ped)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(50)
        end

        local ped = CreatePed(28, model, v.x, v.y, v.z, v.h, false, false)
        SetEntityHeading(ped, v.h)
        SetPedCanRagdoll(ped, true)
        SetEntityInvincible(ped, true)
        SetEntityProofs(ped, true, true, true, true, true, true, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        Citizen.Wait(1000)

        if v.task == 'animation' then
            FreezeEntityPosition(ped, true)

            RequestAnimDict(v.animdict)
            while not HasAnimDictLoaded(v.animdict) do
                Citizen.Wait(50)
            end

            TaskPlayAnim(ped, v.animdict, v.animation, 8.0, 8.0, -1, 9, 1.0, false, false, false)
        end

        if v.task == 'wander' then
            FreezeEntityPosition(ped, false)
            TaskWanderInArea(ped, v.x, v.y, v.z, 10.0, 2, 10.0)
        end

        SetModelAsNoLongerNeeded(model)
    end
end
