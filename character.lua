require("util")

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

local clothed_animation = function()
  return {
    single_frame_body_animation(0),
    single_frame_body_animation(1,true),
    single_frame_body_animation(2),
    single_frame_body_animation(3),
    single_frame_body_animation(4,true),
  }
end

local character = util.table.deepcopy(data.raw["character"]["character"])
character.animations[1].idle = {layers = clothed_animation()}
character.animations[1].running = {layers = clothed_animation()}

data:extend({character})