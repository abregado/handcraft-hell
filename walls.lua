require("util")

local wall_sheet_sprite = function(x,y)
  return
  {
    filename = "__sf13__/graphics/entity/station-wall.png",
    priority = "medium",
    width = 32,
    height = 32,
    variation_count = 1,
    line_length = 6,
    x = x*32,
    y = y*32
  }
end


local create_wall_variation = function(n,e,s,w)
  local layers = {
      wall_sheet_sprite(0,0),
      wall_sheet_sprite(1,0),
      wall_sheet_sprite(2,0),
      wall_sheet_sprite(3,0),
    }
  local ne = n + e
  local nw = n + w
  local se = s + e
  local sw = s + w

  if n == 1 then
    layers[1] = wall_sheet_sprite(4,0)
    layers[2] = wall_sheet_sprite(5,0)
  end
  if e == 1 then
    layers[2] = wall_sheet_sprite(3,1)
    layers[4] = wall_sheet_sprite(5,1)
  end
  if ne == 2 then layers[2] = wall_sheet_sprite(1,2) end
  if s == 1 then
    layers[3] = wall_sheet_sprite(0,1)
    layers[4] = wall_sheet_sprite(1,1)
  end
  if se == 2 then layers[4] = wall_sheet_sprite(3,2) end
  if w == 1 then
    layers[1] = wall_sheet_sprite(2,1)
    layers[3] = wall_sheet_sprite(4,1)
  end
  if sw == 2 then layers[3] = wall_sheet_sprite(2,2) end
  if nw == 2 then layers[1] = wall_sheet_sprite(0,2) end

  return layers
end

local generate_all_variations = function()
  local pictures = {}
  for n=0,1 do
    for s=0,1 do
      for w=0,1 do
        for e=0,1 do
          table.insert(pictures,{layers=create_wall_variation(n,e,s,w)})
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

local station_wall = new_basic_entity('station-wall')
station_wall.pictures = generate_all_variations()

local green_door = util.table.deepcopy(data.raw["gate"]["gate"])
green_door.name = 'green_door'
green_door.icon = "__sf13__/graphics/icons/green-door.png"
green_door.flags = {"player-creation"}
green_door.minable = nil
green_door.icon_size = 32
green_door.opening_speed = 0.0366666
green_door.activation_distance = 0.5
green_door.timeout_to_close = 1
green_door.fadeout_interval = 15
green_door.vertical_animation = {
  layers = {
    {
      filename = "__sf13__/graphics/entity/green-door.png",
      line_length = 6,
      width = 32,
      height = 32,
      frame_count = 6,
    }
  }
}
green_door.horizontal_animation = {
  layers = {
    {
      filename = "__sf13__/graphics/entity/green-door.png",
      line_length = 6,
      width = 32,
      height = 32,
      frame_count = 6,
    }
  }
}


data:extend({station_wall,green_door})

