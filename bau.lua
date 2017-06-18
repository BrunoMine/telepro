--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Bau do balao
  ]]

-- Node
minetest.register_node("telepro:bau", {
	description = "Bau do Balao",
	tiles = {
		"default_chest_top.png^telepro_bau_cima.png", -- Cima
		"default_chest_top.png", -- Baixo
		"default_chest_side.png^telepro_bau_direita.png", -- Direita
		"default_chest_side.png^telepro_bau_esquerda.png", -- Esquerda
		"default_chest_side.png^telepro_bau_fundo.png", -- Fundo
		"default_chest_front.png" -- Frente
	},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, player)
		local meta = minetest.get_meta(pos)
		if (meta:get_string("dono") or "") == player:get_player_name() then
			telepro.acessar_bau(player)
		else
			minetest.chat_send_player(player:get_player_name(), "Esse Balao nao lhe pertence.")
		end
	end,
	drop = "",
})

-- Atualização constante do balão
minetest.register_abm{
	nodenames = {"telepro:bau"},
	interval = 2,
	chance = 1,
	action = function(pos)
	
		-- Pegar metadados do bau
		local meta = minetest.get_meta(pos)
		
		-- Verifica se o bau tem dono
		if meta:get_string("dono") == "" then return end
		
		--
		-- Verificar se ta tudo ok
		--
		
		-- Salvar o nome do dono
		if meta:get_string("status") == "ativo" then
			
			-- Verificar cordas
			do
				-- Pegar os nodes
				local nodes = minetest.find_nodes_in_area(
					{x=pos.x, y=pos.y+1, z=pos.z}, 
					{x=pos.x, y=pos.y+24, z=pos.z}, 
					{"telepro:corda_balao"}
				)
				-- Verificar se estao todos
				if table.maxn(nodes) < 24 then
					-- Desativa o bau
					meta:set_string("status", "inativo")
					return
				end
			end
			
			-- Verifica balao
			do
				local r = false -- Variavel que avisa se achou o balao
				for  _,obj in ipairs(minetest.get_objects_inside_radius(pos, 30)) do
					local ent = obj:get_luaentity() or {}
					-- Verifica se eh o balao
					if ent and ent.name == "telepro:balao" and ent.dono == meta:get_string("dono") then
						r = true -- achou balao
					end
				end
				if r == false then
					-- Desativa o bau
					meta:set_string("status", "inativo")
					return
				end
			end
			
			-- Tudo ok
			return
		end
		
		--
		-- Verificar se consegue colocar o balao e cordas
		--
		
		-- Verificar se consegue colocar cordas
		do
			-- Pegar os nodes que podem ser substituidos por corda normalmente
			local nodes = minetest.find_nodes_in_area(
				{x=pos.x, y=pos.y+1, z=pos.z}, 
				{x=pos.x, y=pos.y+24, z=pos.z}, 
				{"air", "telepro:corda_balao"}
			)
			-- Verificar se esta tudo livre
			if table.maxn(nodes) < 24 then
				return
			end
		end
		
		-- Verificar se consegue colocar balao
		do
			-- Pegar nodes
			local nodes = minetest.find_nodes_in_area(
				{x=pos.x-7, y=pos.y+24, z=pos.z-7}, 
				{x=pos.x+7, y=pos.y+24+25, z=pos.z+7}, 
				{"air", "telepro:corda_balao"}
			)
		
			-- Verifica se pegou todos nodes de ar
			if table.maxn(nodes) < 5850 then -- 15 * 15 * 26
				return
			end
		end
		
		-- Verificar entidades na area do balao
		if table.maxn(minetest.get_objects_inside_radius({x=pos.x, y=pos.y+23+15, z=pos.z}, 15)) > 0 then
			return
		end
		
		--
		-- Montar o balao e cordas
		--
		
		telepro.montar_balao(pos, meta:get_string("dono"))
		
		meta:set_string("status", "ativo")
		
	end,
}
