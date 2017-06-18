--[[
	Mod Telepro para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Balao
  ]]

-- Pegar node distante nao carregado
local function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end


-- Registro da entidade
minetest.register_entity("telepro:balao", {
	hp_max = 1,
	physical = true,
	weight = 5,
	collisionbox = {-7,0,-7, 7,25,7},
	visual = "mesh",
	visual_size = {x=5, y=5},
	mesh = "telepro_balao.b3d",
	textures = {"telepro_balao.png"}, -- number of required textures depends on visual
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = false,
	on_step = function(self, dtime)
		self.timer = (self.timer or 0) + dtime
		
		if self.timer > 4 then
			self.timer = 0
			
			-- Pegar nome do jogador
			local name = self.dono
	
			-- Pegar coordenada do balao
			local pos = self.object:getpos()
			
			-- Pegar coordenada do bau
			local bau_pos = {x=pos.x, y=pos.y-23, z=pos.z}
			
			-- Verifica se ainda tem o bau
			
			if pegar_node(bau_pos).name == "telepro:bau" then
			
				-- Verifica se o bau eh do dono
			
				-- Pegar metadados
				local meta = minetest.get_meta(bau_pos)
			
				if 
					meta:get_string("dono") == name 
					and meta:get_string("status") == "ativo"
				then 
					return 
				end
			end
			
			-- Remover cordas
			do
				local y = -1
				while y <= 24 do
					if pegar_node({x=pos.x, y=pos.y-y, z=pos.z}).name == "telepro:corda_balao" then
						minetest.remove_node({x=pos.x, y=pos.y-y, z=pos.z})
					end
					y = y + 1
				end
			end
			
			-- Remove o objeto pois nao encontrou o bau do dono
			self.object:remove()
			return
		end
	end,
	
	on_activate = function(self, staticdata)
		if staticdata ~= "" then
			self.dono = minetest.serialize({dono=self.dono,name=self.name}).dono
			self.name = minetest.serialize({dono=self.dono,name=self.name}).name
		end
	end,
	
	get_staticdata = function(self)
		return minetest.serialize({dono=self.dono,name=self.name})
	end,
})

-- Criar um balao
telepro.criar_balao = function(pos, bau_pos, name)
	if not pos then
		minetest.log("error", "[Telepro] pos == nil (em telepro.criar_balao)")
		return false
	end
	if not bau_pos then
		minetest.log("error", "[Telepro] bau_pos == nil (em telepro.criar_balao)")
		return false
	end
	if not name then
		minetest.log("error", "[Telepro] name == nil (em telepro.criar_balao)")
		return false
	end
	
	-- Cria o objeto
	local obj = minetest.add_entity(pos, "telepro:balao")
	
	-- Verifica se foi criado
	if not obj then
		minetest.log("error", "[Telepro] Falha ao cria o objeto (em telepro.criar_balao)")
		return false
	end
	
	-- Cria animação no objeto
	obj:set_animation({x=1,y=40}, 5, 0)
	
	-- Pega a entidade
	local ent = obj:get_luaentity()
	
	-- Cria o temporizador
	ent.timer = 0
	
	-- Salva o nome do dono
	ent.dono = name
	
	-- Salva nome da entidade
	ent.name = "telepro:balao"
	
	return true
end
