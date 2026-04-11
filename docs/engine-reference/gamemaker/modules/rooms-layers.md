# GameMaker Studio — Rooms & Layers Quick Reference

Last verified: 2026-04-08 | Engine: 2024.13

## Room System Overview

Rooms are GameMaker's primary scene containers. Each room is a discrete game
state. Objects are placed in rooms; the room drives the active game loop.

```gml
// Transition between rooms
room_goto(rm_gameplay);          // go to specific room
room_goto_next();                // go to next room in resource order
room_restart();                  // restart current room

// Query current room
var current = room;              // built-in variable, current room ref
var name    = room_get_name(room);
```

## Layer Types

| Layer Type | Use For | Code API Prefix |
|------------|---------|----------------|
| Instance | Game objects (obj_*) | `layer_instance_*` |
| Tile | Tilemap graphics | `layer_tilemap_*` |
| Background | Parallax/flat backgrounds | `layer_background_*` |
| Asset (Sprites) | Static sprite graphics | `layer_sprite_*` |
| Path | Pathfinding visualization (editor only) | N/A |
| Particle | Particle systems | `layer_get_id()` + particle functions |
| **UI Layer** *(2024.13)* | Global HUD/UI (persistent across rooms) | `layer_*` (same API) |

## Layer Management

```gml
// Get layer by name
var ui_layer = layer_get_id("UI_HUD");

// Create a layer at runtime
var new_layer = layer_create(100);                  // depth 100
var named     = layer_create(100, "DynamicLayer");

// Create instance on a specific layer
var inst = instance_create_layer(x, y, "Instances", obj_enemy);

// Destroy layer (also destroys all elements on it)
layer_destroy(layer_get_id("TempLayer"));
```

## UI Layers (2024.13 — New)

UI Layers are **global and persistent** — they survive room transitions and
render above the application surface.

```gml
// UI Layers are defined in the Room Editor, not created in code
// Check if a named UI layer exists
if (layer_exists("UI_HUD")) {
    var hud = layer_get_id("UI_HUD");
    // manipulate elements on hud layer
}

// Query if an element is on a UI layer
// (new function in 2024.13)
// See: layer_element_exists(layer_id, element_id)
```

**Rules for UI Layers:**
- Create in Room Editor → Layer panel → "Add UI Layer"
- Not supported on HTML5 in 2024.13 (coming in 2024.14)
- Elements placed on UI layers use screen-space coordinates
- Scale automatically to game window, including black bars

## Persistent Objects vs Room Persistence

```gml
// Persistent object: survives all room changes
// Set in object properties or in Create Event:
persistent = true;   // this instance survives room_goto()

// Typical persistent singletons:
// obj_game_manager — score, state, progression
// obj_audio_manager — background music continuity
// obj_input_manager — input buffer state

// Pass state between rooms WITHOUT globals:
// Store data on the persistent object, read it in the new room
```

## Room Start / Room End Events

```gml
// Room Start Event — fires when the room begins
// Use to: initialize room-specific state, spawn enemies, set camera

// Room End Event — fires before room changes
// Use to: clean up ds structures, surfaces, stop room-specific sounds

// Destroy Event — fires when instance is removed
// Use to: free any memory owned by this instance specifically
```

## Cameras & Viewports

```gml
// Create a camera
var cam = camera_create_view(0, 0, 640, 360);  // x, y, w, h

// Assign camera to viewport 0
view_set_camera(0, cam);
view_enabled = true;
view_visible[0] = true;

// Follow a target smoothly
camera_set_view_target(cam, obj_player);  // built-in following

// Manual camera position
camera_set_view_pos(cam, target_x - 320, target_y - 180);

// Get current camera bounds
var cx = camera_get_view_x(view_camera[0]);
var cy = camera_get_view_y(view_camera[0]);
```

## Common Pitfalls

- **Never** place game logic in Room Start assuming persistent objects are ready
  — persistent objects may have `Game Start` but not `Room Start` if coming from
  a different room
- **Always** destroy ds structures and surfaces in `Room End Event` or
  `Destroy Event` — not in `Step Event` or `Draw Event`
- **Avoid** `room_goto()` inside a collision or Step event deep in a call stack
  — defer with an alarm if you encounter issues
