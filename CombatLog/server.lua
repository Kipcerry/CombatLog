

RegisterNetEvent('CombatLog:Send', function(Message, OtherId)
   TriggerClientEvent('CombatLog:Receive', OtherId, Message)
end)