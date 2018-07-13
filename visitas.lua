--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Visitas
  ]]

local S = telepro.S

-- Acesar interface do jogador para visitas
telepro.acessar_visitas = function(player, tipo)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.acessar_visitas)")
		return false
	end
	
	local formspec
	local temp = telepro.online[player:get_player_name()]
	
	if not temp.pedidos_visita then temp.pedidos_visita = {} end
	
	if tipo == "proprio" then
		local visitas = ""
		for n,v in pairs(temp.pedidos_visita) do
			if visitas ~= "" then visitas = visitas .. "," end
			visitas = visitas .. n
		end
	
		-- Cria formspec
		formspec = "size[5,3]"
			..default.gui_bg
			..default.gui_bg_img
			.."label[0,0;"..S("Pedidos recebidos").."]"
			.."dropdown[0,0.5;5.25,1;visita;"..visitas..";]"
			.."button[0,1.15;5,1;receber_visita;"..S("Receber seguidor").."]"
			
			.."image[0.4,2;1.5,1.5;telepro_aceitar_visita.png]"
			.."button[2,2.25;3,1;voltar;"..S("Voltar").."]"
			
	elseif tipo == "centro" then
		-- Cria formspec
		formspec = "size[5,3]"
			..default.gui_bg
			..default.gui_bg_img
			.."field[0.28,0.8;5,1;visitado;"..S("Seguir jogador")..";]"
			.."button_exit[0,1.25;5,1;enviar_pedido;"..S("Enviar pedido").."]"
			
			.."image[0.4,2;1.5,1.5;telepro_visitar.png]"
			.."button[2,2.25;3,1;voltar;"..S("Voltar").."]"
	end
		
	-- Exibir formspec
	minetest.show_formspec(player:get_player_name(), "telepro:jogador_visitas_"..tipo, formspec)
end


-- Receber botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	
	if formname == "telepro:jogador_visitas_centro" then
	
		if fields.enviar_pedido and fields.visitado ~= "" then -- Jogador online
			
			local name = player:get_player_name()
			
			if name == fields.visitado then
				minetest.chat_send_player(name, S("Nao podes seguir a si mesmo"))
				return
			end
			
			if not telepro.online[fields.visitado] then
				minetest.chat_send_player(name, S("@1 offline ou inexistente", "'"..fields.visitado.."'"))
				return
			end
			
			local temp = telepro.online[fields.visitado]
			
			if not temp.pedidos_visita then temp.pedidos_visita = {} end
			
			-- Insere nome na tabela de pedidos
			temp.pedidos_visita[name] = true
			
			minetest.chat_send_player(name, S("Pedido enviado a @1 ... Agora precisa pedir para aceitar seu pedido", "'"..fields.visitado.."'"))
			
		elseif fields.voltar then
			telepro.acessar_bau_spawn(player)
			return
		end
			
	elseif formname == "telepro:jogador_visitas_proprio" then
		
			
		if fields.receber_visita and fields.visita ~= "" then
		
			local name = player:get_player_name()
			local temp = telepro.online[name]
			
			-- Verifica se pedido ainda existe
			if not fields.visita or not temp.pedidos_visita[fields.visita] then
				minetest.chat_send_player(name, S("Pedido invalido"))
				return
			end
			
			-- Verifica se o visitante ainda esta online
			if not telepro.online[fields.visita] then
				minetest.chat_send_player(name, S("@1 offline", "'"..fields.visita.."'"))
				return
			end
			
			local visitante = minetest.get_player_by_name(fields.visita)
			
			-- Verifica se visitante esta perto do balao de centro
			if not minetest.find_node_near(visitante:getpos(), 25, {"telepro:bau_spawn"}) then
				minetest.chat_send_player(name, S("@1 saiu de perto do balao do centro", "'"..fields.visita.."'"))
				minetest.chat_send_player(fields.visita, S("Seu pedido para seguir @1 foi aceito mas voce se afastou do balao", "'"..name.."'"))
				return
			end
			
			-- Teleporta jogador
			visitante:setpos(player:getpos())
			temp.pedidos_visita[fields.visita] = nil
			minetest.chat_send_player(name, S("@1 te seguiu", "'"..fields.visita.."'"))
			minetest.chat_send_player(fields.visita, S("Voce seguiu @1", "'"..name.."'"))
			
		elseif fields.voltar then
			telepro.acessar_bau(player)
			return
		end
		
	end
	
end)
