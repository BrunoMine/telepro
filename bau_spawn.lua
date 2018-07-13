--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bau do balao do spawn
  ]]

local S = telepro.S

-- Node
minetest.register_node("telepro:bau_spawn", {
	description = S("Bau do Balao do Centro"),
	tiles = {
		"default_chest_top.png^telepro_bau_cima.png", -- Cima
		"default_chest_top.png", -- Baixo
		"default_chest_side.png^telepro_bau_direita.png", -- Direita
		"default_chest_side.png^telepro_bau_esquerda.png", -- Esquerda
		"default_chest_side.png^telepro_bau_fundo.png", -- Fundo
		"default_chest_front.png" -- Frente
	},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, player)
		telepro.acessar_bau_spawn(player)
	end,
	
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		-- Verifica privilegios de quem coloca
		if pointed_thing and pointed_thing.above and minetest.check_player_privs(placer:get_player_name(), {server=true}) == true then
			telepro.spawn = pos
			telepro.bd.salvar("centro", "pos", {x=pos.x, y=pos.y+2, z=pos.z})
			minetest.chat_send_player(placer:get_player_name(), S("Novo centro definido"))
		else
			minetest.chat_send_player(placer:get_player_name(), S("Precisa do privilegio 'server' para colocar esse bau"))
			minetest.remove_node(pos)
		end
	end,
	
	drop = "",
})
