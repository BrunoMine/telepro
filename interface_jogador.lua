--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Interface do Jogador
  ]]

local S = telepro.S

-- Acesar interface do jogador
telepro.acessar = function(player)
	if not player then
		minetest.log("error", "[Telepro] player == nil (em telepro.acessar)")
		return false
	end
	
	-- Cria formspec
	local formspec = "size[3,5]"
		..default.gui_bg
		..default.gui_bg_img
		.."image[0,0;3.5,3.5;telepro_mapa.png]"
		.."button_exit[0,4.25;3,1;por_balao_aqui;"..S("Por Balao Aqui").."]"
	
	-- Botão de gerar balão aleatorio
	if telepro.var.disable_random_balloon_button == false then
		formspec = formspec.."button_exit[0,3.25;3,1;gerar_balao;"..S("Gerar Balao").."]"
	end
	
	-- Exibir formspec
	minetest.show_formspec(player:get_player_name(), "telepro:jogador", formspec)
end

-- Receber botoes
minetest.register_on_player_receive_fields(function(player, formname, fields)
	
	if formname == "telepro:jogador" then
		local name = player:get_player_name()
		
		if fields.gerar_balao then
			
			
			if telepro.travados[name] == true then
				minetest.chat_send_player(player:get_player_name(), S(telepro.msg.limite_de_usos_por_dia))
				return
			end	
			
			minetest.chat_send_player(player:get_player_name(), S(telepro.msg.aguardar_gerar_balao))
			telepro.gerar_balao_aleatorio(name)
			
		elseif fields.por_balao_aqui then
			if telepro.travados[name] == true then
				minetest.chat_send_player(name, S(telepro.msg.limite_de_usos_por_dia))
				return
			end
			
			telepro.reivindicar(player)
		end
		
	end
	
end)

-- Botão em menu compacto do inventario
if sfinv_menu then
	sfinv_menu.register_button("telepro:micro_menu", {
		title = S("Meu Balão"),
		icon = "telepro_mapa.png",
		func = function(player)
			telepro.acessar(player)
		end,
	})
end
