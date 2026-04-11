# GameMaker Studio — Assets Quick Reference

Last verified: 2026-04-08 | Engine: 2024.13

## Texture Groups

Texture Groups (defined in the IDE) pack sprites and backgrounds into shared
texture pages for efficient GPU batching. Separate groups break draw call
batching — minimize groups while keeping logical separation.

```gml
// At runtime, query texture page info:
var tex_id = sprite_get_texture(spr_player, 0);  // image index 0
var uvs     = sprite_get_uvs(spr_player, 0);     // [u1,v1,u2,v2,xoff,yoff,w,h,ow,oh]

// Dynamic texture manipulation (advanced):
texture_set_stage(0, tex_id);  // bind to texture stage for shaders
```

**IDE Rule of Thumb:**
- Default Group: UI sprites, common objects
- Characters Group: Player, NPCs, enemies
- World Group: Tilesheets, environment
- Effects Group: VFX, particles, explosions

## Sprites

```gml
// Sprite info queries
var w   = sprite_get_width(spr_player);
var h   = sprite_get_height(spr_player);
var ox  = sprite_get_xoffset(spr_player);
var oy  = sprite_get_yoffset(spr_player);
var num = sprite_get_number(spr_player);  // frame count

// Runtime sprite creation
var spr = sprite_create_from_surface(surf, x, y, w, h, remove, smooth, xo, yo);
var spr = sprite_add(path, imgnumb, removeback, smooth, xoffset, yoffset);

// 2024.13: data URL support in sprite_add
var spr = sprite_add("data:image/png;base64,...", 1, false, false, 0, 0);

// SVG support (2024.13): import via IDE, behaves like raster sprite at runtime

// Convex hull for physics (2024.13 — new)
var hull = sprite_get_convex_hull(spr_player, 4);  // returns point array
```

## Fonts

```gml
// Runtime font creation (avoid — prefer IDE-imported fonts)
var fnt = font_add("Arial", 16, true, false, 32, 127);
font_delete(fnt);  // always delete runtime fonts when done

// Built-in font queries
var h = font_get_size(fnt_ui);
var n = font_get_name(fnt_ui);

// SDF fonts: created in IDE with "SDF" checkbox
// Use for fonts that need crisp scaling (HUD score, title text)
```

## Sounds

See `modules/audio.md` for full audio reference.

```gml
// Sound queries
var name = audio_get_name(snd_jump);
var dur  = audio_sound_length(snd_jump);   // in seconds
```

## Object & Instance Queries

```gml
// Asset queries — return typed refs in 2024.13
var spr  = object_get_sprite(obj_player);  // ref sprite N
var mask = object_get_mask(obj_player);    // ref sprite N

// Instance creation
var inst = instance_create_layer(x, y, "Instances", obj_enemy);
var inst = instance_create_depth(x, y, 100, obj_bullet);

// Instance destruction
instance_destroy(inst);     // destroy specific instance
instance_destroy();         // destroy self (inside an object event)

// Instance queries — ALWAYS check != noone before use
var nearest = instance_nearest(x, y, obj_coin);
if (nearest != noone) {
    nearest.collected = true;
}
```

## Asset Tags (2024.13 — gml_pragma)

```gml
// Force-include tagged assets even when "Remove Unused Assets" is ON
// Add in any script that runs at game start (e.g., obj_game_manager Create):
gml_pragma("MarkTagAsUsed", "AlwaysInclude");

// Then tag your assets in the IDE's Asset Browser with the matching tag
```

## Prefab Library (2024.13 — New)

Prefabs are self-contained reusable project packages (characters, mechanics, UI).

**Workflow:**
1. Open `Windows → Prefab Library` in the IDE
2. Install prefab collections via Package Manager
3. Drag prefab from library into Room/Object Editor → linked mode (source not in project)
4. Right-click → Duplicate to project → copied mode (editable, breaks upstream link)

**Code note**: Prefab-linked assets behave identically to regular assets at
runtime. No special GML API needed.

## Common Pitfalls

- Sprite draw order on the same layer is determined by creation order as of
  2024.13 — was changed from previous undefined behavior (#10290)
- `string()` on an asset ref now returns the ref string (e.g., `"ref sprite 4"`)
  not the numeric ID — use `sprite_get_name(spr)` if you need the name string
- Unused asset stripping (`Remove Unused Assets`) can remove sounds and scripts
  only referenced through macros — use `gml_pragma("MarkTagAsUsed", ...)` to protect them
