--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Comandos
  ]]

-- Reivindicar balao
minetest.register_chatcommand("sethome", {
	privs = {},
	params = "Nenhum",
	description = "Reivindica um balao no local",
	func = function(name,  param)
		telepro.acessar(minetest.get_player_by_name(name))
	end
})

minetest.register_chatcommand("home", {
	privs = {},
	params = "Nenhum",
	description = "Vai para o balao",
	func = function(name,  param)
		minetest.chat_send_player(name, "Utilize o Bau do Balao para isso.")
	end
})
