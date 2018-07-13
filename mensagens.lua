--[[
	Mod Telepro para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Mensagens padrão
  ]]

local S = telepro.Sfake

telepro.msg = {
	-- Ao tentar gerar um Balão aleatorio antes do termino das 24 horas
	limite_de_usos_por_dia = S("Nao pode gerar um novo balao ainda (sao necessarias 24 horas desde a ultima vez que gerou)"),
	-- Ao iniciar geração de balao proprio
	aguardar_gerar_balao = S("Aguarde alguns segundos enquanto o balao esta endo preparado"),
	-- O bau informa balao inativo
	balao_inativo = S("O Seu Balao ficou inoperante"),
	-- Não foi encontrado registro no banco de dados de nenhum balão
	balao_inexistente = S("O Seu Balao ficou inoperante"),
	-- Muito distante do balão do centro
	longe_do_balao_centro = S("Muito distante do Bau de Balao do Centro"),
	-- Muito distante do próprio balão
	longe_do_balao_proprio = S("Muito distante do seu proprio Bau de Balao"),
	-- Recomendações para que o proprio balao seja ativado
	recomendacoes_limpezas_balao = S("Mantenha o local limpo e aberto para levantar que o balao seja levantado automaticamente"),
	-- Viagem ao centro realizada
	ao_ir_centro = S("Viagem ao Centro realizada"),
	-- Viagem ao proprio balao
	ao_ir_casa = S("Viagem para seu proprio balao realizada"),
	
	-- Problemas ao montar balão
	-- Local baixo
	local_muito_baixo = S("Precisa subir para um local mais alto"),
	-- Local muito fechado (obstruções ao balao)
	local_muito_fechado = S("Precisa estar num lugar mais aberto")
	-- Objetos estao ocupando a area que o modelo/malha do balão vai ocupar
	objetos_obstruem_balao = S("Objetos obstruem a parte de cima portanto libere o local ou suba")
}
