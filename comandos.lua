--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Comandos
  ]]

local S = telepro.S

-- Reivindicar balao
minetest.register_chatcommand("balloon", {
	privs = {},
	description = S("Painel de Balao"),
	func = function(name,  param)
		telepro.acessar(minetest.get_player_by_name(name))
	end
})
