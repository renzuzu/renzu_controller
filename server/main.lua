if not config.item then return end
if not lib then return end
lib.callback.register('renzu_controller:SetController', function(src,data)
	local ox_inventory = exports.ox_inventory
	local metadata = {plate = data.plate, type = data.plate}
	ox_inventory:SetMetadata(src, data.slot, metadata)
	return true
end)