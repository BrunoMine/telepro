--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Função para teleportar para balao
  ]]

local S = telepro.S

-- Pegar node, mesmo que não esteja na memoria
local function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end

-- Teleportar jogador para o posto de seu balao
telepro.ir_balao = function(player)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.reivindicar)")
		return false
	end
	
	-- Pegar nome do jogador
	local name = player:get_player_name()
	
	-- Verifica se o registro de balao existe no banco de dados
	if telepro.bd.verif("jogador_"..name, "pos") == false then
		minetest.chat_send_player(player:get_player_name(), S("Sem nenhum balao ainda"))
		return false
	end
	
	-- Pegar coordenada do bau
	local pos = telepro.bd.pegar("jogador_"..name, "pos")
	
	-- Verificar se o balao existente no banco de dados ainda existe no mapa
	do
		
		-- Verificar se o nome do bloco é o de uma bau
		-- CANCELADO: não deve ser necessario, isso pode atrapalhar muito o retorno do jogador, ao retornar ele resolvera isso
		--if pegar_node(pos).name ~= "telepro:bau" then
		--	minetest.chat_send_player(player:get_player_name(), S("Seu balao foi destruido"))
		--	return false
		--end
		
		-- Pega os metadados do bau
		local meta = minetest.get_meta(pos)
		
		-- Pega o nome do dono do bau
		local n = meta:get_string("dono") or ""
		
		-- Verifica se é o mesmo nome do jogador
		-- CANCELADO: não deve ser necessario, isso pode atrapalhar muito o retorno do jogador, ao reto
		--if n ~= name then
		--	minetest.chat_send_player(player:get_player_name(), S("Seu balao foi destruido"))
		--	return false
		--end
		
	end
	
	--Teleporta o jogador para o balao
	player:setpos({x=pos.x, y=pos.y+1.5, z=pos.z})
	
	-- Finaliza
	minetest.chat_send_player(player:get_player_name(), S("Viagem para o posto de seu balao realizada"))
	return true
	
end
