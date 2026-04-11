<p align="center">
  <img src="https://i.postimg.cc/5NXzYL2m/opencode-game-logo.png" width="200" alt="OpenCode Game Studios">
  <h1 align="center">OpenCode Game Studios</h1>
  <p align="center">
    Turn OpenCode into a full game development studio<br>
    54 AI agents • 37 workflow skills • 100% Free (Big Pickle)
  </p>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href=".opencode/agents"><img src="https://img.shields.io/badge/agents-54-blueviolet" alt="54 Agents"></a>
  <a href=".opencode/skills"><img src="https://img.shields.io/badge/skills-37-green" alt="37 Skills"></a>
  <a href="https://opencode.ai"><img src="https://img.shields.io/badge/powered%20by-OpenCode-orange" alt="OpenCode"></a>
  <a href="https://ko-fi.com/traft"><img src="https://img.shields.io/badge/Support-Ko--fi-ff5e5b?logo=ko-fi" alt="Ko-fi"></a>
</p>

---

## Why This Exists

Building a game solo with AI is powerful — but a single chat session has no structure. No one stops you from hardcoding magic numbers, skipping design docs, or writing spaghetti code. There's no QA pass, no design review, no one asking "does this actually fit the game's vision?"

**OpenCode Game Studios** solves this by giving your AI session the structure of a real studio. Instead of one general-purpose assistant, you get **54 specialized agents** organized into a studio hierarchy — directors who guard the vision, department leads who own their domains, and specialists who do the hands-on work.

**100% Free** — Works with OpenCode's Big Pickle model (no API costs).

---

## What's Included

| Category   | Count | Description                                                                                         |
| ---------- | ----- | --------------------------------------------------------------------------------------------------- |
| **Agents** | 54    | Specialized subagents across design, programming, art, audio, narrative, QA, and production         |
| **Skills** | 37    | Slash commands for common workflows (`/start`, `/sprint-plan`, `/code-review`, `/brainstorm`, etc.) |
| **Rules**  | 11    | Path-scoped coding standards                                                                        |

---

## Quick Start

```bash
# 1. Install OpenCode (if not already)
npm install -g opencode

# 2. Connect to provider (Big Pickle is free!)
opencode connect

# 3. Configure agents (copy to global config)
cp -r .opencode/* ~/.config/opencode/

# 4. Start your studio
opencode
```

---

## Studio Hierarchy

```
Tier 1 — Directors (Strategic)
  creative-director    technical-director    producer

Tier 2 — Department Leads
  game-designer        lead-programmer       art-director
  audio-director       narrative-director    qa-lead
  release-manager      localization-lead

Tier 3 — Specialists
  gameplay-programmer  engine-programmer     ai-programmer
  network-programmer   tools-programmer      ui-programmer
  systems-designer     level-designer        economy-designer
  technical-artist     sound-designer        writer
  world-builder        prototyper            performance-analyst
  qa-tester            accessibility-specialist
```

### Engine Specialists

- **Godot**: `godot-specialist`, `godot-gdscript-specialist`, `godot-shader-specialist`, `godot-gdextension-specialist`
- **Unity**: `unity-specialist`, `unity-dots-specialist`, `unity-shader-specialist`, `unity-addressables-specialist`, `unity-ui-specialist`
- **Unreal**: `unreal-specialist`, `ue-gas-specialist`, `ue-blueprint-specialist`, `ue-replication-specialist`, `ue-umg-specialist`
- **GameMaker**: `gamemaker-specialist`, `gamemaker-gml-specialist`, `gamemaker-performance-specialist`, `gamemaker-shader-specialist`, `gamemaker-assets-specialist`, `gamemaker-ui-specialist`, `gamemaker-networking-specialist`

---

## Usage

### Invoke Agents

```bash
# In OpenCode session:
@game-designer "Design a combat system for my platformer"
@lead-programmer "Review the multiplayer architecture"
@creative-director "What's the vision for the final level?"
```

### Use Skills

Type `/` in OpenCode to access all skills:

| Category       | Skills                                                                                            |
| -------------- | ------------------------------------------------------------------------------------------------- |
| **Reviews**    | `/design-review`, `/code-review`, `/balance-check`, `/asset-audit`, `/perf-profile`, `/tech-debt` |
| **Production** | `/sprint-plan`, `/milestone-review`, `/estimate`, `/retrospective`, `/bug-report`                 |
| **Project**    | `/start`, `/project-stage-detect`, `/reverse-document`, `/gate-check`, `/map-systems`             |
| **Release**    | `/release-checklist`, `/launch-checklist`, `/changelog`, `/patch-notes`, `/hotfix`                |
| **Creative**   | `/brainstorm`, `/playtest-report`, `/prototype`, `/onboard`, `/localize`                          |
| **Team**       | `/team-combat`, `/team-narrative`, `/team-ui`, `/team-release`, `/team-polish`                    |

---

## Collaboration Protocol

Every task follows: **Question → Options → Decision → Draft → Approval**

- Agents MUST ask "May I write this to [filepath]?" before using Write/Edit tools
- Agents MUST show drafts before requesting approval
- Multi-file changes require explicit approval for the full changeset
- **You make all final decisions** — agents provide expertise, not autonomy

---

## Configuration

### Agent Permissions

Customize what each agent can do in `opencode.json`:

```json
{
  "agent": {
    "game-designer": {
      "mode": "subagent",
      "model": "opencode/big-pickle"
    }
  }
}
```

### Model Selection

All agents default to `opencode/big-pickle` (free). You can override per-agent:

```json
{
  "agent": {
    "creative-director": {
      "model": "opencode/gpt-5.1-codex"
    }
  }
}
```
Also, edit `.opencode/agents` .md files:  
```
---
description: "..."
mode: ...
model: opencode/gpt-5.1-codex
---
```

---

## Compatibility

| Platform        | Status            |
| --------------- | ----------------- |
| **OpenCode**    | ✅ Full support   |
| **Big Pickle**  | ✅ Tested (free)  |
| **Claude Code** | ❌ Not compatible |

---

## Credits

- **OpenCode** — The amazing open-source AI coding assistant
- **Big Pickle** — Free model by [OpenCode Zen](https://opencode.ai/zen)
- Big thanks to [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) for cool idea & reference for this repo.

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## Support

- 💬 [Telegram](https://t.me/traftret) — Get help with OpenCode
- 🐛 [Issues](https://github.com/traftG/opencode-game-studio/issues) — Report bugs
- ☕ [Ko-fi](https://ko-fi.com/traft) — Support development# opencode-game-studio

