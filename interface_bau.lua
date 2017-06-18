--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Interface do Bau do balao
  ]]


-- Acessar um Bau de Balao
telepro.acessar_bau = function(player)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.acessar)")
		return false
	end
	
	-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
	if telepro.verif_prox_bau(player) == false then
		minetest.chat_send_player(player:get_player_name(), "Muito distante do seu Bau de Balao")
		return false
	end
	
	-- Exibir formulario de opcoes ao jogador
	
	-- Cria formspec
	local formspec = "size[6,4.8]"
		..default.gui_bg
		..default.gui_bg_img
		.."image[0,0;7.3,3;telepro_intro.png]"
		.."button_exit[0,3;6,1;ir_centro;Ir para Centro]"
		.."button_exit[0,4;6,1;reparar;Reparar Balao]"
	
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
	local formspec = "size[6,4]"
		..default.gui_bg
		..default.gui_bg_img
		.."image[0,0;7.3,3;telepro_intro.png]"
		.."button_exit[0,3;6,1;ir_balao;Ir para o posto de seu Balao]"
	
	-- Exibir formspec
	minetest.show_formspec(player:get_player_name(), "telepro:bau_spawn", formspec)
	
end

-- Receber botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	
	-- Bau do jogador
	if formname == "telepro:bau" then
		
		-- Botao de ir para o centro
		if fields.ir_centro then
			
			-- Pegar nome do jogador
			local name = player:get_player_name()
	
			-- Pegar coordenada do jogador
			local pos = player:getpos()
	
			-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
			if telepro.verif_prox_bau(player) == false then
				minetest.chat_send_player(name, "Muito distante do seu Bau de Balao")
				return
			end
			
			-- Verifica status do bau do balao
			do
				-- Pega os metadados do bau
				local meta = minetest.get_meta(telepro.bd:pegar(name, "pos"))
				
				if meta:get_string("status") ~= "ativo" then
					minetest.chat_send_player(name, "Balao inoperante. Aguarde mantenha o local limpo e aberto e aguarde ele ficar pronto.")
					return
				end
			end
			
			-- Teleportar jogador
			player:setpos(telepro.spawn)
			minetest.chat_send_player(name, "Viagem ao Centro realizada.")
		elseif fields.reparar then
			
			-- Pegar nome do jogador
			local name = player:get_player_name()
			
			-- Verificar se tem um Bau de Balao perto do jogador que pertenca a ele
			if telepro.verif_prox_bau(player) == false then
				minetest.chat_send_player(name, "Muito distante do seu Bau de Balao")
				return
			end
			
			-- Pegar coordenada do bau
			local pos = telepro.bd:pegar(name, "pos")
			
			-- Verificar se o balao ja esta ativo
			local meta = minetest.get_meta(pos)
			if meta:get_string("status") == "ativo" then
				minetest.chat_send_player(name, "O Balao ja esta ativo. Nao precisa reparar.")
				return
			end
			
			-- Reparar o balao
			telepro.reparar_balao(name, pos)
			
		end
	
	-- Bau do Spawn
	elseif formname == "telepro:bau_spawn" then
		
		-- Teleportar para o posto do balao do jogador
		if fields.ir_balao then
		
			-- Pegar nome do jogador
			local name = player:get_player_name()
	
			-- Pegar coordenada do jogador
			local pos = player:getpos()
			
			-- Verificar se tem um Bau de Centro de Balao por perto
			if not minetest.find_node_near({x=pos.x, y=pos.y-2, z=pos.z}, 8, {"telepro:bau_spawn"}) then
				minetest.chat_send_player(name, "Muito distante do Bau de Balao do Centro")
				return
			end
			
			-- Verificar se o jogador tem um balao
			if telepro.bd:verif(name, "pos") ~= true then
				return telepro.acessar(minetest.get_player_by_name(name))
			end
			
			-- Verificar se o balao esta ativo
			if minetest.get_meta(telepro.bd:pegar(name, "pos")):get_string("status") ~= "ativo" then
				minetest.chat_send_player(name, "O Seu Balao nao esta funcionando. O local foi destruido ou obstruido.")
			end
			
			-- Tenta teleportar o jogador
			telepro.ir_balao(player)
			return
		end
	end
end)
