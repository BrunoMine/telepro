--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Corda do Balao
  ]]

-- Variavel que impede que cordas sejam colocadas (ativa as verificações da fisica das cordas)
telepro.cordas_f = true

-- Node
minetest.register_node("telepro:corda_balao", {
	description = "Corda de Balao",
	drawtype = "torchlike",
	tiles = {"telepro_corda_balao.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {0, 0, 0, 0, 0, 0},
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	drop = "",
	
	-- Ao ser removido de uma pos
	after_destruct = function(pos)
		-- Remove corda abaixo
		if telepro.cordas_f == true and minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "telepro:corda_balao" then
			minetest.remove_node({x=pos.x,y=pos.y-1,z=pos.z})
		end
	end,
	
	-- Ao ser colocado de uma pos
	on_construct = function(pos)
		-- Remove caso nao tenha corda em cima
		if telepro.cordas_f == true and minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name ~= "telepro:corda_balao" then
			minetest.remove_node(pos)
		end
	end,
})
