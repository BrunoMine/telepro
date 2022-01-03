--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Gerar um Balao Aleatorio
  ]]

local S = telepro.S

-- Tabela de jogadores que estão em precesso de geração de balao (evitar geração dupla)
local gerando = {}

-- Verificar area
-- Retorna a coordenada de terra superficial adequada ou 'nil' se não encontrar
local check_area = function(name, center_pos)
	
	-- Carregar mapa
	minetest.get_voxel_manip():read_from_map(
		{x=center_pos.x-10,y=center_pos.y-10, z=center_pos.z-10}, 
		{x=center_pos.x+10,y=center_pos.y+80, z=center_pos.z+10})
	
	-- Procura grama
	local nodes = minetest.find_nodes_in_area(
		{x=center_pos.x-10,y=center_pos.y-10, z=center_pos.z-10}, 
		{x=center_pos.x+10,y=center_pos.y+80, z=center_pos.z+10}, 
		{"group:spreading_dirt_type"})
	
	-- Verifica se encontrou uma terra superficial
	if table.maxn(nodes) == 0 then 
		return
	end
	
	-- Pega uma coordenada de terra superficial
	local pos = nodes[1]
	
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
		return
	end
	
	-- Retorna coordenada de uma terra superficial
	return pos
end


-- Inicia geração de uma coordenada aleatória
local generate_random_pos = function(name)
	
	-- Pegar uma coordenada aleatória
	local pos = {x=math.random(-25000, 25000), y = 10, z=math.random(-25000, 25000)}
	
	-- Inicia geração de mapa
	minetest.emerge_area({x=pos.x-10,y=pos.y-10, z=pos.z-10}, {x=pos.x+10,y=pos.y+80, z=pos.z+10})
	
	-- Retorna a coordenada que está sendo gerada
	return pos
end


-- Finaliza o procedimento de gerar balao
telepro.finalizar_geracao_balao = function(name, spos)
	local player = minetest.get_player_by_name(name)
	
	-- Se jogador não está online encerra a geração
	if not player then 
		gerando[name] = nil
		return 
	end
	
	-- Restaura informação da coordenada gerada
	local pos = minetest.deserialize(spos)
	
	-- Tenta pegar uma coordenada de terra superficial válida
	local soil_pos = check_area(name, pos)
	
	-- Verifica se encontrou coordenda válida
	if not soil_pos then
	
		-- Gera o mapa em uma coordenada aleatória
		local new_pos = generate_random_pos()
		
		-- Tenta finalizar após 8 segundos
		minetest.after(8, telepro.finalizar_geracao_balao, name, minetest.serialize(new_pos))
		
		-- Encerra tentativa de finalização
		return
	end
	
	-- Cordenada do bau
	local chest_pos = {x=soil_pos.x, y=soil_pos.y+1, z=soil_pos.z}
	
	-- Desativa o bau anterior
	-- Verificar se existe registro no banco de dados
	if telepro.bd.verif("jogador_"..name, "pos") == true then
		-- Pega a coordenada do bau antigo
		local old_chest_pos = telepro.bd.pegar("jogador_"..name, "pos")
		-- Acessa os metadados
		local meta = minetest.get_meta(old_chest_pos)
		-- Limpa o parametro dono
		meta:set_string("dono", "")
	end
	
	-- Colocar Bau
	minetest.set_node(chest_pos, {name="telepro:bau"})
	-- Pega os metadados do bau
	local meta = minetest.get_meta(chest_pos)
	-- Salvar o nome do dono
	meta:set_string("dono", name)
	meta:set_string("status", "ativo") -- Salvar status inicial
	
	-- Salva a coordenada do novo bau no banco de dados
	telepro.bd.salvar("jogador_"..name, "pos", chest_pos)
	
	-- Montar balao
	telepro.montar_balao(chest_pos, name)
	
	
	-- Levar o jogador um pouco pra cima
	player:setpos({x=chest_pos.x, y=chest_pos.y+1.5, z=chest_pos.z})
	
	-- Travar por 24 horas para impedir ficar gerando em vaios locais
	if telepro.var.limite_diario == true then
		telepro.travados[name] = true
		minetest.after(3600, telepro.destravar, name)
	end
	
	-- Remove jogador da lista de jogadores em processo de geração de balão
	gerando[name] = nil
	
	-- Informa jogador
	minetest.chat_send_player(name, S("Novo local encontrado"))
end

-- Gerar um balao aleatorio (ignora verificações)
telepro.gerar_balao_aleatorio = function(name)
	
	-- Verifica se jogador já está em processo de geração de balão
	if gerando[name] then
		return
	end
	
	local player = minetest.get_player_by_name(name)
	
	-- Verifica se jogador está online
	if not player then 
		gerando[name] = nil
		return 
	end
	
	-- Insere jogador na lista de jogadores em processo de geração de balão
	gerando[name] = true
	
	-- Gera o mapa em uma coordenada aleatória
	local pos = generate_random_pos()
	
	-- Tenta finalizar após 8 segundos
	minetest.after(8, telepro.finalizar_geracao_balao, name, minetest.serialize(pos))
end
