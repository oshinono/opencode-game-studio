# GameMaker Studio — Deprecated APIs

Last verified: 2026-04-08

If an agent suggests any API in the "Deprecated / Old" column, it MUST be
replaced with the "Use Instead" column.

## GML Language Patterns

| Deprecated / Old Pattern | Use Instead | Since | Notes |
|--------------------------|------------|-------|-------|
| `function foo() {}` calling overridden child `bar()` without `self.` | `self.bar()` or use method syntax `foo = function() {}` | 2024.13 | Compiler now resolves script functions statically — child overrides are bypassed |
| `is_number(inst) && inst == noone` | `inst == noone` | 2024.11 | `noone` is now a typed handle ref in most contexts; `is_number()` returns false |
| `is_number(spr_ref)` to validate sprite return | `sprite_exists(spr_ref)` or direct use | 2024.13 | Sprite/shader/script/layer returns are now typed refs, not numbers |
| Parallel arrays for grouped data | Structs / constructor functions | 2.3 (GML 2.3) | Use `function Foo() constructor {}` |
| `ds_map` for typed named data | Structs | 2.3 | Structs are garbage collected; `ds_map` is not |

## Constants

| Deprecated Constant | Status | Notes |
|--------------------|--------|-------|
| `os_uwp` | Deprecated (2024.11) | Platform no longer supported |
| `os_psvita` | Deprecated (2024.11) | Platform no longer supported |
| `os_ps3` | Deprecated (2024.11) | Platform no longer supported |
| `os_win8native` | Deprecated (2024.11) | Platform no longer supported |
| `os_winphone` | Deprecated (2024.11) | Platform no longer supported |
| `os_xboxone` | Deprecated (2024.11) | Legacy constant; use `os_xbox_series` for Xbox Series targets |

## Functions — Return Type Changes (2024.13)

These functions still exist but their return types changed from `Number` to
typed handle refs. Old code checking `is_number()` or doing arithmetic on the
return value will behave differently.

| Function | Old Return Type | New Return Type |
|----------|----------------|----------------|
| `object_get_sprite(obj)` | Number (sprite index) | `ref sprite N` |
| `object_get_mask(obj)` | Number (sprite index) | `ref sprite N` |
| `shader_current()` | Number (shader index) | `ref shader N` |
| `layer_get_script_begin(layer)` | Number | `ref script N` |
| `layer_get_script_end(layer)` | Number | `ref script N` |
| `layer_get_id_at_depth(depth)` (no layer at depth) | `-1` (number) | `ref layer -1` |
| `particle_get_info()` `.sprite` member | Number or `-1` | `ref sprite -1` if no sprite |
| `layer_instance_get_instance()` (no instance) | `-4` (number) | `ref instance -4` |

## Patterns (Not Just APIs)

| Deprecated Pattern | Use Instead | Why |
|--------------------|-------------|-----|
| `ds_map` for configurations | `json_parse()` into struct | Structs are GC'd, maps require manual `ds_destroy()` |
| Raw global variables for game state | Persistent controller object | Easier to serialize/debug, avoids global namespace pollution |
| `draw_*` in Step Event | `draw_*` in Draw Event | Nothing renders from Step; silent failure |
| Creating surfaces without `surface_exists()` check | Always check before drawing | Surfaces lost on focus change (mobile/web) |
| `instance_find()` every Step frame | Cache reference in Create Event | O(n) scan per frame; performance kill at scale |
| Undeclared variables (implicit creation) | Declare all vars in Create Event | Causes runtime "undefined variable" errors |
| Magic numbers for states | `enum STATE { IDLE, WALK, … }` | Readability and refactoring safety |
| String-keyed `ds_map` | Struct literal `{ key: value }` | GML 2.3+: structs are faster and type-safe |
