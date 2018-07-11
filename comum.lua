--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Funções simples e comuns
  ]]

-- Verificar se o bau de balaode um jogador está perto
telepro.verif_prox_bau = function(player)
	
	-- Pegar nome do jogador
	local name = player:get_player_name()
	
	-- Pegar coordenada do jogador
	local pos = player:getpos()

	-- Pegar nodes de Bau de Balao proximos
	local nodes = minetest.find_nodes_in_area(
		{x=pos.x-8, y=pos.y-8, z=pos.z-8}, 
		{x=pos.x+8, y=pos.y+8, z=pos.z+8}, 
		{"telepro:bau"}
	)
	
	-- Verifica todos os baus encontrados
	for _,p in ipairs(nodes) do
		-- Pega os metadados do bau
		local meta = minetest.get_meta(p)
		-- Pega o nome do dono do bau
		local n = meta:get_string("dono") or ""
		-- Verifica se é o mesmo nome do jogador
		if n == name then
			-- Retorna que encontrou o bau do jogador
			return true
		end
	end
	
	-- Retorna que nao encontrou o bau do jogador
	return false
	
end


-- Criar balao e cordas para um bau de balao (ignora verificações)
telepro.montar_balao = function(pos)
	
	-- Colocar cordas
	do
		-- Desativa as verificações das cordas
		telepro.cordas_f = false
		
		local y = 1
		while y <= 24 do
			minetest.set_node({x=pos.x, y=pos.y+y, z=pos.z}, {name="telepro:corda_balao"})
			y = y + 1
		end
		
		-- Reativa as verificações das cordas
		telepro.cordas_f = true
	end
	
	-- Colocar balao
	minetest.set_node({x=pos.x, y=pos.y+25, z=pos.z}, {name="telepro:balao_jogador"})
	
end
