--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Função para Reivindicar balao
  ]]

-- Lista de jogadores que não podem gerar novo balao
telepro.travados = {}

-- Metodo para destravar jogador (apos um tempo)
telepro.destravar = function(name)
	telepro.travados[name] = false
end

-- Metodo para reivindicar balao no local
telepro.reivindicar = function(player)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.reivindicar)")
		return false
	end
	
	-- Pegar nome do jogador
	local name = player:get_player_name()
	
	-- Verificar se está travado
	if telepro.travados[name] == true then 
		minetest.chat_send_player(name, "Nao pode gerar um novo balao ainda. (sao necessarias 24 horas desde a ultima vez que gerou)")
		return false
	end
	
	-- Pegar coordenada do jogador
	local pos = player:getpos()
	
	-- Verifica se está numa coordenada muito baixa (menor que o nível do mar)
	if pos.y < 10 then
		minetest.chat_send_player(name, "Local muito baixo. Precisa subir para um local mais alto.")
		return false
	end
	
	-- Verificar se está na luz do dia (força estar na superficie)
	do
		local luz = minetest.get_node_light(pos, 0.5)
		if not luz or luz < 13 then
			minetest.chat_send_player(name, "Precisa estar num lugar mais aberto.")
			return false
		end
	end
	
	-- Verifica se cabe o balao
	
	--[[
		- Caminho de bloco para cima totalmente livre 40 blocos
		- Cubo de espaço onde fica o balão
	  ]]
	
	-- Verificar caminho de bloco para cima
	do
		-- Pegar nodes
		local nodes = minetest.find_nodes_in_area(
			{x=pos.x, y=pos.y, z=pos.z}, 
			{x=pos.x, y=pos.y+24, z=pos.z}, 
			{"air"}
		)
		
		-- Verifica se pegou nodes de ar
		if table.maxn(nodes) < 25 then
			minetest.chat_send_player(name, "O caminho para cima esta obstruido. Encontre um lugar onde de para o balao descer.")
			return false
		end
	end
	
	-- Verificar espaço onde fica o balão
	do
		-- Pegar nodes
		local nodes = minetest.find_nodes_in_area(
			{x=pos.x-7, y=pos.y+24, z=pos.z-7}, 
			{x=pos.x+7, y=pos.y+24+25, z=pos.z+7}, 
			{"air"}
		)
	
		-- Verifica se pegou todos nodes de ar
		if table.maxn(nodes) < 5850 then -- 15 * 15 * 26
			minetest.chat_send_player(name, "Parte de cima obstruida. Libere o local ou suba.")
			return false
		end
	end
	
	-- Verificar area protegida
	if minetest.is_protected(pos, name) -- local do bau
		-- corda para subir no balao
		or minetest.is_protected({x=pos.x, y=pos.y+5, z=pos.z}, name) 
		or minetest.is_protected({x=pos.x, y=pos.y+10, z=pos.z}, name) 
		or minetest.is_protected({x=pos.x, y=pos.y+15, z=pos.z}, name) 
		or minetest.is_protected({x=pos.x, y=pos.y+20, z=pos.z}, name) 
	then
		minetest.chat_send_player(name, "Local protegido.")
		return
	end
	
	-- Verificar entidades na area do balao
	if table.maxn(minetest.get_objects_inside_radius({x=pos.x, y=pos.y+23, z=pos.z}, 15)) > 0 then
		minetest.chat_send_player(name, "Objetos obstruem a parte de cima. Libere o local ou suba.")
		return
	end
	
	-- Desativa o bau anterior
	do
		-- Verificar se existe registro no banco de dados
		if telepro.bd.verif("jogador_"..name, "pos") == true then
			-- Pega a coordenada
			local p = telepro.bd.pegar("jogador_"..name, "pos")
			-- Acessa os metadados
			local meta = minetest.get_meta(p)
			-- Limpa o parametro dono
			meta:set_string("dono", "")
		end
	end
	
	-- Colocar Bau
	minetest.set_node(pos, {name="telepro:bau"})
	-- Pega os metadados do bau
	local meta = minetest.get_meta(pos)
	-- Salvar o nome do dono
	meta:set_string("dono", name)
	meta:set_string("status", "ativo") -- Salvar status inicial
	
	-- Salva a coordenada do novo bau no banco de dados
	telepro.bd.salvar("jogador_"..name, "pos", pos)
	
	-- Montar balao
	telepro.montar_balao(pos, name)
	
	-- Levar o jogador um pouco pra cima
	player:setpos({x=pos.x, y=pos.y+1.5, z=pos.z})
	
	-- Travar por 24 horas para impedir ficar gerando em vaios locais
	telepro.travados[name] = true
	minetest.after(3600, telepro.destravar, name)
	
	-- Finaliza
	minetest.chat_send_player(name, "Balao reivindicado com sucesso.")
	return true
end
