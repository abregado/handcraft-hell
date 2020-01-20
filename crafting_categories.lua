local new_basic_item = function(item_name,stack_size)
  return  {
    type = "item",
    name = item_name,
    icon = "__sf13__/graphics/icons/"..item_name..".png",
    icon_size = 32, icon_mipmaps = 4,
    subgroup = "intermediate-product",
    order = "e["..item_name.."]",
    stack_size = 5
  }
end

local set_up_crafting_category = function(recipe_category,fail_result)
  --create failed-result-item
  if fail_result then
    data:extend({new_basic_item(fail_result)})
  end
  --create crafting category
  data:extend({
    {
      type = "recipe-category",
      name = recipe_category
    },
  })
  --create item category
  data:extend({{
    type = "item-group",
    name = recipe_category,
    order = "a",
    icon = "__sf13__/graphics/item-group/"..recipe_category..".png",
    icon_size = 32
  }})
end

set_up_crafting_category('heating','burnt-mess')
set_up_crafting_category('grinding','burnt-mess')
set_up_crafting_category('processing','burnt-mess')
set_up_crafting_category('wetting')
set_up_crafting_category('cutting')
set_up_crafting_category('rolling')
set_up_crafting_category('cooking')