local showui = false
Controller = function(data, item)
	local closestvehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	local plate = string.gsub(GetVehicleNumberPlateText(closestvehicle), '^%s*(.-)%s*$', '%1'):upper()
	local controllers = exports.ox_inventory:Search('slots', 'vehiclecontroller')
	local hasdata = true
	local metadata = {}
	for _, v in pairs(controllers) do
		if item.slot == v.slot and v.metadata and v.metadata.plate == nil or item.slot == v.slot and v.metadata == nil then
			hasdata = false
		end
		if item.slot == v.slot and v.metadata and v.metadata.plate then
			metadata.plate = v.metadata.plate
		end
	end
	if hasdata and metadata.plate and metadata.plate ~= plate then
		lib.notify({
			title = 'This Remote is already registered in other vehicle : Plate - '..metadata.plate,
			type = 'error'
		})
		return
	end
	local saved = not hasdata and lib.callback.await('renzu_controller:SetController', 100, {plate = plate, slot = item.slot})
	SendNUIMessage({ show = not showui, plate = plate})
	SetNuiFocus(not showui,not showui)
	SetNuiFocusKeepInput(false)
	SetVehicleEngineOn(closestvehicle,true,true)
	print(saved)
	if saved then
		lib.notify({
			title = 'Successfully register Plate: '..plate..' in this remote',
			type = 'success'
		})
	end
	showui = not showui
end

function GetClosestVehicle(c,dist)
	local closest = 0
	for k,v in pairs(GetGamePool('CVehicle')) do
		local dis = #(GetEntityCoords(v) - c)
		if dis < dist 
		    or dist == -1 then
			closest = v
			dist = dis
		end
	end
	return closest, dist
end

exports('Control', Controller)

AddStateBagChangeHandler('height' --[[key filter]], nil --[[bag filter]], function(bagName, key, value, _unused, replicated)
	Wait(0)
	if not value then return end
	local net = tonumber(bagName:gsub('entity:', ''), 10)
	local vehicle = net and NetworkGetEntityFromNetworkId(net)
	if DoesEntityExist(vehicle) then
		SetVehicleSuspensionHeight(NetworkGetEntityFromNetworkId(net),tonumber(value))
	end
end)

RegisterNUICallback('nuicb', function(data, cb)
	local closestvehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	SetEntityControlable(closestvehicle)
	SetVehicleModKit(closestvehicle,0)
	if data.msg == 'height' then
		print(data.val)
		SetVehicleSuspensionHeight(closestvehicle,-tonumber(data.val)+0.01)
		local ent = Entity(closestvehicle).state
		ent:set('height',-tonumber(data.val)+0.01, true)
	end
	if data.msg == 'neon' then
		for i = 0, 3 do
			SetVehicleNeonLightEnabled(closestvehicle,i,true)
		end
		SetVehicleNeonLightsColour(closestvehicle, data.val.r,data.val.g,data.val.b)
	end
	if data.msg == 'headlight' then
		ToggleVehicleMod(closestvehicle, 22, true)
		SetVehicleXenonLightsCustomColor(closestvehicle, data.val.r,data.val.g,data.val.b)
	end
	if data.msg == 'customheadlight' then
		ToggleVehicleMod(closestvehicle, 22, true)
		SetVehicleXenonLightsCustomColor(closestvehicle, data.val.r,data.val.g,data.val.b)
	end
	if data.msg == 'customneon' then
		ToggleVehicleMod(closestvehicle, 22, true)
		SetVehicleNeonLightsColour(closestvehicle, data.val.r,data.val.g,data.val.b)
	end
	if data.msg == 'neonstyle' then
		NeonCustom(data.val)
	end
	if data.msg == 'toggleneon' then
		for i = 0, 3 do
			SetVehicleNeonLightEnabled(closestvehicle, i, not IsVehicleNeonLightEnabled(closestvehicle,i))
		end
	end
	if data.msg == 'togglelights' then
		ToggleVehicleMod(closestvehicle, 22, not GetVehicleMod(closestvehicle, 22) == -1)
	end
	if data.msg == 'close' then
		SendNUIMessage({ show = false})
		SetNuiFocus(false,false)
		SetNuiFocusKeepInput(false)
		showui = false
	end
end)

local currentype = {}
local type = nil
NeonCustom = function(type)
	local closestvehicle = GetClosestVehicle(GetEntityCoords(cache.ped), 10.0)
	local plate = string.gsub(GetVehicleNumberPlateText(closestvehicle), '^%s*(.-)%s*$', '%1'):upper()
	currentype[plate] = type
	if type == 'neon1' then
		CreateThread(function()
			local r,g,b = GetVehicleNeonLightsColour(closestvehicle)
			while currentype[plate] == type do
				--SetVehicleNeonLightsColour(closestvehicle,255,255,255)
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(closestvehicle, i, true)
				end
				Citizen.Wait(222)
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(closestvehicle, i, false)
				end
				Citizen.Wait(222)
			end
			SetVehicleNeonLightsColour(closestvehicle,r,g,b)
			return
		end)
	elseif type == 'neon2' then
		CreateThread(function()
			local r,g,b = GetVehicleNeonLightsColour(closestvehicle)
			while currentype[plate] == type do
				--SetVehicleNeonLightsColour(closestvehicle,255,255,255)
				rand = math.random(1,4) - 1
				math.randomseed(GetGameTimer())
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				for i = rand, rand do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				Citizen.Wait(55)
				for i = rand, rand do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				Citizen.Wait(55)
				for i = rand, rand do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				Citizen.Wait(55)
				for i = rand, rand do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				Citizen.Wait(155)
				SetVehicleNeonLightsColour(closestvehicle,r,g,b)
				print('aa')
			end
			return
		end)
	elseif type == 'random' then
		CreateThread(function()
			local r,g,b = GetVehicleNeonLightsColour(closestvehicle)
			while currentype[plate] == type do
				math.randomseed(GetGameTimer())
				SetVehicleNeonLightsColour(closestvehicle,math.random(1,255),math.random(1,255),math.random(1,255))
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				Citizen.Wait(222)
				for i = 0, 3 do
					SetVehicleNeonLightEnabled(closestvehicle, i, math.random(1,100) < 50)
				end
				Citizen.Wait(222)
			end
			SetVehicleNeonLightsColour(closestvehicle,r,g,b)
			return
		end)
	else
		for i = 0, 3 do
			SetVehicleNeonLightEnabled(closestvehicle, i, true)
		end
	end
end

RegisterCommand('controller', Controller)