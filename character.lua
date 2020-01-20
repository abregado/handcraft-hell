require("util")

local single_sprite_from_sheet = function(x,y,file_name)
  return {
    filename = "__sf13__/graphics/"..file_name,
    width = 32,
    height = 32,
    frame_count = 1,
    x = x*32,
    y = y*32,
    shift = {0,0}
  }
end

local single_frame_clothes_animation = function(x,do_tint)
  return {
    filename = "__sf13__/graphics/character/clothes.png",
    width = 32,
    height = 32,
    frame_count = 1,
    direction_count = 4,
    --animation_speed = 0.15,
    apply_runtime_tint = do_tint,
    x = x*32,
    shift = {0,-0.5}
  }
end

local single_frame_body_animation = function(x,do_tint)
  return {
    filename = "__sf13__/graphics/character/mixed.png",
    width = 32,
    height = 32,
    frame_count = 1,
    direction_count = 4,
    --animation_speed = 0.15,
    apply_runtime_tint = do_tint,
    x = x*32,
    shift = {0,-0.5}
  }
end

local clothed_animation = function(outfit_number)
  return {
    single_frame_body_animation(0),
    single_frame_body_animation(1,true),
    single_frame_clothes_animation(outfit_number),
    single_frame_body_animation(3),
    single_frame_body_animation(4,true),
  }
end

local unclothed_animation = function()
  return {
    single_frame_body_animation(0),
    single_frame_body_animation(1,true),
    single_frame_clothes_animation(0),
    single_frame_body_animation(3),
    single_frame_body_animation(4,true),
  }
end

local outfits = {}
outfits['white-jumpsuit'] = {
  animation = clothed_animation(0),
}
outfits['purple-jumpsuit'] = {
  animation = clothed_animation(1),
}
outfits['green-jumpsuit'] = {
  animation = clothed_animation(2),
}
outfits['yellow-jumpsuit'] = {
  animation = clothed_animation(3),
}
outfits['blue-jumpsuit'] = {
  animation = clothed_animation(4),
}
outfits['engineer-jumpsuit'] = {
  animation = clothed_animation(5),
}
outfits['cargo-jumpsuit'] = {
  animation = clothed_animation(6),
}
outfits['research-jumpsuit'] = {
  animation = clothed_animation(7),
}
outfits['security-jumpsuit'] = {
  animation = clothed_animation(8),
}
outfits['medical-jumpsuit'] = {
  animation = clothed_animation(9),
}

local character = util.table.deepcopy(data.raw["character"]["character"])
character.animations[1].idle = {layers = unclothed_animation()}
character.animations[1].running = {layers = unclothed_animation()}
character.crafting_categories = {"cooking","rolling","cutting"}
character.inventory_size = 10
character.build_distance = 3
character.drop_item_distance = 2
character.reach_distance = 2
character.item_pickup_distance = 2
character.reach_resource_distance = 2

for outfit_name, outfit_data in pairs(outfits) do
  --create outfit items
  local outfit = util.table.deepcopy(data.raw["armor"]["light-armor"])
  outfit.name = outfit_name
  outfit.icon = "__sf13__/graphics/icons/"..outfit_name..".png"
  outfit.icon_size = 32
  data:extend({outfit})

  --add armor variation to character
  local nude_animation = util.table.deepcopy(character.animations[1])
  nude_animation.idle = {layers=outfit_data.animation}
  nude_animation.running = {layers=outfit_data.animation}
  nude_animation.armors = {outfit_name}
  table.insert(character.animations,nude_animation)
end

data:extend({character})
