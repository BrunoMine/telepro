--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Reparar Balao
  ]]

-- Metodo para reparar o balao
telepro.reparar_balao = function(name, pos)
	
	-- Verificar se está na luz do dia (força estar na superficie)
	do
		local luz = minetest.get_node_light({x=pos.x, y=pos.y+1, z=pos.z+1})
		if not luz or luz < 13 then
			minetest.chat_send_player(name, "Precisa estar na luz do dia.")
			return false
		end
	end
	
	-- Verificar caminho de bloco para cima
	do
		-- Pegar nodes
		local nodes = minetest.find_nodes_in_area(
			{x=pos.x, y=pos.y, z=pos.z}, 
			{x=pos.x, y=pos.y+24, z=pos.z}, 
			{"air", "telepro:corda_balao"}
		)
		
		-- Verifica se pegou nodes de ar
		if table.maxn(nodes) < 24 then
			minetest.chat_send_player(name, "O caminho para cima esta obstruido (corda). Abra mais o local."..table.maxn(nodes))
			return false
		end
	end
	
	-- Verificar espaço onde fica o balão
	do
		-- Pegar nodes
		local nodes = minetest.find_nodes_in_area(
			{x=pos.x-7, y=pos.y+24, z=pos.z-7}, 
			{x=pos.x+7, y=pos.y+24+25, z=pos.z+7}, 
			{"air", "telepro:corda_balao"}
		)
	
		-- Verifica se pegou todos nodes de ar
		if table.maxn(nodes) < 5850 then -- 15 * 15 * 26
			minetest.chat_send_player(name, "Parte de cima obstruida (onde fica o balao). Libere o local ou suba.")
			return false
		end
	end
	
	-- Verificar entidades na area do balao
	if table.maxn(minetest.get_objects_inside_radius({x=pos.x, y=pos.y+23, z=pos.z}, 15)) > 0 then
		minetest.chat_send_player(name, "Objetos obstruem a parte de cima. remova os objetos e tente novamente.")
		return
	end
	
	-- Montar balao
	telepro.montar_balao(pos, name)
	
	-- Ativa o balao
	local meta = minetest.get_meta(pos)
	meta:set_string("status", "ativo")
	
end

	

