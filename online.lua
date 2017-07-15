--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Controle de dados temporarios para jogadores online
  ]]

-- Tabela de jogadores online
telepro.online = {}

-- Adiciona jogadores que conectam no servidor
minetest.register_on_joinplayer(function(player)
	telepro.online[player:get_player_name()] = {}
end)

-- Remove jogadors que se desconectam do servidor
minetest.register_on_leaveplayer(function(player)
	telepro.online[player:get_player_name()] = nil
end)
