--[[
	Mod Telepro para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Balao Decorativo para Spawn
  ]]

local S = telepro.S

-- Node
minetest.register_node("telepro:node_balao_decorativo", {
	description = S("Node de Balao Decorativo"),
	tiles = {"telepro_balao.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	drawtype = "mesh",
	mesh = "telepro_node_balao.b3d",
	visual_scale = 0.45,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_wood_defaults(),
	drop = "",
})

-- Node de inventario
minetest.register_node("telepro:balao_decorativo", {
	description = S("Balao Decorativo"),
	tiles = {"telepro_balao.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	drawtype = "mesh",
	mesh = "telepro_node_balao_inv.b3d",
	visual_scale = 1,
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	drop = "",
	
	on_construct = function(pos)
		minetest.set_node(pos, {name = "telepro:node_balao_decorativo"})
	end,
})
