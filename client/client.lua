Citizen.CreateThread(function()
    Citizen.Wait(10000)

    SpawnPedestrians()
end)

function SpawnPedestrians()
    for _, v in pairs(Config.Peds) do
        local model = GetHashKey(v.ped)

        if TryToRequestModel(model) then
            local ped = CreatePed(28, model, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, false)
            SetEntityHeading(ped, v.coords.w)
            FreezeEntityPosition(ped, true)
            SetPedCanRagdoll(ped, true)
            SetEntityInvincible(ped, true)
            SetEntityProofs(ped, true, true, true, true, true, true, true, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            Citizen.Wait(1000)

            if v.task == 'animation' then
                FreezeEntityPosition(ped, true)

                if TryToRequestAnimDict(v.animdict) then
                    TaskPlayAnim(ped, v.animdict, v.animation, 8.0, 8.0, -1, 9, 1.0, false, false, false)
                else
                    DeletePed(ped)
                end
            elseif v.task == 'wander' then
                FreezeEntityPosition(ped, false)
                TaskWanderInArea(ped, v.coords.x, v.coords.y, v.coords.z, v.wanderradius, v.wanderlength, v.wanderwait)
            end
        end

        SetModelAsNoLongerNeeded(model)
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