--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Gerar balao automaticamente
  ]]

minetest.register_on_newplayer(function(player)
	if not player then return end
	
	minetest.after(3, minetest.show_formspec, player:get_player_name(), "telepro:intro", "size[10,8]"
		..default.gui_bg
		..default.gui_bg_img
		.."image[0,0;12,4.5;telepro_intro.png]"
		
		.."image[1,4;1.5,1;telepro_pt.png]"
		.."label[2.5,4;Esse Bau pode te teleportar de sua casa para \no centro e vice versa]"
		
		.."image[1,5.5;1.5,1;telepro_es.png]"
		.."label[2.5,5.5;Este Bau que puede teletransportarse desde su \ncasa al centro y viceversa]"
		
		.."image[1,7;1.5,1;telepro_en.png]"
		.."label[2.5,7;This Block can teleport you from your home \nto the center and vice versa]"
	)
		
	telepro.gerar_balao_aleatorio(player)
end)


