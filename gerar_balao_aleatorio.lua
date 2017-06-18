--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Gerar um Balao Aleatorio
  ]]

-- Finaliza o procedimento de gerar balao
local finalizar = function(player, pos)
	if not player then return end
	
	-- Carregar mapa
	minetest.get_voxel_manip():read_from_map({x=pos.x-10,y=pos.y-10, z=pos.z-10}, {x=pos.x+10,y=pos.y+80, z=pos.z+10})
	
	-- Procura grama
	local nodes = minetest.find_nodes_in_area({x=pos.x-10,y=pos.y-10, z=pos.z-10}, {x=pos.x+10,y=pos.y+80, z=pos.z+10}, {"group:spreading_dirt_type"})
	
	-- Verifica se encontrou uma terra superficial
	if table.maxn(nodes) == 0 then 
		return telepro.gerar_balao_aleatorio(player)
	end
	
	local name = player:get_player_name()
	
	-- Pegar uma coordenada
	local p = nodes[1]
	
	-- Cordenada do bau
	local pb = {x=p.x, y=p.y+1, z=p.z}
	
	-- Colocar balao
	-- Desativa o bau anterior
	do
		-- Verificar se existe registro no banco de dados
		if telepro.bd:verif(name, "pos") == true then
			-- Pega a coordenada
			local pp = telepro.bd:pegar(name, "pos")
			-- Acessa os metadados
			local meta = minetest.get_meta(pp)
			-- Limpa o parametro dono
			meta:set_string("dono", "")
		end
	end
	
	-- Colocar Bau
	minetest.set_node(pb, {name="telepro:bau"})
	-- Pega os metadados do bau
	local meta = minetest.get_meta(pb)
	-- Salvar o nome do dono
	meta:set_string("dono", name)
	meta:set_string("status", "ativo") -- Salvar status inicial
	
	-- Salva a coordenada do novo bau no banco de dados
	telepro.bd:salvar(name, "pos", pb)
	
	-- Montar balao
	telepro.montar_balao(pb, name)
	
	-- Levar o jogador um pouco pra cima
	player:setpos({x=pb.x, y=pb.y+1.5, z=pb.z})
	
	-- Travar por 24 horas para impedir ficar gerando em vaios locais
	telepro.travados[name] = true
	minetest.after(3600, telepro.destravar, name)
	
	-- Finaliza
	minetest.chat_send_player(name, "Novo local gerado. Mantenha o local do balao bem aberto.")
	
end

-- Gerar um balao aleatorio (ignora verificações)
telepro.gerar_balao_aleatorio = function(player)
	
	-- Pegar uma coordenada aleatória
	local pos = {x=math.random(-25000, 25000), y = 10, z=math.random(-25000, 25000)}
	
	local name = player:get_player_name()
	
	-- Verificar area protegida
	if minetest.is_protected({x=pos.x+5, y=pos.y, z=pos.z+5}, name) 
		or minetest.is_protected({x=pos.x-5, y=pos.y, z=pos.z+5}, name)
		or minetest.is_protected({x=pos.x+5, y=pos.y, z=pos.z-5}, name)
		or minetest.is_protected({x=pos.x-5, y=pos.y, z=pos.z-5}, name)
		-- Em uma distancia maior
		or minetest.is_protected({x=pos.x+20, y=pos.y, z=pos.z+20}, name) 
		or minetest.is_protected({x=pos.x-20, y=pos.y, z=pos.z+20}, name)
		or minetest.is_protected({x=pos.x+20, y=pos.y, z=pos.z-20}, name)
		or minetest.is_protected({x=pos.x-20, y=pos.y, z=pos.z-20}, name)
		-- Em cima
		or minetest.is_protected({x=pos.x+5, y=pos.y+25, z=pos.z+5}, name) 
		or minetest.is_protected({x=pos.x-5, y=pos.y+25, z=pos.z+5}, name)
		or minetest.is_protected({x=pos.x+5, y=pos.y+25, z=pos.z-5}, name)
		or minetest.is_protected({x=pos.x-5, y=pos.y+25, z=pos.z-5}, name)
		-- Em uma distancia maior (em cima)
		or minetest.is_protected({x=pos.x+20, y=pos.y+25, z=pos.z+20}, name) 
		or minetest.is_protected({x=pos.x-20, y=pos.y+25, z=pos.z+20}, name)
		or minetest.is_protected({x=pos.x+20, y=pos.y+25, z=pos.z-20}, name)
		or minetest.is_protected({x=pos.x-20, y=pos.y+25, z=pos.z-20}, name)
	then
		return telepro.gerar_balao_aleatorio(player)
	end
	
	-- Inicia geração de mapa
	minetest.emerge_area({x=pos.x-10,y=pos.y-10, z=pos.z-10}, {x=pos.x+10,y=pos.y+80, z=pos.z+10})
	
	-- Espera um tempo para continuar
	minetest.after(8, finalizar, player, pos)
	
end
