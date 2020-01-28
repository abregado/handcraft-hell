require("util")
require('tiles')
require('walls')
require('character')
require('machines')
require('crafting_categories')

local new_basic_item = function(item_name,stack_size)
  return  {
    type = "item",
    name = item_name,
    icon = "__sf13__/graphics/icons/"..item_name..".png",
    icon_size = 32, icon_mipmaps = 4,
    subgroup = "intermediate-product",
    order = "e["..item_name.."]",
    stack_size = stack_size or 5
  }
end

local knife = new_basic_item('kitchen-knife',1)
local rolling_pin = new_basic_item('rolling-pin',1)

data:extend({knife,rolling_pin})

local create_recipes = function(item_list,recipe_category,fail_result)
  --create recipes
  for _, item in pairs(item_list) do
    local new_recipe = {
      type = "recipe",
      name = recipe_category.."-"..item.name,
      energy_required = 3,
      category = recipe_category,
      ingredients = {{item.name,1}},
      result = item[recipe_category] or fail_result,
      --main_product = "",
      --localised_name = {"string"},
      enabled = true
    }
    if type(new_recipe.result) == 'table' then
      new_recipe.result_count = new_recipe.result[2]
      new_recipe.result = new_recipe.result[1]
    end
    if new_recipe.result then
      data:extend({new_recipe})
    end
  end
end

local items = {
  {
    name = 'glass-empty',
    stack_size = 3,
    wetting = 'glass-water'
  },
  {
    name = 'glass-water',
    stack_size = 1,
    wetting = 'glass-empty',
    heating = 'glass-empty',
  },
  {
    name = 'glass-dirty',
    stack_size = 3,
    wetting = 'glass-empty',
  },
  {
    name = 'bowl-empty',
    stack_size = 3,
    wetting = 'bowl-water',
    heating = 'bowl-empty'
  },
  {
    name = 'bowl-water',
    stack_size = 1,
    wetting = 'bowl-empty',
    heating = 'bowl-empty'
  },
  {
    name = 'bowl-empty',
    wetting = 'bowl-water',
  },
  {
    name = 'wheat',
    stack_size = 10,
    grinding = 'flour'
  },
  {
    name = 'meat-slab',
    stack_size = 1,
    cutting = {'cutlet-raw',3}
  },
  {
    name = 'cutlet-raw',
    stack_size = 3,
    heating = 'cutlet'
  },
  {
    name = 'cutlet',
    stack_size = 3,
    processing = 'sausage',
    cutting = {'prosciutto',2}
  },
  {
    name = 'sausage',
    stack_size = 3,
  },
  {
    name = 'prosciutto',
    stack_size = 10
  },
  {
    name = 'pineapple',
    stack_size = 1,
    cutting = {'pineapple-ring',6}
  },
  {
    name = 'pineapple-ring',
    stack_size = 12,
  },
  {
    name = 'flour',
    stack_size = 5,
  },
  {
    name = 'tomato',
    stack_size = 5,
    grinding = 'tomato-sauce'
  },
  {
    name = 'tomato-sauce',
    stack_size = 5,
  },
  {
    name = 'milk',
    stack_size = 1,
    processing = 'cheese'
  },
  {
    name = 'cheese',
    stack_size = 1,
    cutting = {'cheese-wedge',8},
    processing = {'cheese-grated',8},
  },
  {
    name = 'cheese-wedge',
    stack_size = 4,
    processing = 'cheese-grated'
  },
  {
    name = 'cheese-grated',
    stack_size = 2,
  },
  {
    name = 'dough',
    stack_size = 1,
    rolling = 'dough-pizza'
  },
  {
    name = 'dough-pizza',
    stack_size = 1,
    heating = 'pizza-bread'
  },
  {
    name = 'pizza-bread',
    stack_size = 1,
  },
}

for _, item in pairs(items) do
  data:extend({new_basic_item(item.name,item.stack_size)})
end

create_recipes(items,'heating','burnt-mess')
create_recipes(items,'grinding')
create_recipes(items,'processing')
create_recipes(items,'wetting')
create_recipes(items,'cutting')
create_recipes(items,'rolling')

local new_recipe_with_catalyst = function(category,ingredients,results)
  local new_recipe = {
    type = 'recipe',
    name = category.."-"..ingredients[1][1],
    icon = "__sf13__/graphics/icons/"..results[1][1]..".png",
    icon_size = 32,
    icon_mipmaps = 1,
    energy_required = 5,
    category = "cooking",
    ingredients = ingredients,
    results = results,
    main_product = results[1][1],
  }
  data:extend({new_recipe})
end

local new_finished_product = function(name,ingredients)
  --create item
  data:extend({new_basic_item(name,1)})
  --create recipes
  local new_recipe = {
    type = "recipe",
    name = "crafting-"..name,
    energy_required = 10,
    category = "cooking",
    ingredients = ingredients,
    result = name,
    --main_product = "",
    --localised_name = {"string"},
    enabled = true
  }
  data:extend({new_recipe})
end

new_recipe_with_catalyst('cooking',{{'flour',3},{'bowl-water',1}},{{'dough',1},{'bowl-empty',1}})

new_finished_product('pizza-margherita',{{'pizza-bread',1},{'cheese-grated',1},{'tomato-sauce',1}})
new_finished_product('pizza-hawaii',{{'pizza-bread',1},{'cheese-grated',1},{'tomato-sauce',1},{'pineapple-ring',2}})
new_finished_product('pizza-pepperoni',{{'pizza-bread',1},{'cheese-grated',1},{'tomato-sauce',1},{'sausage',1},{'prosciutto',1}})

