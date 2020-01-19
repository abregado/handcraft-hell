require("util")
require('tiles')
require('walls')
require('character')
local hit_effects = require ("__base__.prototypes.entity.demo-hit-effects")

generic_impact_sound = function()
  return
  {
    {
      filename = "__base__/sound/car-metal-impact.ogg", volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-2.ogg", volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-3.ogg", volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-4.ogg", volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-5.ogg", volume = 0.5
    },
    {
      filename = "__base__/sound/car-metal-impact-6.ogg", volume = 0.5
    }
  }
end

local new_basic_item = function(item_name)
  return  {
    type = "item",
    name = item_name,
    icon = "__sf13__/graphics/icons/"..item_name..".png",
    icon_size = 32, icon_mipmaps = 4,
    subgroup = "intermediate-product",
    order = "e["..item_name.."]",
    stack_size = 1
  }
end

local set_up_crafting_category = function(item_list,recipe_category,fail_result)
  --create failed-result-item
  data:extend({new_basic_item(fail_result)})
  --create crafting category
  data:extend({
    {
      type = "recipe-category",
      name = recipe_category
    },
  })

  --create recipes
  for _, item in pairs(item_list) do
    local new_recipe = {
      type = "recipe",
      name = recipe_category.."-"..item.name,
      energy_required = 10,
      category = recipe_category,
      ingredients = {{item.name,1}},
      result = item[recipe_category] or fail_result,
      --main_product = "",
      --localised_name = {"string"},
      enabled = true
    }
    data:extend({new_recipe})
  end
end

local items = {
  {
    name ='raw-cutlet',
    heating ='cutlet'
  },
  {
    name = 'cutlet',
  },
  {
    name = 'spaghetti',
    heating = 'boiled-pasta'
  },
  {
    name = 'boiled-pasta',
  },
  {
    name = 'pizza-dough',
    heating = 'pizza-bread'
  },
  {
    name = 'pizza-bread',
  },
}

for _, item in pairs(items) do
  data:extend({new_basic_item(item.name)})
end

set_up_crafting_category(items,'heating','burnt-mess')

local microwave = util.table.deepcopy(data.raw["furnace"]["electric-furnace"])
microwave.name = 'microwave'
microwave.icon = "__sf13__/graphics/icons/microwave.png"
microwave.icon_size = 32
microwave.flags = {"player-creation"}
microwave.minable = nil
microwave.collision_box = {{-0.49, -0.49}, {0.49, 0.49}}
microwave.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
microwave.crafting_categories = {"heating"}
microwave.animation = {
  layers =
  {
    {
      filename = "__sf13__/graphics/entity/microwave.png",
      priority = "high",
      width = 32,
      height = 32,
      frame_count = 1,
      shift = {0, 0},
    },
  }
}
microwave.working_visualisations = {
  {
    animation =
    {
      filename = "__sf13__/graphics/entity/microwave.png",
      priority = "high",
      width = 32,
      height = 32,
      frame_count = 1,
      x = 64,
      shift = {0, 0},
    },
    light = {intensity = 0.4, size = 6, shift = {0.0, 1.0}, color = {r = 1.0, g = 1.0, b = 1.0}}
  }
}

data:extend({microwave})

