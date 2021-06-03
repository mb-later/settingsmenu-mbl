RLCore, gps, blips = nil, false, {}
Citizen.CreateThread(function()
    while RLCore == nil do
        TriggerEvent('RLCore:GetObject', function(obj) RLCore = obj end)
        Citizen.Wait(1)
    end
end) 

local display = false

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end



local opened = false
RegisterNetEvent("wp-gps:OpenNui")
AddEventHandler("wp-gps:OpenNui", function(tanertimucindeadly)
    if not opened then
        SendNUIMessage({
            action = "opennnui",
            job = RLCore.Functions.GetPlayerData().job
        })
        SetNuiFocus(true, true)
        opened = true
    else
        SendNUIMessage({
            action = "closenui",
        })
        SetNuiFocus(false, false)
        opened = false
    end
end)

RegisterNUICallback("kapat", function ()
    SendNUIMessage({
        action = "closenui",
    })
    SetNuiFocus(false, false)
    opened = false
end)
RegisterNUICallback("gpsacma", function(data)
    if not gps then
    TriggerServerEvent('wp:gps:server:openGPS', RLCore.Functions.GetPlayerData().metadata.callsign)
    gps = true
    else
       ----("GPS Zaten açık.")
    end
end)

RegisterNUICallback("gpskapama", function ()
    if gps then
    TriggerServerEvent('wp:gps:server:closeGPS')
    gps = false
    else
       ----("Zaten GPS Kapalı.")
    end
end)


RegisterNUICallback("hudkapama", function()
    exports["pw_hud"]:toggleHud(false)
end)

RegisterNUICallback("hudac", function ()
    exports["pw_hud"]:toggleHud(true)
end)


RegisterNetEvent('wp:gps:client:closed')
AddEventHandler('wp:gps:client:closed', function()
    gps = false
end)


RegisterNetEvent('wp:gps:client:getPlayerInfo')
AddEventHandler('wp:gps:client:getPlayerInfo', function(table)
	local arac = false
	local heli = false
	local hareketli = false
    if GetPlayerServerId(PlayerId()) ~= table.src then
        if DoesBlipExist(blips[table.src]) then
            RemoveBlip(blips[table.src])
        end
        if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(table.src)), true) then
            arac = true
        else
            arac = false
        end
        if IsVehicleSirenOn(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(table.src)), true)) then
            hareketli = true
        else
            hareketli = false
        end
        if IsPedInFlyingVehicle(GetPlayerPed(GetPlayerFromServerId(table.src))) then
            heli = true
        else
            heli = false
        end
        blips[table.src] = AddBlipForCoord(table.coord.x, table.coord.y, table.coord.z)
        if not hareketli and not arac and not heli then
            SetBlipSprite(blips[table.src], 373)
        elseif arac and not heli and not hareketli then
            SetBlipSprite(blips[table.src], 373)
        elseif hareketli and arac and not heli then
            SetBlipSprite(blips[table.src], 42)
        elseif heli and not hareketli and arac then
            SetBlipSprite(blips[table.src], 15)
        end
        if not hareketli and not arac and not heli then
            SetBlipColour(blips[table.src], 63)
        elseif arac and not heli and not hareketli then
            SetBlipColour(blips[table.src], 63)
        elseif hareketli and arac and not heli then
            SetBlipColour(blips[table.src], 0)
        elseif heli and not hareketli and arac then
            SetBlipColour(blips[table.src], 0)
        end
        SetBlipScale(blips[table.src], 0.7)
        SetBlipAsShortRange(blips[table.src], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(table.text)
        EndTextCommandSetBlipName(blips[table.src])
	end
end)

RegisterNetEvent('wp:gps:client:removeBlip')
AddEventHandler('wp:gps:client:removeBlip', function(src)
    local blip = blips[src]
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
        blips[src] = nil
    end
end)

local aktifbliplerbenzin = {}
local aktifbliplertatto = {}
local aktifbliplerkiyafetci = {}
local aktifbliplerberber = {}
local aktifbliplermarket = {}
local aktifbliplergaraj = {}
local aktifbliplerbanka = {}
local aktifbliplersilahci = {}
local blipbenzin = false
local blipmarket = false
local blipkiyafetci = false
local blipsilahci = false
local blipbanka = false
local bliptatto = false
local blipberber = false
local blipgaraj = false
Config = {}

RegisterNUICallback("blipbenzin", function()
    if blipbenzin then
		--
        --exprts['mythic_notify']:DoHudText('error', 'Benzin bliplerini kapattın!')
		pasifblipbenzin()
        blipbenzin = false
    else
       ----("Benzin bliplerini açtın!")
		aktifblipbenzin()
        blipbenzin = true
	end
end)

RegisterNUICallback("silah", function()
    if blipsilahci then
        --
		pasifblipsilahci()
        blipsilahci = false
    else
       ----("Silahçı bliplerini açtın!")
		aktifblipsilahci()
        blipsilahci = true
	end
end)

RegisterNUICallback("banka", function()
    if blipbanka then
       ----("Banka bliplerini kapattın!")
		pasifblipbanka()
        blipbanka = false
    else
       ----("Banka bliplerini açtın!")
		aktifblipbanka()
        blipbanka = true
	end
end)

RegisterNUICallback("garage", function()
    if blipgaraj then
		--("Garaj bliplerini kapattın!")
		pasifblipgaraj()
		blipgaraj = false
    else
       ----("Garaj bliplerini açtın!")
		aktifblipgaraj()
		blipgaraj = true
	end
end)


RegisterNUICallback("tatto", function()
    if bliptatto then
       ----("Dövmeci bliplerini kapattın!")
		pasifbliptatto()
		bliptatto = false
    else
       ----("Dövmeci bliplerini açtın!")
		aktifbliptatto()
		bliptatto = true
	end
end)

RegisterNUICallback("barber", function()
    if blipberber then
		--("Berber bliplerini kapattın!")
		pasifblipberber()
		blipberber = false
    else
		--("Berber bliplerini açtın!")
		aktifblipberber()
		blipberber = true
	end
end)

RegisterNUICallback("giyafet", function()
    if blipkiyafetci then
       ----("Kıyafetçi bliplerini kapattın!")
		pasifblipkiyafet()
		blipkiyafetci = false
    else
		--("Kıyafetçi bliplerini açtın!")
		aktifblipkiyafet()
		blipkiyafetci = true
	end
end)

function aktifblipbenzin()
	for k,v in pairs(Config.GasStations) do
		print(v)
		local blipbenzin = AddBlipForCoord(v)
		SetBlipSprite(blipbenzin, 361)
		SetBlipScale(blipbenzin, 0.6)
		SetBlipColour(blipbenzin, 1)
		SetBlipDisplay(blipbenzin, 4)
		SetBlipAsShortRange(blipbenzin, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Benzin İstasyonu")
		EndTextCommandSetBlipName(blipbenzin)
		table.insert(aktifbliplerbenzin, blipbenzin)
	end
end

function aktifblipsilahci()
	for k,v in pairs(Config.Silahci) do
		print(v)
		local blipsilahci = AddBlipForCoord(v)
		SetBlipSprite(blipsilahci, 110)
		SetBlipScale(blipsilahci, 0.7)
		SetBlipColour(blipsilahci, 1)
		SetBlipDisplay(blipsilahci, 4)
		SetBlipAsShortRange(blipsilahci, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Silahçı")
		EndTextCommandSetBlipName(blipsilahci)
		table.insert(aktifbliplersilahci, blipsilahci)
	end
end

function aktifblipbanka()
	for k,v in pairs(Config.Banka) do
		print(v)
		local blipbanka = AddBlipForCoord(v)
		SetBlipSprite(blipbanka, 108)
		SetBlipScale(blipbanka, 0.8)
		SetBlipColour(blipbanka, 0)
		SetBlipDisplay(blipbanka, 4)
		SetBlipAsShortRange(blipbanka, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Banka")
		EndTextCommandSetBlipName(blipbanka)
		table.insert(aktifbliplerbanka, blipbanka)
	end
end

function aktifblipgaraj()
	for k,v in pairs(Config.Garaj) do
		print(v)
		local blipgaraj = AddBlipForCoord(v)
		SetBlipSprite(blipgaraj, 357)
		SetBlipScale(blipgaraj, 0.6)
		SetBlipColour(blipgaraj, 67)
		SetBlipDisplay(blipgaraj, 4)
		SetBlipAsShortRange(blipgaraj, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Garaj")
		EndTextCommandSetBlipName(blipgaraj)
		table.insert(aktifbliplergaraj, blipgaraj)
	end
end

function aktifblipmarket()
	for k,v in pairs(Config.Marketler) do
		print(v)
		local blipmarket = AddBlipForCoord(v)
		SetBlipSprite(blipmarket, 52)
		SetBlipScale(blipmarket, 0.6)
		SetBlipColour(blipmarket, 2)
		SetBlipDisplay(blipmarket, 4)
		SetBlipAsShortRange(blipmarket, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Market")
		EndTextCommandSetBlipName(blipmarket)
		table.insert(aktifbliplermarket, blipmarket)
	end
end

function aktifblipkiyafet()
	for k,v in pairs(Config.Kiyafetci) do
		print(v)
		local blipkiyafetci = AddBlipForCoord(v)
		SetBlipSprite(blipkiyafetci, 73)
		SetBlipScale(blipkiyafetci, 0.6)
		SetBlipColour(blipkiyafetci, 17)
		SetBlipDisplay(blipkiyafetci, 4)
		SetBlipAsShortRange(blipkiyafetci, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Kıyafetçi")
		EndTextCommandSetBlipName(blipkiyafetci)
		table.insert(aktifbliplerkiyafetci, blipkiyafetci)
	end
end

function aktifblipberber()
	for k,v in pairs(Config.Berber) do
		print(v)
		local blipberber = AddBlipForCoord(v)
		SetBlipSprite(blipberber, 71)
		SetBlipScale(blipberber, 0.6)
		SetBlipColour(blipberber, 64)
		SetBlipDisplay(blipberber, 4)
		SetBlipAsShortRange(blipberber, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Berber")
		EndTextCommandSetBlipName(blipberber)
		table.insert(aktifbliplerberber, blipberber)
	end
end

function aktifbliptatto()
	for k,v in pairs(Config.Dovmeci) do
		print(v)
		local bliptatto = AddBlipForCoord(v)
		SetBlipSprite(bliptatto, 75)
		SetBlipScale(bliptatto, 0.6)
		SetBlipColour(bliptatto, 34)
		SetBlipDisplay(bliptatto, 4)
		SetBlipAsShortRange(bliptatto, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Dövmeci")
		EndTextCommandSetBlipName(bliptatto)
		table.insert(aktifbliplertatto, bliptatto)
	end
end

function pasifblipbenzin()
	for i = 1, #aktifbliplerbenzin do
		RemoveBlip(aktifbliplerbenzin[i])
	end

	for i = 1, #aktifbliplerbenzin do
		table.remove(aktifbliplerbenzin)
	end
end

function pasifblipsilahci()
	for i = 1, #aktifbliplersilahci do
		RemoveBlip(aktifbliplersilahci[i])
	end

	for i = 1, #aktifbliplersilahci do
		table.remove(aktifbliplersilahci)
	end
end

function pasifblipbanka()
	for i = 1, #aktifbliplerbanka do
		RemoveBlip(aktifbliplerbanka[i])
	end

	for i = 1, #aktifbliplerbanka do
		table.remove(aktifbliplerbanka)
	end
end

function pasifblipgaraj()
	for i = 1, #aktifbliplergaraj do
		RemoveBlip(aktifbliplergaraj[i])
	end

	for i = 1, #aktifbliplergaraj do
		table.remove(aktifbliplergaraj)
	end
end

function pasifblipmarket()
	for i = 1, #aktifbliplermarket do
		RemoveBlip(aktifbliplermarket[i])
	end

	for i = 1, #aktifbliplermarket do
		table.remove(aktifbliplermarket)
	end
end

function pasifbliptatto()
	for i = 1, #aktifbliplertatto do
		RemoveBlip(aktifbliplertatto[i])
	end

	for i = 1, #aktifbliplertatto do
		table.remove(aktifbliplertatto)
	end
end

function pasifblipberber()
	for i = 1, #aktifbliplerberber do
		RemoveBlip(aktifbliplerberber[i])
	end

	for i = 1, #aktifbliplerberber do
		table.remove(aktifbliplerberber)
	end
end

function pasifblipkiyafet()
	for i = 1, #aktifbliplerkiyafetci do
		RemoveBlip(aktifbliplerkiyafetci[i])
	end

	for i = 1, #aktifbliplerkiyafetci do
		table.remove(aktifbliplerkiyafetci)
	end
end


-- Lokasyonlar
Config.GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(1784.324, 3330.55, 41.253)
}

Config.Dovmeci = {
	vector3(1322.645, -1651.976, 52.275),
	vector3(-1153.676, -1425.68, 4.954),
	vector3(322.139, 180.467, 103.587),
	vector3(-3170.071, 1075.059, 20.829),
	vector3(1864.633, 3747.738, 33.032),
	vector3(-293.713, 6200.04, 31.487),
	vector3(-1220.6872558594, -1430.6593017578, 4.3321843147278),
	vector3(-1115.3640136719, -1658.7386474609, 4.3555798530579)
}

Config.Silahci = {
	vector3(22.02, -1106.67, 29.8),
	vector3(252.51, -50.42, 69.94),
	vector3(810.23, -2157.7, 29.62),
	vector3(842.53, -1033.99, 28.19),
	vector3(2567.61, 293.86, 108.73),
	vector3(-330.46, 6084.21, 31.45),
	vector3(-1305.5, -394.54, 36.7),
	vector3(-3172.27, 1087.96, 20.84)
}

Config.Banka = { 
	vector3(150.266, -1040.203, 29.374),
    vector3(-1212.980, -330.841, 37.787),
    vector3(-2962.582, 482.627, 15.703),
    vector3(-112.202, 6469.295, 31.626),
    vector3(314.187, -278.621, 54.170),
    vector3(-351.534, -49.529, 49.042),
    vector3(241.727, 220.706, 106.286),
    vector3(1175.0643310547, 2706.6435546875, 38.094036102295)
}

Config.Berber = {
	vector3(1932.0756835938, 3729.6706542969, 32.844413757324),
	vector3(-278.19036865234, 6228.361328125, 31.695510864258),
	vector3(1211.9903564453, -472.77117919922, 66.207984924316),
	vector3(-33.224239349365, -152.62608337402, 57.076496124268),
	vector3(136.7181854248, -1708.2673339844, 29.291622161865),
	vector3(-815.18896484375, -184.53868103027, 37.568943023682),
	vector3(-1283.2886962891, -1117.3210449219, 6.9901118278503)
}

Config.Kiyafetci = {
	vector3(1693.45667, 4823.17725, 43.1631294600 ),
	vector3(-1177.865234375,-1780.5612792969,4.9084651470184600),
	vector3(-712.215881,-155.352982, 38.4151268600),
	vector3(-1192.94495,-772.688965, 18.32559971500),
	vector3(425.236,-806.008,29.491600),
	vector3(-162.658,-303.397,39.733600),
	vector3(75.950,-1392.891,29.376600),
	vector3(-822.194,-1074.134,11.328600),
	vector3(-1450.711,-236.83,49.809600),
	vector3(4.254,6512.813,31.877600),
	vector3(615.180,2762.933,42.088600),
	vector3(1196.785,2709.558,38.222600),
	vector3(-3171.453,1043.857,20.863600),
	vector3(-1100.959,2710.211,19.107600),
	vector3(-1207.6564941406,-1456.8890380859,4.3784737586975600),
	vector3(121.76,-224.6,54.56600),
	vector3(1784.13, 2492.6, 51.43)
}

-- Config.Marketler = {
--     vector3(44.38, -1746.76, 29.5),
--     vector3(-48.31, -1757.94, 29.42),
--     vector3(25.75, -1347.27, 29.5),
--     vector3(1135.63, -982.75, 46.42),
--     vector3(1163.69, -323.92, 69.21),
--     vector3(2557.39, 382.07, 108.62),
--     vector3(373.59, 325.57, 103.57),
--     vector3(547.77, 2671.55, 42.16),
--     vector3(1393.2, 3605.22, 34.98),
--     vector3(1961.16, 3740.57, 32.34),
--     vector3(1165.37, 2709.44, 38.16),
--     vector3(1697.81, 4924.54, 42.06),
--     vector3(1728.85, 6414.45, 35.04),
--     vector3(-3241.78, 1001.12, 12.83),
--     vector3(-2967.89, 390.96, 15.04),
--     vector3(-707.40985107422, -914.43499755859, 19.215589523315)
-- }

Config.Garaj = {
    vector3(-187.56056213379, -1920.9401855469, 13.25),
    vector3(-1160.2678222656, -2118.9196777344, 13.26203918457),
    vector3(992.19549560547, -127.01154327393, 74.060836791992),
    vector3(1203.6268310547, -1266.2015380859, 35.225021362305),
    vector3(-1188.9903564453, -1488.4056396484, 4.3792991638184),
    vector3(1725.5695800781, 3719.3254394531, 34.120059967041),
    vector3(139.87911987305, 6598.8393554688, 31.844926834106),
    vector3(1867.8118896484, 2603.0512695312, 45.67200088501),
    vector3(-15.39942741394, -1088.1169433594, 26.670660018921),
    vector3(278.55981445312, -333.03549194336, 44.919986724854),
    vector3(472.67477416992, -1096.6665039062, 29.201877593994),
    vector3(-694.44525146484, -748.97009277344, 29.350624084473),
    vector3(-576.98199462891, 323.44104003906, 84.677368164062),
    vector3(376.0910949707, 279.88421630859, 103.13893890381),
    vector3(810.88684082031, -2408.1333007812, 23.670387268066),
    vector3(-1650.4202880859, -901.32391357422, 8.6484937667847),
    vector3(-3146.63671875, 1094.67578125, 20.697641372681),
    vector3(-355.50500488281, -93.077239990234, 45.661632537842),
    vector3(-2207.4699707031, 4252.494140625, 47.447635650635),
    vector3(-1146.6231689453, 2668.9641113281, 18.302381515503),
    vector3(589.60516357422, 2731.5895996094, 42.057125091553),
    vector3(1689.5728759766, 4776.31640625, 41.92147064209),
    vector3(2571.8979492188, 321.80996704102, 108.45532226562),
    vector3(29.258485794067, -1731.5091552734, 29.301292419434),
    vector3(295.83474731445, -607.89019775391, 43.332038879395),
    vector3(975.08795166016, -1019.3695068359, 41.045555114746),
    vector3(-445.21682739258, 6048.5654296875, 31.340208053589),
    vector3(1824.5526123047, 3656.9858398438, 34.100635528564),
    vector3(4976.486328125, -5705.8837890625, 19.867332458496),
    vector3(5156.3657226562, -4615.7919921875, 2.7846808433533),
    vector3(5013.6728515625, -5182.90625, 2.5148439407349),
    vector3(4500.6845703125, -4544.7963867188, 4.0230841636658),
    vector3(336.85919189453, -621.48919677734, 29.293952941895),
    vector3(550.26031494141, -1791.1641845703, 29.197011947632),
    
}