data:extend({
  {
    type = "tile",
    name = "kitchen",
    collision_mask = {"ground-tile"},
    layer = 70,
    variants =
    {
      main =
      {
        {
          picture = "__sf13__/graphics/tiles/kitchen.png",
          count = 1,
          size = 1
        }
      },
      empty_transitions = true
    },
    map_color={r=49, g=49, b=49},
    pollution_absorption_per_second = 0
  },
  {
    type = "tile",
    name = "freezer",
    collision_mask = {"ground-tile"},
    layer = 70,
    variants =
    {
      main =
      {
        {
          picture = "__sf13__/graphics/tiles/freezer.png",
          count = 1,
          size = 1
        }
      },
      empty_transitions = true
    },
    map_color={r=49, g=49, b=49},
    pollution_absorption_per_second = 0
  },
})