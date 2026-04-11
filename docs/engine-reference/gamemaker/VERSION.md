# GameMaker Studio — Version Reference

| Field | Value |
|-------|-------|
| **Engine Version** | GameMaker Studio 2024.13 |
| **IDE Version** | 2024.13.1 (Build 193) |
| **Runtime Version** | 2024.13.1 (Build 242) |
| **Release Date** | April 8, 2025 (.1 update: April 17, 2025) |
| **Project Pinned** | 2026-04-08 |
| **Last Docs Verified** | 2026-04-08 |
| **LLM Knowledge Cutoff** | May 2025 |

## Knowledge Gap Warning

GameMaker Studio uses a monthly versioning scheme (YYYY.MM). The LLM's training
data covers GMS2 up to approximately **2024.6** or earlier. Versions 2024.8
through **2024.13** introduced significant runtime, language, and IDE changes
the model does NOT know about. Always cross-reference this directory before
suggesting GML APIs or patterns.

## Post-Cutoff Version Timeline

| Version | Release | Risk Level | Key Theme |
|---------|---------|------------|-----------|
| 2024.8  | Aug 2024 | MEDIUM | FlexPanels (UI layout system) introduced in beta |
| 2024.11 | Nov 2024 | HIGH | FlexPanels promoted to stable; handle type system introduced |
| 2024.13 | Apr 2025 | HIGH | UI Layers, function call optimisation (inheritance change), handle system matured, Prefab Library, SVG support |

## Critical 2024.13 Highlights

1. **Function Inheritance Breaking Change** — script functions that call overridden
   child functions now require `self.` prefix or method syntax. This silently
   changes behavior and will not produce a compile error.

2. **Handle Type System** — many functions that returned plain numbers now return
   typed handle refs (e.g., `object_get_sprite()`, `shader_current()`,
   `layer_get_script_begin()`). Code checking `is_number()` on these returns
   will behave differently.

3. **UI Layers** — a new global UI layer system for persistent HUD/UI across
   rooms (all targets except HTML5 in this release).

4. **`noone` Return Type Change** — collision functions that returned `-4` as a
   number now return an instance handle `ref instance -4`. Affects `is_number()`
   / `is_handle()` checks.

## Verified Sources

- Official manual: https://manual.gamemaker.io/monthly/en/index.htm#t=Content.htm
- 2024.13 release notes: https://releases.gamemaker.io/release-notes/2024/13
- Script Functions vs Methods (inheritance): https://manual.gamemaker.io/monthly/en/#t=GameMaker_Language%2FGML_Overview%2FScript_Functions_vs_Methods.htm
- GML Language overview: https://manual.gamemaker.io/monthly/en/GameMaker_Language/GameMaker_Language_Index.htm
- Bug tracker milestone: https://github.com/YoYoGames/GameMaker-Bugs/milestone/25?closed=1
