# Claude Starter Kit

Get more out of Claude Code. 18 commands, 12 thinking frameworks, a design toolkit, and fun spinner verbs — one install.

## Install

```bash
git clone https://github.com/cfranci/claude-starter-kit.git
cd claude-starter-kit
./install.sh
```

Restart Claude Code, then run `/setup` to pick your trust level and preferences.

## What's included

### Commands

| Command | What it does |
|---------|-------------|
| `/autopilot` | Full autonomy — Claude stops asking questions and just executes |
| `/open` | Smart project opener — browse sessions, open by name/path/URL |
| `/label` | Color-coded session labels with prompt border colors |
| `/push` | Smart git commit + push |
| `/wait` | Queue a prompt to run later (when usage resets, or at a specific time) |
| `/whats-next` | Create a handoff doc so you can pick up in a new session |
| `/and` | Add context mid-task without breaking flow |
| `/design` | 20-action design toolkit — audit, polish, animate, and more |
| `/debug` | Expert debugging methodology with hypothesis testing |
| `/vibes` | Fun spinner verbs (50 custom verbs replace "Thinking...") |
| `/ram` | Check RAM usage and clean up |
| `/setup` | One-time setup wizard — trust level, vibes, status line |

### Think Different

12 mental models as slash commands for when you're stuck:

| Command | Framework |
|---------|-----------|
| `/consider:first-principles` | Break down to fundamentals |
| `/consider:inversion` | What would guarantee failure? |
| `/consider:pareto` | 80/20 — what's the vital few? |
| `/consider:5-whys` | Drill to root cause |
| `/consider:second-order` | Consequences of consequences |
| `/consider:occams-razor` | Simplest explanation wins |
| `/consider:one-thing` | Single highest-leverage action |
| `/consider:via-negativa` | Improve by removing |
| `/consider:opportunity-cost` | What are you giving up? |
| `/consider:eisenhower-matrix` | Urgent vs important |
| `/consider:swot` | Strengths, weaknesses, opportunities, threats |
| `/consider:10-10-10` | How will you feel in 10 min / 10 months / 10 years? |

### Design Toolkit

`/design` gives you 20 specialized design actions powered by the [Impeccable](https://github.com/pbakaus/impeccable) design skill:

- **Review**: audit, critique
- **Fix**: normalize, polish, harden, optimize, extract
- **Refine**: typeset, arrange, clarify, colorize, distill
- **Transform**: bolder, quieter, animate, delight, overdrive
- **Adapt**: adapt, onboard, teach

### Vibes

Replace the boring "Thinking..." spinner with 50 custom verbs:

```
✻ Gaslighting the compiler...
✻ Delulu deploying...
✻ Ghosting the test suite...
```

## Updating

```bash
cd claude-starter-kit && git pull && ./install.sh
```

## License

MIT
