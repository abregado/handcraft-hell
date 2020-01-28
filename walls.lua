require("util")

local wall_sheet_sprite = function(x,y,type)
  return
  {
    filename = "__sf13__/graphics/entity/wall-"..type..".png",
    priority = "medium",
    width = 32,
    height = 32,
    variation_count = 1,
    line_length = 6,
    x = x*32,
    y = y*32
  }
end


local create_wall_variation = function(n,e,s,w,type)
  local layers = {
      wall_sheet_sprite(0,0,type),
      wall_sheet_sprite(1,0,type),
      wall_sheet_sprite(2,0,type),
      wall_sheet_sprite(3,0,type),
    }
  local ne = n + e
  local nw = n + w
  local se = s + e
  local sw = s + w

  if n == 1 then
    layers[1] = wall_sheet_sprite(4,0,type)
    layers[2] = wall_sheet_sprite(5,0,type)
  end
  if e == 1 then
    layers[2] = wall_sheet_sprite(3,1,type)
    layers[4] = wall_sheet_sprite(5,1,type)
  end
  if ne == 2 then layers[2] = wall_sheet_sprite(1,2,type) end
  if s == 1 then
    layers[3] = wall_sheet_sprite(0,1,type)
    layers[4] = wall_sheet_sprite(1,1,type)
  end
  if se == 2 then layers[4] = wall_sheet_sprite(3,2,type) end
  if w == 1 then
    layers[1] = wall_sheet_sprite(2,1,type)
    layers[3] = wall_sheet_sprite(4,1,type)
  end
  if sw == 2 then layers[3] = wall_sheet_sprite(2,2,type) end
  if nw == 2 then layers[1] = wall_sheet_sprite(0,2,type) end

  return layers
end

local generate_all_variations = function(type)
  local pictures = {}
  for n=0,1 do
    for s=0,1 do
      for w=0,1 do
        for e=0,1 do
          table.insert(pictures,{layers=create_wall_variation(n,e,s,w,type)})
        end
      end
    end
  end
  return pictures
end

local new_basic_entity = function (name)
  return {
    type = 'simple-entity',
    name = name,
    icon = "__sf13__/graphics/icons/"..name..".png",
    icon_size = 32,
    icon_mipmaps = 4,
    flags = {"player-creation"},
    minable = nil,
    map_color = {r = 0, g = 0.365, b = 0.58, a = 1},
    max_health = 1000,
    collision_box = {{-0.49, -0.49}, {0.49, 0.49}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
  }
end

local station_wall = new_basic_entity('wall-station')
station_wall.pictures = generate_all_variations('station')
--local strong_wall = new_basic_entity('wall-reinforced')
--station_wall.pictures = generate_all_variations('reinforced')

data:extend({station_wall})

local new_gate_entity = function(type) 
  local new_door = util.table.deepcopy(data.raw["gate"]["gate"])
  new_door.name = 'door-'..type
  new_door.icon = "__sf13__/graphics/icons/door-"..type..".png"
  new_door.flags = {"player-creation"}
  new_door.minable = nil
  new_door.icon_size = 32
  new_door.opening_speed = 0.0366666
  new_door.activation_distance = 0.5
  new_door.timeout_to_close = 1
  new_door.fadeout_interval = 15
  new_door.vertical_animation = {
    layers = {
      {
        filename = "__sf13__/graphics/entity/door-"..type..".png",
        line_length = 6,
        width = 32,
        height = 32,
        frame_count = 6,
      }
    }
  }
  new_door.horizontal_animation = {
    layers = {
      {
        filename = "__sf13__/graphics/entity/door-"..type..".png",
        line_length = 6,
        width = 32,
        height = 32,
        frame_count = 6,
      }
    }
  }
  return new_door
end

local kitchen_door = new_gate_entity('service')
local maint_door = new_gate_entity('maintenance')
local common_door = new_gate_entity('common')
local common_door_glass = new_gate_entity('common-glass')


data:extend({kitchen_door,maint_door,common_door,common_door_glass})

