# Claude Starter Kit

Make Claude Code actually fun to use. 30 slash commands, 12 thinking frameworks, a design toolkit, one-letter shortcuts, custom spinner verbs, and a translucent terminal profile.

## Install

```bash
git clone https://github.com/cfranci/claude-starter-kit.git
cd claude-starter-kit
./install.sh
```

Restart Claude Code. Run `/setup` to pick your trust level and configure everything.

To update later: `cd claude-starter-kit && git pull && ./install.sh`

---

## What's in the box

### `/setup` — First thing to run

Interactive setup wizard. Asks three questions:
1. **Trust level** — how much permission Claude gets (training wheels → power user → full send)
2. **Vibes** — enable 50 fun spinner verbs instead of "Thinking..."
3. **Status line** — show project name, git branch, and token count in your prompt

### Shortcuts — One-letter commands

Type less, do more.

| Command | Action |
|---------|--------|
| `/c` | **Copy** — copies the last code block or command to your clipboard |
| `/p` | **Paste** — reads your clipboard and uses it as context |
| `/y` | **Yes** — proceed with whatever was suggested |
| `/n` | **No** — reject the approach, suggest an alternative |
| `/r` | **Run** — starts the dev server (auto-detects npm/cargo/python/go) |
| `/s` | **Save** — quick git commit with auto-generated message |
| `/t` | **Test** — runs the test suite |
| `/b` | **Build** — builds the project |
| `/w` | **Status** — git status + what you're working on |
| `/f` | **Find** — search for files or code (`/f handleSubmit`) |
| `/e` | **Explain** — explains the last error or code block |
| `/x` | **Undo** — reverts the last file change or commit |

### Core Commands

| Command | What it does |
|---------|-------------|
| `/autopilot` | Claude stops asking permission and just executes. For when you know what you want and don't need hand-holding. |
| `/open` | Smart project opener. Give it a folder path, project name, or GitHub URL. Or run it empty to browse your recent sessions. |
| `/label` | Color-coded session labels. `/label My Project` assigns a color and saves it. Next time you open that project, the color comes back. |
| `/push` | Smarter `git commit && git push`. Auto-generates commit messages from your diff. |
| `/wait` | Queue a prompt to run later. `/wait 2h run tests` sleeps for 2 hours then opens a new Claude window with that prompt. `/wait` alone checks when your usage resets and schedules for then. |
| `/and` | Add context without breaking flow. `/and the API key is in .env.local` — notes it and keeps working. `/and --do check port 3000` — does a side task, then resumes. |
| `/whats-next` | Creates a handoff document so you (or a teammate) can pick up where you left off in a new session. |
| `/debug` | Switches to expert debugging mode — systematic hypothesis testing instead of "just try stuff." |
| `/ram` | Shows what's eating your RAM and offers to clean it up. |
| `/vibes` | Toggle fun spinner verbs on/off. |

### `/design` — Design Toolkit

20 design actions powered by the [Impeccable](https://github.com/pbakaus/impeccable) skill. Run `/design` to see the menu, or go direct: `/design audit homepage`, `/design polish`, `/design colorize`.

| Category | Actions |
|----------|---------|
| Review | `audit` — a11y, performance, responsive checks. `critique` — UX design review. |
| Fix | `normalize` — align with design system. `polish` — final pass. `harden` — error handling. `optimize` — performance. `extract` — pull out reusable components. |
| Refine | `typeset` — fix fonts. `arrange` — fix layout. `clarify` — improve copy. `colorize` — add color. `distill` — strip to essence. |
| Transform | `bolder` — amplify. `quieter` — tone down. `animate` — add motion. `delight` — add joy. `overdrive` — technically wild effects. |
| Other | `adapt` — responsive. `onboard` — first-time UX. `teach` — one-time design context setup. |

### `/consider:*` — Thinking Frameworks

12 mental models as slash commands. Use when you're stuck, making a decision, or want a different perspective.

| Command | What it does |
|---------|-------------|
| `/consider:first-principles` | Break it down to fundamentals, rebuild from scratch |
| `/consider:inversion` | Flip it — what would guarantee failure? |
| `/consider:pareto` | 80/20 — what's the vital few vs trivial many? |
| `/consider:5-whys` | Keep asking why until you hit root cause |
| `/consider:second-order` | What are the consequences of the consequences? |
| `/consider:occams-razor` | What's the simplest explanation? |
| `/consider:one-thing` | What's the single highest-leverage action? |
| `/consider:via-negativa` | What should you remove instead of add? |
| `/consider:opportunity-cost` | What are you giving up by choosing this? |
| `/consider:eisenhower-matrix` | Urgent vs important — where does this fall? |
| `/consider:swot` | Strengths, weaknesses, opportunities, threats |
| `/consider:10-10-10` | How will you feel about this in 10 min / 10 months / 10 years? |

---

## What gets installed where

```
~/.claude/
├── commands/           ← 30 slash commands
│   ├── autopilot.md, open.md, label.md, push.md, ...
│   ├── c.md, p.md, y.md, n.md, r.md, s.md, ...  (shortcuts)
│   ├── consider/       ← 12 thinking frameworks
│   ├── label-flows/    ← loaded only when /label needs the picker
│   └── open-flows/     ← loaded only when /open needs tiling or external repo review
├── data/
│   ├── colors.json     ← 24 named colors for /label
│   └── vibes/sfw.json  ← 50 spinner verbs
├── scripts/
│   ├── statusline.sh   ← status line (project, branch, tokens)
│   └── track-cwd.sh    ← tracks working directory for status line
└── skills/
    └── frontend-design/ ← 7 design reference docs (typography, color, spatial, etc.)

~/Library/Application Support/iTerm2/DynamicProfiles/
└── Glas.json           ← translucent terminal profile (iTerm2 only)
```

Commands in `label-flows/` and `open-flows/` are **not loaded by default** — they only get read when that specific feature is triggered, keeping token usage low.

## iTerm2 Profile

The installer includes **Glas** — a translucent terminal profile for iTerm2. It's loaded as a Dynamic Profile, so it won't overwrite your existing profiles. Switch to it in iTerm2 → Profiles → Glas.

If you don't use iTerm2, the installer skips this automatically.

## License

MIT
