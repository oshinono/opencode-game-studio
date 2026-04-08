# GameMaker Studio — UI & Draw GUI Quick Reference

Last verified: 2026-04-08 | Engine: 2024.13

## Draw GUI vs Draw Event

| Event | Coordinate Space | Camera Affected | Use For |
|-------|-----------------|-----------------|---------|
| `Draw Event` | World space | Yes (camera transforms apply) | Game objects, sprites, world effects |
| `Draw GUI Event` | Screen space (0,0 = top-left) | No | HUD, health bars, score, menus |

**Rule**: All HUD and UI elements belong in `Draw GUI Event`, not `Draw Event`.
Drawing in `Step Event` renders nothing.

## Draw GUI Coordinate System

```gml
// Draw GUI: origin is top-left of screen, not affected by camera
// display_get_gui_width() / display_get_gui_height() for safe area

var sw = display_get_gui_width();   // GUI canvas width
var sh = display_get_gui_height();  // GUI canvas height

// Center-screen position
draw_text(sw / 2, sh / 2, "PAUSED");

// Bottom-right anchor
draw_sprite(spr_health_icon, 0, sw - 64, sh - 32);
```

## Text Rendering

```gml
// Set font before drawing text
draw_set_font(fnt_ui_default);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);

draw_text(x, y, "Score: " + string(score));
draw_text_colour(x, y, "Score", c_yellow, c_yellow, c_yellow, c_yellow, 1);

// Multiline text
draw_text_ext(x, y, long_string, line_height, max_width);

// SDF fonts (crisp at any scale — requires SDF font asset)
// Set in Font editor: "SDF" checkbox
```

## Shape & Primitive Drawing

```gml
draw_set_colour(c_red);
draw_set_alpha(0.8);

draw_rectangle(x1, y1, x2, y2, false);  // false = filled
draw_circle(x, y, radius, false);
draw_roundrect(x1, y1, x2, y2, xrad, yrad, false);
draw_line_width(x1, y1, x2, y2, 3);

// Progress bar pattern
var bar_w = 200;
var fill  = bar_w * (hp / max_hp);
draw_rectangle(10, 10, 10 + bar_w, 26, false);  // background
draw_set_colour(c_lime);
draw_rectangle(10, 10, 10 + fill, 26, false);    // fill
```

## Sprite Drawing

```gml
// World space (Draw Event)
draw_sprite(spr_player, image_index, x, y);
draw_sprite_ext(spr, sub, x, y, xscale, yscale, rot, colour, alpha);

// Screen space (Draw GUI Event) — same functions, different context
draw_sprite(spr_hud_health, 0, 16, 16);
```

## UI Layers (2024.13 — New System)

UI Layers are a higher-level alternative to manual Draw GUI coding for persistent
HUD elements that survive room transitions:

```gml
// Prefer UI Layers for: health bars, minimaps, persistent overlay menus
// Prefer Draw GUI Event for: dynamic/data-driven HUD, custom animations

// UI Layer assets are placed in the Room Editor
// At runtime, manipulate via existing layer/element functions:
var hud = layer_get_id("UI_HUD");
var elem = layer_get_all_elements(hud);  // returns array of element refs
```

## FlexPanel (2024.11+ Stable)

For adaptive layouts (menus, inventory grids, dialogue boxes):

```gml
// Create flex layout container
var container = flexpanel_create_node();
flexpanel_node_set_width(container, 400);
flexpanel_node_set_height(container, 300);
flexpanel_node_set_flex_direction(container, flexpanel_flex_direction.column);
flexpanel_node_set_align_items(container, flexpanel_align.center);
flexpanel_node_set_padding(container, 16, 16, 16, 16);

// Add child nodes
var btn = flexpanel_create_node();
flexpanel_node_set_width(btn, 200);
flexpanel_node_set_height(btn, 40);
flexpanel_node_add_child(container, btn);

// Compute layout
flexpanel_calculate_layout(container, 800, 600, flexpanel_direction.ltr);

// Query computed position for drawing
var left = flexpanel_node_layout_get_left(btn);
var top  = flexpanel_node_layout_get_top(btn);
draw_rectangle(left, top, left + 200, top + 40, false);
```

## Common Pitfalls

- `draw_set_font()`, `draw_set_colour()`, `draw_set_alpha()` are **global state**
  — always set them at the start of every Draw event, never assume previous state
- Surfaces drawn in Draw GUI must check `surface_exists()` first — surfaces are
  lost on focus change (especially mobile/browser targets)
- `display_get_gui_width()` may differ from the room width if GUI scale is
  customized — always use GUI functions for Draw GUI coordinates
