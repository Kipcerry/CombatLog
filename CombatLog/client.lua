local CombatLog = ''
local CombatTimer = 0

local Health = GetEntityHealth(PlayerPedId())

AddEventHandler("playerSpawned", function()
    Health = GetEntityHealth(PlayerPedId())
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/'..Config.Command, Config.CommandInfo)
    TriggerEvent('chat:addSuggestion', '/'..Config.WipeCommand, Config.WipeCommandInfo)
end)

RegisterCommand(Config.Command, function()
    if CombatTimer > 0 then
        print(Config.CombatTimer..CombatTimer..' '..Config.Seconds)
    else
        print(CombatLog)
    end
end, false)

RegisterCommand(Config.WipeCommand, function()
    if CombatTimer > 0 then
        print(Config.CombatTimer..CombatTimer..''..Config.Seconds)
    else
        CombatLog = ''
    end
end, false)


function GameEventTriggered(name, args)
    if name == "CEventNetworkEntityDamage" then
        local Entity, Destroyer, _, isFatal, weapon_old, weapon_old2, Weapon = table.unpack(args)
        local PlayerPed = PlayerPedId()
        if Weapon == 0 or Weapon == 1 then
            Weapon = Weapon
        end
        if Entity == PlayerPed then
            local Player = NetworkGetPlayerIndexFromPed(Destroyer)
            local NewHealth = GetEntityHealth(PlayerPed)
            local hit, Bone = GetPedLastDamageBone(PlayerPed)
            local Data = {
                WaiteaponHash = Weapon,
                BoneIndex = Bone
            }
            if NewHealth ~= health then
                if Loaded and NewHealth then
                    SetResourceKvp(GetServerIdentifier() .. "Data", json.encode({ dead = IsPlayerDead(PlayerId()) and IsPedDeadOrDying(PlayerPedId()), Health = Health }))
                end
                if not Player or Player <= 0 then
                    Player = PlayerId()
                    Data.distance = 0
                else
                    Data.distance = #(GetEntityCoords(PlayerPed) - GetEntityCoords(Destroyer))
                end

                if Health - 100 > 0 then
                    Health = Health - 100
                end
                if NewHealth - 100 > 0 then
                    NewHealth = NewHealth - 100
                end
                Damage = Health - NewHealth
                local OwnLog = ''
                local OtherLog = ''
                if Config.ShooterIdLog then
                    OwnLog = OwnLog..Config.Shooter..': ID:'..GetPlayerServerId(Player)..' || '..Config.Victim..': '..Config.Yourself..' ||'
                    OtherLog = OtherLog..Config.Shooter..': '..Config.Yourself..' || '..Config.Victim..' ID:'..GetPlayerServerId(PlayerId())..' ||'
                end
                if Config.WeaponLog then
                    if Weapon then
                        OwnLog = OwnLog..' '..Config.Weapon..': '..tostring(Weapons[Weapon] or Weapon)..' ||'
                        OtherLog = OtherLog..' '..Config.Weapon..': '..tostring(Weapons[Weapon] or Weapon)..' ||'
                    else
                        OwnLog = OwnLog..' '..Config.Weapon..': '..Config.Unknown..' ||'
                        OtherLog = OtherLog..' '..Config.Weapon..': '..Config.Unknown..' ||'
                    end
                end
                if Config.BoneLog then
                    OwnLog = OwnLog..' '..Config.Bone..': '..GetPedBoneLabelOrName(Bone)..' ||'
                    OtherLog = OtherLog..' '..Config.Bone..': '..GetPedBoneLabelOrName(Bone)..' ||'
                end
                if Config.DamageLog then
                    OwnLog = OwnLog..' '..Config.Damage..': '..Damage..' ||'
                    OtherLog = OtherLog..' '..Config.Damage..': '..Damage..' ||'
                end
                if Config.OldAndNewHPLog then
                    OwnLog = OwnLog..' '..Config.OldHP..': '..Health..' || '..Config.NewHP..': '..NewHealth..' ||'
                    OtherLog = OtherLog..' '..Config.OldHP..': '..Health..' || '..Config.NewHP..': '..NewHealth..' ||'
                end
                if Config.DistanceLog then
                    OwnLog = OwnLog..' '..Config.Distance..': '..math.round(Data.distance)..' ||'
                    OtherLog = OtherLog..' '..Config.Distance..': '..math.round(Data.distance)..' ||'
                end
                OwnLog = OwnLog..'\n'
                OtherLog = OtherLog..'\n'

                TriggerServerEvent('CombatLog:Send', OtherLog, GetPlayerServerId(Player))
                CombatLog = CombatLog..OwnLog
                CombatTimer = Config.CombatDelay
                Health = NewHealth
            end
        end
    end
end



RegisterNetEvent('CombatLog:Receive', function(Message)
    CombatLog = CombatLog..Message
    CombatTimer = Config.CombatDelay
end)


Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if CombatTimer > 0 then
            CombatTimer = CombatTimer - 1
        end
    end
end)

RegisterNetEvent("gameEventTriggered")
AddEventHandler("gameEventTriggered", GameEventTriggered)

function GetPedSpeed(ped, vehicle)
    vehicle = vehicle or GetVehiclePedIsIn(ped)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        return GetEntitySpeed(vehicle)
    else
        return GetEntitySpeed(ped)
    end
end

function GetPedBoneLabelOrName(bone)
    if Bones[bone] then
        return Bones[bone].label or Bones[bone].name
    end

    return bone
end

function GetPedBoneLabel(bone)
    if Bones[bone] then
        return Bones[bone].label
    end
end