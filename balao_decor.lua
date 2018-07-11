--[[
	Mod Telepro para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Balao Decorativo para Spawn
  ]]

-- Node
minetest.register_node("telepro:balao_decorativo", {
	description = "Balao Decorativo",
	tiles = {"telepro_balao.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	drawtype = "mesh",
	mesh = "telepro_node_balao.b3d",
	visual_scale = 0.45,
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	drop = "",
})
