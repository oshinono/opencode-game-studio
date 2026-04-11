# GameMaker Studio — Current Best Practices

Last verified: 2026-04-08 | Engine: GameMaker Studio 2024.13

Practices that are **new or changed** since the model's training data (~2024.6).
This supplements (not replaces) the agent's built-in knowledge.

## GML Language (2024.13)

### Script Function Inheritance — MUST READ

The compiler now optimises static function calls. **Any script function that
relies on a child object overriding a function it calls must use `self.`**:

```gml
// ✅ CORRECT: self. ensures dynamic dispatch
function enemy_update() {
    self.enemy_move();    // resolves to child's override at runtime
    self.enemy_attack();
}

// ✅ ALSO CORRECT: method variable syntax (always dynamic)
enemy_update = function() {
    enemy_move();         // methods resolve on self automatically
};

// ❌ BROKEN in 2024.13: static resolution, child override ignored
function enemy_update() {
    enemy_move();         // calls parent's enemy_move(), not child's
}
```

**Rule**: If a script function in a parent object calls another function that
child objects override, either use `self.function_name()` or switch to method
variable syntax for the parent function.

### Keywords as Variable Names (2024.13)

Reserved keywords (`then`, `do`, etc.) can now be used as variable names.
Feather and CE2 will show errors but the code will build and run.
**Avoid this pattern** — it creates confusion and future-proofing issues.

### `handle_parse()` Improvements (2024.13)

```gml
// Now accepts asset names, not just numeric IDs
var spr = handle_parse("ref sprite spr_player");   // ✅ works
var fn  = handle_parse("ref function my_func");    // ✅ works (built-in too)
```

## UI Layers (2024.13 — New Feature)

UI Layers are global, persistent UI containers that survive room transitions and
render above the application surface (including black bars).

```gml
// UI Layers are created in the Room Editor, not in code
// Access and manipulate assets on UI layers at runtime:
layer_exists("UI_HUD")          // check if UI layer exists
layer_get_id("UI_HUD")          // get layer ID for manipulation
layer_element_exists(layer, el) // query if an element is on a UI layer
```

**Key properties:**
- Defined in Room Editor as "UI Layer" type
- Global — defined once, available in all rooms
- Scale to fit game window (including black bars)
- Drawn above the application surface
- HTML5 support coming in 2024.14 — do not use for HTML5-targeted features yet

## FlexPanel System (2024.11 — Stable)

A Flexbox-inspired layout system for scalable UI. Use for dynamic HUD layouts,
menus, and UI that must adapt to different screen sizes.

```gml
// Create a flex container
var panel = flexpanel_create_node();
flexpanel_node_set_width(panel, 200);
flexpanel_node_set_height(panel, 100);
flexpanel_node_set_padding(panel, 10, 10, 10, 10);

// Inspect/debug panel layout
var struct = flexpanel_node_get_struct(panel);
show_debug_message(struct);
```

**Use FlexPanel for**: Adaptive menus, inventory grids, dialogue boxes that
must work across aspect ratios. Use standard Draw GUI for simple HUDs.

## Instance & Collision Checks (2024.13)

Always use `== noone` for collision checks, not `is_number()`:

```gml
// ✅ CORRECT in all versions including 2024.13
var wall = instance_place(x, y+4, obj_wall);
if (wall != noone) {
    // collision detected
}

// ❌ BROKEN in 2024.13 — noone is a handle ref, is_number() returns false
var wall = instance_place(x, y+4, obj_wall);
if (!is_number(wall) || wall == noone) { }
```

## Asset References (2024.13)

Asset-returning functions now return typed refs — pass them directly to API:

```gml
// ✅ Handle refs work directly in all GML API calls
var spr = object_get_sprite(obj_player);
draw_sprite(spr, 0, x, y);            // ✅ works
sprite_get_width(spr);                // ✅ works

// ❌ Don't cast or check with is_number() first
if (is_number(spr)) { draw_sprite(spr, 0, x, y); }  // ❌ always false in 2024.13
```

## Debug & Testing Utilities (2024.13 — New)

```gml
// Automate input for testing sequences
debug_input_record();           // start recording inputs
debug_input_save("test_run");   // save to file
debug_input_playback("test_run"); // replay

// Physics debug output
physics_debug(true);  // enable physics error logging (previously silent)

// Buffer size inspection
var used = buffer_get_used_size(my_buffer);  // new in 2024.13
```

## Physics Convex Hull at Runtime (2024.13 — New)

```gml
// Generate convex hull points from a sprite for runtime physics shapes
var hull_points = sprite_get_convex_hull(spr_player, 4);  // precision = 4
// Returns array of [x0,y0, x1,y1, ...] pairs
```

## Permission Requests — Cross-Platform (2024.13)

`os_request_permission()` now works beyond Android — also on GX.games / iOS
for device motion / camera access:

```gml
// Request camera permission (GX.games mobile, iOS)
os_request_permission("camera");

// Request device motion / gyro (all mobile targets)
os_request_permission("DeviceMotion");
```

## Android Build Requirements (2024.13)

- **Compile SDK minimum**: 34 (Android 14) — builds fail if set lower
- **Edge-to-Edge display**: Opt-in via Game Options → Android → Graphics
- **Gradle version**: Now configurable per-project in Game Options → Android → General
- **Async layout events**: `Async System` event fires with `"DisplayLayoutInfo"` type
  when screen layout changes (safe insets, cutouts, waterfall display)

## Asset Management

### Prefab Library (2024.13 — Stable)

Prefabs are standalone reusable project packages. Two usage modes:
- **Linked**: Drag from Prefab Library → source lives outside your project, pulled at build time. Stays updated with new prefab versions.
- **Duplicated**: Right-click → Duplicate to project → source is copied in, editable, but breaks link to upstream updates.

### SVG Support (2024.13 — New)

```gml
// SVGs can be imported as sprites in the IDE
// At runtime they behave identically to raster sprites
// Import: drag .svg into Asset Browser or use sprite_add() with data URLs
sprite_add("https://...", 1, false, false, 0, 0);  // works with data URLs too
```

### Asset Tags Always Compile (`gml_pragma`)

```gml
// Mark assets with a tag in the IDE, then ensure they're always compiled
// even when "Remove Unused Assets" is ON:
gml_pragma("MarkTagAsUsed", "AlwaysInclude");
```

## Build Pipeline

### Clean Scripts (2024.13 — New)

Custom batch/shell scripts now supported for clean operations:
- `pre_clean_step.bat` / `pre_clean_step.sh`
- `post_clean_step.bat` / `post_clean_step.sh`

These follow the same convention as `pre_build_step` scripts.

### Runtime Version Flexibility (2024.13)

GameMaker no longer forces installing the exact matching runtime if a newer
patch runtime from the same major version is already active. This means a
`2024.1300.0.242` runtime satisfies `2024.1300` IDE requirements.
