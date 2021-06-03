
RLCore, bliptable = nil, {}
TriggerEvent('RLCore:GetObject', function(obj) RLCore = obj end)

RegisterCommand("settings", function (source)
    TriggerClientEvent("wp-gps:OpenNui", source)
end)

RegisterServerEvent('wp:gps:server:openGPS')
AddEventHandler('wp:gps:server:openGPS', function(code)
    local src = source
    local xPlayer = RLCore.Functions.GetPlayer(src)
    table.insert(bliptable, {firstname = xPlayer.PlayerData.charinfo.firstname, lastname =xPlayer.PlayerData.charinfo.lastname, src = src, job = xPlayer.PlayerData.job.label, code = code})
end)

RegisterServerEvent('wp:gps:server:closeGPS')
AddEventHandler('wp:gps:server:closeGPS', function()
    local src = source

    for k = 1, #bliptable, 1 do
        TriggerClientEvent('wp:gps:client:removeBlip', bliptable[k].src, tonumber(src))
    end

    for i = 1, #bliptable, 1 do
        if bliptable[i].src == tonumber(src) then
            table.remove(bliptable, i)
            return
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if #bliptable > 0 then
            for i = 1, #bliptable, 1 do
                local player = GetPlayerPed(bliptable[i].src)
                local coord = GetEntityCoords(player)
                for k = 1, #bliptable, 1 do
                    TriggerClientEvent('wp:gps:client:getPlayerInfo', bliptable[k].src, {
                        coord = coord,
                        job = bliptable[i].job,
                        src = tonumber(bliptable[i].src),
                        text = '['..bliptable[i].code..'] - '..bliptable[i].firstname..' '..bliptable[i].lastname,
                    })
                end
            end
        end
    end
end)

RegisterServerEvent("RLCore:Player:OnRemovedItem")
AddEventHandler("RLCore:Player:OnRemovedItem", function(source, item)
    local src = source
    local xPlayer = RLCore.Functions.GetPlayer(src)
    
    TriggerClientEvent('wp:gps:client:closed', src)

	if item.name == 'signalradar' and GetItem(source, item.name).count < 1 then
		for k = 1, #bliptable, 1 do
            TriggerClientEvent('wp:gps:client:removeBlip', bliptable[k].src, tonumber(src))
            TriggerClientEvent('wp:gps:client:removeBlip', src, tonumber(bliptable[k].src))
        end
    
        for i = 1, #bliptable, 1 do
            if bliptable[i].src == src then
                table.remove(bliptable, i)
            end
        end
	end
end)

AddEventHandler('playerDropped', function()
    local src = source
    removeBlip(src)
    removeBlip2(src)
end)

function removeBlip(src)
    for k = 1, #bliptable, 1 do
        TriggerClientEvent('wp:gps:client:removeBlip', bliptable[k].src, tonumber(src))
        return
    end
end

function removeBlip2(src)
    for i = 1, #bliptable, 1 do
        if bliptable[i].src == src then
            table.remove(bliptable, i)
            return
        end
    end
end

function GetItem(source, item)
	local xPlayer = RLCore.Functions.GetPlayer(source)
	local count = 0

	for k,v in pairs(xPlayer['PlayerData']['items']) do
		if v.name == item then
			count = count + v.amount
		end
	end
	
	return { name = item, count = count }
end