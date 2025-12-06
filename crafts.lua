
-- Curtis r3c0
minetest.register_craftitem("curtiss_r3c0:curtiss_r3c0", {
	description = "Curtis R3C-0",
	inventory_image = "curtis-r3c0-ico.png",
    liquids_pointable = true,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
        
        local pointed_pos = pointed_thing.under

        local node_below = minetest.get_node(pointed_pos).name
        local nodedef = minetest.registered_nodes[node_below]
        if nodedef.liquidtype == "none" then return end

        --local node_below = minetest.get_node(pointed_pos).name
        --local nodedef = minetest.registered_nodes[node_below]
        
		pointed_pos.y=pointed_pos.y+2.3
		local curtiss_rc30_ent = minetest.add_entity(pointed_pos, "curtiss_r3c0:curtiss_r3c0")
		if curtiss_rc30_ent and placer then
            local ent = curtiss_rc30_ent:get_luaentity()
            if ent then
                local owner = placer:get_player_name()
                ent.owner = owner
			    curtiss_rc30_ent:set_yaw(placer:get_look_horizontal())
			    itemstack:take_item()
                airutils.create_inventory(ent, ent._trunk_slots, owner)
            end
		end

		return itemstack
	end,
})


