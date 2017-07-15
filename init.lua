--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Inicializador de variaveis e scripts
  ]]

-- Notificador de Inicializador
local notificar = function(msg)
	if minetest.setting_get("log_mods") then
		minetest.debug("[Telepro]"..msg)
	end
end

local modpath = minetest.get_modpath("telepro")

-- Variavel global
telepro = {}

-- Spawn do servidor (para onde os baloes permitem ir)
telepro.spawn = minetest.setting_get_pos("static_spawnpoint") or {x=0, y=0, z=0}

-- Carregar scripts
notificar("Carregando scripts...")

-- Criação do banco de dados
telepro.bd = dofile(modpath.."/lib/memor.lua")

-- Funções
dofile(modpath.."/online.lua")
dofile(modpath.."/reivindicar.lua")
dofile(modpath.."/ir_balao.lua")
dofile(modpath.."/comum.lua")
dofile(modpath.."/reparar_balao.lua")
dofile(modpath.."/gerar_balao_aleatorio.lua")

-- Interfaces
dofile(modpath.."/interface_bau.lua")
dofile(modpath.."/interface_jogador.lua")

-- Balao
dofile(modpath.."/balao.lua")

-- Nodes
dofile(modpath.."/corda.lua")
dofile(modpath.."/bau.lua")
dofile(modpath.."/bau_spawn.lua")

-- Comandos
dofile(modpath.."/comandos.lua")

-- Gerador de balao automatico
dofile(modpath.."/autogen.lua")

-- Ajuste de compatibilidade com outros mods
dofile(modpath.."/compatibilidade.lua")
notificar("OK")

