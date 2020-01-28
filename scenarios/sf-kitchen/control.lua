local handler = require("__base__.lualib.event_handler")
local math2d = require('math2d')

local set_force_to_craft = function(force,category,state)
  for name, recipe in pairs(force.recipes) do
    if recipe.category == category then
      recipe.enabled = state
    end
  end
end

local allow_force_to_craft = function(force,category)
  for name, recipe in pairs(force.recipes) do
    if recipe.category == category then
      recipe.enabled = true
    end
  end
end

local update_order_overlay = function()
  local goal_table_area = game.surfaces[1].get_script_areas('goal-area')[1]
  local top_position = {
    x = goal_table_area.area.left_top.x,
    y = goal_table_area.area.right_bottom.y,
  }
  rendering.set_text(global.orders_filled_id,"Orders  filled: "..global.orders_filled)
  rendering.set_target(global.orders_filled_id,{
      x = top_position.x,
      y = top_position.y
    })
  for index, order in pairs(global.orders) do
    rendering.set_target(order.overlay_id,{
      x = top_position.x,
      y = top_position.y + (index*0.5)
    })
  end
end

local add_orders = function()
  if #global.orders < global.max_orders then
    local random_new_order = math.random(1,#global.order_options)
    local new_order = {
      need = global.order_options[random_new_order].need,
      returns = global.order_options[random_new_order].returns,
      }
    new_order.overlay_id = rendering.draw_text({
        target = {x=0,y=0},
        text = game.item_prototypes[new_order.need].localised_name,
        color = {0,1,0},
        scale = 0.5,
        surface = game.surfaces[1],
    })
    table.insert(global.orders,new_order)
  end
end

local check_orders = function()
  local goal_table_area = game.surfaces[1].get_script_areas('goal-area')[1].area
  local goal_tables = game.surfaces[1].find_entities_filtered({
    name = 'table',
    area = goal_table_area
  })
  for _, container in pairs(goal_tables) do
    local contents = container.get_inventory(defines.inventory.chest).get_contents()
    for index, order in pairs(global.orders) do
      if contents[order.need] then
        if order.returns and container.get_inventory(defines.inventory.chest).can_insert({name=order.returns,count=1}) then
          container.get_inventory(defines.inventory.chest).remove({name=order.need,count=1})
          container.get_inventory(defines.inventory.chest).insert({name=order.returns,count=1})
          global.orders_filled = global.orders_filled + 1
          rendering.destroy(order.overlay_id)
          table.remove(global.orders,index)
        else
          container.get_inventory(defines.inventory.chest).remove({name=order.need,count=1})
          global.orders_filled = global.orders_filled + 1
          rendering.destroy(order.overlay_id)
          table.remove(global.orders,index)
        end
      end
    end
  end

  add_orders()
  update_order_overlay()
end

local on_player_changed_position = function(event)
  local player = game.players[event.player_index]
  if player.controller_type == defines.controllers.character then
    for _ , zone in pairs(global.vision_zones) do
      rendering.set_visible(zone.overlay_id,not math2d.bounding_box.contains_point(zone.bounding_box,player.position))
    end
  end
end

local on_game_created_from_scenario = function(event)
  for name, force in pairs(game.forces) do
    force.disable_all_prototypes()
  end

  global.orders = {}
  global.order_options = {
    {need='pizza-margherita'},
    {need='pizza-pepperoni'},
    {need='pizza-hawaii'},
    {need='glass-water',returns='glass-dirty'},
  }
  global.max_orders = 3
  global.orders_filled = 0
  global.orders_filled_id = rendering.draw_text({
    target = {x=0,y=0},
    text = "",
    color = {0,1,0},
    scale = 0.5,
    surface = game.surfaces[1],
  })

  add_orders()
  add_orders()
  add_orders()
  update_order_overlay()

  global.vision_zones = {}
  local areas = game.surfaces[1].get_script_areas('vision')
  for _, area in pairs(areas) do
    table.insert(global.vision_zones,{
      bounding_box = area.area,
      overlay_id = rendering.draw_rectangle({
        color = {0,0,0},
        left_top = {
          x = area.area.left_top.x +0.5,
          y = area.area.left_top.y +0.5,
        },
        right_bottom = {
          x = area.area.right_bottom.x -0.5,
          y = area.area.right_bottom.y -0.5,
        },
        surface = game.surfaces[1],
        filled = true
      })
    })
  end
  global.item_recipes = {}
  global.item_recipes['kitchen-knife'] = {item = 'kitchen-knife', category = 'cutting'}
  global.item_recipes['rolling-pin'] = {item = 'rolling-pin', category = 'rolling'}

  for _, group_data in pairs(global.item_recipes) do
    group_data.recipes = {}
    for name, recipe in pairs(game.forces.player.recipes) do
      if recipe.category == group_data.category then
        table.insert(group_data.recipes,name)
      end
    end
  end

  allow_force_to_craft(game.forces.kitchen,'grinding')
  allow_force_to_craft(game.forces.kitchen,'heating')
  allow_force_to_craft(game.forces.kitchen,'processing')
  allow_force_to_craft(game.forces.kitchen,'wetting')

  allow_force_to_craft(game.forces.player,'cooking')

  game.forces.player.set_friend('kitchen',true)
  game.forces.kitchen.set_friend('player',true)
end

local on_player_main_inventory_changed = function(event)
  local player = game.players[event.player_index]
  if player.controller_type == defines.controllers.character then
    local contents = player.get_main_inventory().get_contents()
    local recipe_categories
    for item, data in pairs(global.item_recipes) do
      if contents[item] then
        set_force_to_craft(player.force,data.category,true)
      else
        set_force_to_craft(player.force,data.category,false)
      end
    end
  end
end

local on_player_cursor_stack_changed = function(event)
  local player = game.players[event.player_index]
  if player.controller_type == defines.controllers.character then
    check_orders()
  end
end

local on_player_created = function (event)

end

local events = {
  [defines.events.on_game_created_from_scenario] = on_game_created_from_scenario,
  [defines.events.on_player_changed_position] = on_player_changed_position,
  [defines.events.on_player_created] = on_player_created,
  [defines.events.on_player_main_inventory_changed] = on_player_main_inventory_changed,
  [defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed,
}

local event_recievers = {
  events
}

handler.setup_event_handling(event_recievers)