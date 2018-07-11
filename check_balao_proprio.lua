--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Verificar balao
  ]]

--[[ Retorna os seguintes argumentos
	1) numero do erro encontrado 
		0 significa que nenhum dos erros ocorreu (1, 2, 3 e etc)
		1 significa falta do registro no banco de dados (jogador nao tem balao)
		2 significa que o balao do jogador esta inativo/inoperante
		3 significa que o jogador nao se encontra perto do bau do balao
	2) String de texto referente ao problema, nil caso nenhum problema
]]
telepro.check_balao_proprio = function(player)
	local name = player:get_player_name()
	
	-- Verificar se o jogador tem um balao
	if telepro.bd.verif("jogador_"..name, "pos") ~= true then
		minetest.chat_send_player(name, "Precisas ter um balao ativo")
		return 1, "Nenhum balao proprio existente"
	end
	
	-- Pega os metadados do bau
	local meta = minetest.get_meta(telepro.bd.pegar("jogador_"..name, "pos"))
	if meta:get_string("status") ~= "ativo" then
		return 2, "Balao proprio inoperante"
	end
	
	-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
	if telepro.verif_prox_bau(player) == false then
		return 3, "Muito distante do proprio Bau de Balao"
	end
	
	return 0
end
