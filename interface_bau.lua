--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Interface do Bau do balao
  ]]

local S = telepro.S

-- Acessar um Bau de Balao
telepro.acessar_bau = function(player)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.acessar)")
		return false
	end
	
	-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
	if telepro.verif_prox_bau(player) == false then
		minetest.chat_send_player(player:get_player_name(), S("Muito distante do seu Bau de Balao"))
		return false
	end
	
	-- Exibir formulario de opcoes ao jogador
	
	-- Cria formspec
	local formspec = "size[6,5.8]"
		..default.gui_bg
		..default.gui_bg_img
		.."image[1.7,-0.25;3,3;telepro_ir_centro.png]"
		.."button_exit[0,2.4;6,1;ir_centro;"..S("Ir para Centro").."]"
		
		.."image[0.1,3.7;1,1;screwdriver.png]"
		.."button_exit[1,3.7;5,1;reparar;"..S("Reparar Balao").."]"
		
		.."image[0.1,5;1,1;telepro_aceitar_visita.png]"
		.."button[1,5;5,1;visitas;"..S("Receber seguidor").."]"
	
	-- Exibir formspec
	minetest.show_formspec(player:get_player_name(), "telepro:bau", formspec)
	
end

-- Acessar um Bau de Centro de Balao
telepro.acessar_bau_spawn = function(player)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.acessar)")
		return false
	end
	
	-- Exibir formulario de opcoes ao jogador
	
	-- Cria formspec
	local formspec = "size[6,3]"
		..default.gui_bg
		..default.gui_bg_img
		.."image[0.1,-0.2;3,3;telepro_ir_casa.png]"
		.."button_exit[0,2;3,1;ir_balao;"..S("Ir para seu Balao").."]"
		.."image[3.1,-0.2;3,3;telepro_visitar.png]"
		.."button[3,2;3,1;visitas;"..S("Seguir jogador").."]"
		
	
	-- Exibir formspec
	minetest.show_formspec(player:get_player_name(), "telepro:bau_spawn", formspec)
	
end

-- Receber botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	
	-- Bau do jogador
	if formname == "telepro:bau" then
		
		-- Gerenciar visitas
		if fields.visitas then
			telepro.acessar_visitas(player, "proprio")
			
		-- Botao de ir para o centro
		elseif fields.ir_centro then
			
			-- Pegar nome do jogador
			local name = player:get_player_name()
	
			-- Pegar coordenada do jogador
			local pos = player:getpos()
			
			-- Verificar se o jogador tem um balao
			if telepro.bd.verif("jogador_"..name, "pos") ~= true then
				minetest.chat_send_player(name, S("Precisas ter um balao ativo"))
				return
			end
			
			-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
			if telepro.verif_prox_bau(player) == false then
				minetest.chat_send_player(name, S(telepro.msg.longe_do_balao_proprio))
				return
			end
			
			-- Verifica status do bau do balao
			do
				-- Pega os metadados do bau
				local meta = minetest.get_meta(telepro.bd.pegar("jogador_"..name, "pos"))
				
				if meta:get_string("status") ~= "ativo" then
					minetest.chat_send_player(name, S(telepro.msg.balao_inativo))
					minetest.chat_send_player(name, S(telepro.msg.recomendacoes_limpezas_balao))
					return
				end
			end
			
			-- Teleportar jogador
			player:setpos(telepro.spawn)
			minetest.chat_send_player(name, S("Viagem ao Centro realizada"))
		elseif fields.reparar then
			
			-- Pegar nome do jogador
			local name = player:get_player_name()
			
			-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
			if telepro.verif_prox_bau(player) == false then
				minetest.chat_send_player(name, S(telepro.msg.ao_ir_centro))
				return
			end
			
			-- Pegar coordenada do bau
			local pos = telepro.bd.pegar("jogador_"..name, "pos")
			
			-- Verificar se o balao ja esta ativo
			local meta = minetest.get_meta(pos)
			if meta:get_string("status") == "ativo" then
				minetest.chat_send_player(name, S("Balao ativo"))
				return
			end
			
			-- Reparar o balao
			telepro.reparar_balao(name, pos)
			
		end
	
	-- Bau do Spawn
	elseif formname == "telepro:bau_spawn" then
	
		-- Gerenciar visitas
		if fields.visitas then
			telepro.acessar_visitas(player, "centro")
			
		-- Teleportar para o posto do balao do jogador
		elseif fields.ir_balao then
		
			-- Pegar nome do jogador
			local name = player:get_player_name()
	
			-- Pegar coordenada do jogador
			local pos = player:getpos()
			
			-- Verificar se tem um Bau de Centro de Balao por perto
			if not minetest.find_node_near({x=pos.x, y=pos.y-2, z=pos.z}, 8, {"telepro:bau_spawn"}) then
				minetest.chat_send_player(name, S(telepro.msg.longe_do_balao_centro))
				return
			end
			
			-- Verificar se o jogador tem um balao
			if telepro.bd.verif("jogador_"..name, "pos") ~= true then
				return telepro.acessar(minetest.get_player_by_name(name))
			end
			
			-- Verificar se o balao esta ativo
			if minetest.get_meta(telepro.bd.pegar("jogador_"..name, "pos")):get_string("status") ~= "ativo" then
				minetest.chat_send_player(name, S(telepro.msg.balao_inativo))
			end
			
			-- Tenta teleportar o jogador
			telepro.ir_balao(player)
			return
		end
	end
end)
