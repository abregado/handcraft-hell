local simple_machine_idle_animation = function(name,rotation)
  return {
    layers =
    {
      {
        filename = "__sf13__/graphics/entity/"..name..".png",
        priority = "high",
        width = 32,
        height = 64,
        y = 64*rotation,
        frame_count = 1,
        shift = {0, 0},
      },
    }
  }
end

local simple_machine_working_animation = function(name,rotation)
  return {
    {
      animation =
      {
        filename = "__sf13__/graphics/entity/"..name..".png",
        priority = "high",
        width = 32,
        height = 64,
        frame_count = 2,
        animation_speed = 0.15,
        x = 32,
        y = 32*rotation,
        shift = {0, 0},
      },
      --light = light and {intensity = 0.4, size = 6, shift = {0.0, 1.0}, color = {r = 1.0, g = 1.0, b = 1.0}} or {}
    }
  }
end

local simple_container = function (name,capacity)
  local machine = util.table.deepcopy(data.raw["container"]["steel-chest"])
  machine.name = name
  machine.icon = "__sf13__/graphics/icons/"..name..".png"
  machine.icon_size = 32
  machine.flags = {"player-creation"}
  machine.minable = nil
  machine.inventory_size = capacity
  machine.collision_box = {{-0.49, -0.49}, {0.49, 0.49}}
  machine.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
  machine.picture = simple_machine_idle_animation(name,0)

  return machine
end

local simple_machine = function (name,crafting_category)
  local machine = util.table.deepcopy(data.raw["furnace"]["electric-furnace"])
  machine.name = name
  machine.icon = "__sf13__/graphics/icons/"..name..".png"
  machine.icon_size = 32
  machine.flags = {"player-creation"}
  machine.minable = nil
  machine.collision_box = {{-0.49, -0.49}, {0.49, 0.49}}
  machine.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
  machine.crafting_categories = {crafting_category}
  machine.energy_source.type = "void"
  machine.animation = simple_machine_idle_animation(name,0)
  machine.working_visualisations = simple_machine_working_animation(name,0)

  return machine
end

local microwave = simple_machine('microwave','heating')
local microwave_table = simple_machine('microwave-table','heating')
local food_processor = simple_machine('food-processor','processing')
local grinder_table = simple_machine('grinder-table','grinding')
local sink = simple_machine('sink','wetting')
local smart_fridge = simple_container('smart-fridge',30)
local fridge = simple_container('fridge',10)
local table = simple_container('table',4)
local kitchen_vending = simple_container('kitchen-vending-machine',10)
local black_locker = simple_container('black-locker',10)

data:extend({microwave,microwave_table,food_processor,grinder_table,sink,fridge,smart_fridge,table,kitchen_vending,black_locker})