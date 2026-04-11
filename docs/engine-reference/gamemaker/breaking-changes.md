# GameMaker Studio — Breaking Changes

Last verified: 2026-04-08

Changes introduced in GameMaker Studio post-LLM-cutoff versions (2024.11+).
The LLM likely knows GMS2 API up to approximately 2024.6.

## 2024.13 (Apr 2025 — POST-CUTOFF, HIGH RISK)

### CRITICAL: Function Inheritance Behavior Change

**Subsystem**: GML Language / Compiler

The compiler now optimises direct function calls when the script can be resolved
at compile time. **This breaks the previous inheritance pattern** where a parent
script function calls a child-overridden function.

| Before 2024.13 | After 2024.13 |
|----------------|---------------|
| `functionA()` calling `functionB()` would resolve `functionB` dynamically, picking up the child's override | `functionA()` now resolves `functionB` statically at compile time — it calls the **parent's** `functionB`, not the child's override |

**Fix — two options:**

```gml
// Option 1: Add "self." prefix so runtime resolves on the instance
function functionA() {
    self.functionB();  // ← resolves dynamically, picks up child override
}

// Option 2: Declare functionA as a method (not a script function)
functionA = function() {
    functionB();  // methods always resolve on self
};
```

**Affected pattern** (common in object inheritance):
```gml
// obj_enemy_parent — Script
function enemy_update() {
    enemy_move();   // ← BROKEN in 2024.13 if child overrides enemy_move()
}

// obj_enemy_child — Create Event
function enemy_move() {
    // child-specific movement
}
```

**Reference**: https://manual.gamemaker.io/monthly/en/#t=GameMaker_Language%2FGML_Overview%2FScript_Functions_vs_Methods.htm

---

### Handle Type System — `noone` Return Change

**Subsystem**: Instances / Collision

Functions that previously returned the number `-4` for "no instance found"
now return a typed instance handle `ref instance -4`.

**Impact**: Code using `is_number()` to check for `noone` will now get `false`.

```gml
// ❌ BROKEN in 2024.13
var inst = instance_place(x, y, obj_wall);
if (is_number(inst) && inst == noone) { ... }

// ✅ CORRECT — use noone constant directly
var inst = instance_place(x, y, obj_wall);
if (inst == noone) { ... }
```

**Affected functions** (sample — collision functions and layer functions):
- `instance_place()`, `instance_nearest()`, `collision_rectangle()`, etc.
- `layer_instance_get_instance()` — now returns handle ref, not `-4`

---

### Asset Ref Functions Return Handles, Not Numbers

**Subsystem**: Assets / Resources

Several functions that returned numeric asset IDs now return typed handle refs.
Code that checks `is_number()` on these return values will behave differently.

| Function | Old Return | New Return |
|----------|-----------|-----------|
| `object_get_sprite()` | Number | `ref sprite N` |
| `object_get_mask()` | Number | `ref sprite N` |
| `shader_current()` | Number | `ref shader N` |
| `layer_get_script_begin()` | Number | `ref script N` |
| `layer_get_script_end()` | Number | `ref script N` |
| `layer_get_id_at_depth()` (no layer at depth) | Number `-1` | `ref layer -1` |
| `room_next()` / `room_previous()` (invalid) | Number `-1` | Returns `-1` as number (exception) |

```gml
// ❌ OLD pattern (broken)
var spr = object_get_sprite(obj_player);
if (is_number(spr)) { sprite_set_speed(spr, 1); }

// ✅ NEW pattern
var spr = object_get_sprite(obj_player);
sprite_set_speed(spr, 1);  // handle refs work directly in API calls
```

---

### `handle_parse()` Behavior Changes

**Subsystem**: GML Language

- Now accepts asset/function **names** (not just numbers) as strings
- Now supports built-in function names
- Invalid handles return `undefined` or `"ref -1"` instead of crashing

---

## 2024.11 (Nov 2024 — POST-CUTOFF, HIGH RISK)

### FlexPanel System (Stable)

**Subsystem**: UI / Room Editor

FlexPanel (`flexpanel_*`) functions promoted from beta to stable. A new CSS
Flexbox-inspired UI layout system for building scalable in-game UI.

| New Functions | Purpose |
|---------------|---------|
| `flexpanel_create_node()` | Create a flex container node |
| `flexpanel_node_get_struct()` | Get node as a struct for inspection |
| `flexpanel_set_*()` | Set layout properties (size, padding, align) |

**Note**: FlexPanel is a precursor to the 2024.13 UI Layers feature. The two
systems work together — UI Layers use FlexPanels internally.

---

### Deprecated OS Constants

**Subsystem**: Platform / OS detection

The following `os_*` constants are now deprecated (for removed/unsupported platforms):

| Deprecated Constant | Platform |
|--------------------|----------|
| `os_uwp` | Universal Windows Platform |
| `os_psvita` | PlayStation Vita |
| `os_ps3` | PlayStation 3 |
| `os_win8native` | Windows 8 Native |
| `os_winphone` | Windows Phone |
| `os_xboxone` | Xbox One (legacy) |

These still compile but should not be used in new code — the platforms are no
longer supported by GameMaker.

---

## Summary: What the LLM Probably Gets Wrong

| Topic | Risk | Detail |
|-------|------|--------|
| Script function inheritance | CRITICAL | Agent will suggest old pattern without `self.` — causes silent logic bugs in 2024.13 |
| `noone` checks with `is_number()` | HIGH | `is_number(noone)` returns false now; always use `== noone` |
| Asset ID functions returning handles | HIGH | Functions that "return a sprite index" now return refs |
| FlexPanel API | HIGH | Entirely new post-cutoff feature; model has no knowledge |
| UI Layers API | HIGH | New in 2024.13; model has no knowledge |
| `os_*` deprecated constants | LOW | Compile warning only |
