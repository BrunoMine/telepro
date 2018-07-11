--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Gerar balao automaticamente
  ]]

-- Certifica de que jogador tem um balao, caso ainda não tenha cria um
minetest.register_on_joinplayer(function(player)
	if not player then return end
	
	-- Pegar nome do jogador
	local name = player:get_player_name()
	
	-- Verifica se o registro de balao existe no banco de dados
	if telepro.bd.verif("jogador_"..name, "pos") == false then
		telepro.gerar_balao_aleatorio(name)
	end
end)

