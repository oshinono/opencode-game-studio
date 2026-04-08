# GameMaker Studio — GML Language Quick Reference

Last verified: 2026-04-08 | Engine: 2024.13

## Variable Scope

| Scope | Keyword | Lifetime | Notes |
|-------|---------|---------|-------|
| Local | `var` | End of event/function | Always use for temporaries |
| Instance | (none) | Instance lifetime | Declare in Create Event |
| Global | `global.` | Game lifetime | Use sparingly; document every global |
| Static | `static` | Per-function | Persists across calls, shared by all callers |

```gml
// ✅ Always initialize in Create Event
hp      = 100;
speed_x = 0;
state   = STATE.IDLE;

// ❌ Never use bare undeclared variables — runtime error
if (hp <= 0) { die(); }  // ERROR if hp not declared in Create
```

## Structs & Constructors (GML 2.3+)

```gml
// Constructor function
function Vec2(_x, _y) constructor {
    x = _x;
    y = _y;

    static length = function() {
        return sqrt(x*x + y*y);
    };
}

var pos = new Vec2(10, 20);
pos.length();  // 22.36...

// Struct literal (no constructor needed)
var config = {
    speed: 5,
    jump_force: 12,
    gravity: 0.4,
};
```

## Functions vs Methods

| Type | Declaration | `self` Resolution | Use For |
|------|------------|------------------|---------|
| Script function | `function foo() {}` | **Static** (2024.13+) | Standalone utility scripts |
| Method variable | `foo = function() {}` | **Dynamic** (always) | Instance-bound behavior, inheritance |

**Critical 2024.13 rule**: If a script function calls another function that
child objects override, use `self.child_func()` or convert to a method:

```gml
// Parent object — script function with self. prefix
function update() {
    self.move();    // ← picks up child's override
    self.animate();
}

// Parent object — method variable (simpler, always works)
update = function() {
    move();         // methods use dynamic dispatch
    animate();
};
```

## State Machines (Preferred Pattern)

```gml
// Create Event
enum STATE { IDLE, WALK, JUMP, ATTACK, DEAD }
state = STATE.IDLE;

// Step Event
switch (state) {
    case STATE.IDLE:   self.state_idle();   break;
    case STATE.WALK:   self.state_walk();   break;
    case STATE.JUMP:   self.state_jump();   break;
    case STATE.ATTACK: self.state_attack(); break;
    case STATE.DEAD:   self.state_dead();   break;
}

// State functions handle their own transitions:
function state_idle() {
    if (keyboard_check(vk_right)) {
        state = STATE.WALK;
    }
}
```

## Data Structures — When to Use What

| Structure | Use When | Destroy Required |
|-----------|---------|-----------------|
| `array []` | Fixed-size lists, iteration | No (GC) |
| `struct {}` | Named grouped data | No (GC) |
| `ds_list` | Dynamic ordered list, needs legacy API | `ds_list_destroy()` |
| `ds_map` | Legacy JSON-like keyed data | `ds_destroy()` |
| `ds_grid` | 2D tile-based grids | `ds_grid_destroy()` |

**Always** call `ds_destroy()` on ds structures. They are NOT garbage collected.
Structs and arrays ARE garbage collected.

## Input Abstraction Pattern

```gml
// input_system.gml — centralize all input reads
function input_get_move_x() {
    return keyboard_check(vk_right) - keyboard_check(vk_left);
}

function input_check_jump() {
    return keyboard_check_pressed(vk_space) ||
           gamepad_button_check_pressed(0, gp_face1);
}

// Object Step Event — reads abstracted input, not raw keys
var dx = input_get_move_x() * move_speed;
if (input_check_jump() && on_ground) { vy = -jump_force; }
```

## Script Naming Conventions

GML has no namespaces — prefix all scripts with a category:

```
combat_calculate_damage()
combat_apply_knockback()
ui_open_pause_menu()
ui_close_all_menus()
audio_play_sfx(snd, vol)
save_write_slot(slot_id)
```
