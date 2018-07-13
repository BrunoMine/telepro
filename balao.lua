--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Balao
  ]]

local S = telepro.S

-- Pegar node distante nao carregado
local function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end

-- Node
minetest.register_node("telepro:balao_jogador", {
	description = S("Balao Decorativo"),
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

-- Verifica se tem bau ativo
minetest.register_abm{
	nodenames = {"telepro:balao_jogador"},
	interval = 4,
	chance = 1,
	action = function(pos)
		
		-- Pos bau
		local pos_bau = {x=pos.x, y=pos.y-25, z=pos.z}
		
		-- Bau
		local node = pegar_node(pos_bau)
		
		-- Verifica se tem bau
		if node.name ~= "telepro:bau" then
			minetest.remove_node(pos)
			return
		end
		
		-- Pegar metadados do bau
		local meta = minetest.get_meta(pos_bau)
		
		-- Verifica se o bau tem dono
		if meta:get_string("dono") == "" then 
			minetest.remove_node(pos)
			return
		end
		
		-- Verifica se o bau ta ativo
		if meta:get_string("status") ~= "ativo" then 
			minetest.remove_node(pos)
			return
		end
		
	end,
}
