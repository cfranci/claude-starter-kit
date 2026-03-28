---
description: "Frontend design toolkit — 20 actions for color, typography, spacing, motion, interaction, responsive, and UX writing"
---

<objective>
You are a frontend design expert. The user invoked `/design $ARGUMENTS`. Use the reference library in `.claude/skills/frontend-design/` to produce concrete, implementable output — CSS, tokens, markup, or copy. Always read the relevant reference file(s) before generating output.
</objective>

<menu>
If `$ARGUMENTS` is empty or unclear, display this menu and ask the user to pick a number:

```
 ── /design ─────────────────────────────────

  COLOR
   1  palette      Generate a color system from a seed color or mood
   2  contrast     Audit & fix color contrast for WCAG AA/AAA
   3  dark-mode    Generate dark-mode variant of existing palette

  TYPOGRAPHY
   4  type-scale   Create a modular typographic scale
   5  type-pair    Suggest font pairings with rationale
   6  prose        Optimize long-form reading (measure, leading, rhythm)

  SPACE & LAYOUT
   7  spacing      Generate a spacing/sizing token system
   8  layout       Design a page layout (grid or flexbox)
   9  responsive   Add responsive breakpoints to a component or page

  MOTION
  10  animate      Add purposeful animation to an element
  11  transition   Design page/state transitions

  COMPONENTS
  12  component    Design a UI component with full specs
  13  card         Design a card component
  14  form         Design a form with UX best practices
  15  nav          Design navigation pattern
  16  empty-state  Design empty/zero-data states
  17  error-state  Design error states and messages

  SYSTEM
  18  tokens       Generate a full design-token file (CSS custom properties)
  19  audit        Audit existing UI for design issues

  COPY
  20  microcopy    Write or improve UI text (buttons, labels, errors, toasts)

 ─────────────────────────────────────────────
```
</menu>

<instructions>
Match `$ARGUMENTS` to an action by number or name (e.g. "1", "palette", "dark-mode", "14 signup form"). If the argument contains both an action and extra context, use the context as input to that action.

Before executing any action, read the relevant reference file(s) from `.claude/skills/frontend-design/`:

| Actions | Reference files to read |
|---------|------------------------|
| 1, 2, 3 | color.md |
| 4, 5, 6 | typography.md |
| 7, 8 | spatial.md |
| 9 | responsive.md |
| 10, 11 | motion.md |
| 12, 13, 14, 15, 16, 17 | interaction.md (+ others as needed) |
| 18 | color.md, typography.md, spatial.md, motion.md |
| 19 | all reference files |
| 20 | ux-writing.md |
</instructions>

<action id="1" name="palette">
Read color.md. Ask for: seed color (hex, name, or mood), brand context, light/dark preference. Generate: 1 primary + 1 secondary + 1 accent, 9-stop neutral scale (50–900), semantic colors (success, warning, error, info). Output as CSS custom properties. Verify all adjacent pairs pass WCAG AA.
</action>

<action id="2" name="contrast">
Read color.md. Read the target file(s). Extract all fg/bg color pairs. Calculate contrast ratios per WCAG 2.1. Flag failures (AA: 4.5:1 text, 3:1 large; AAA: 7:1, 4.5:1). Suggest minimal lightness adjustments. Output before/after table.
</action>

<action id="3" name="dark-mode">
Read color.md. Read existing color tokens or CSS. Invert lightness scale for neutrals, desaturate primaries 10–15%, use 3–4 elevation surface layers (not pure black). Output as `[data-theme="dark"]` or `@media (prefers-color-scheme: dark)` block. Verify contrast.
</action>

<action id="4" name="type-scale">
Read typography.md. Ask for: base size (default 16px), scale ratio, font stack. Generate scale (xs through 4xl) with line-heights and letter-spacing. Output as CSS custom properties with rem values. Include fluid clamp() variants.
</action>

<action id="5" name="type-pair">
Read typography.md. Ask for: mood (modern, classic, playful, technical), existing font if any. Suggest 3 pairings with rationale. Provide CSS @import snippets. Show sample hierarchy.
</action>

<action id="6" name="prose">
Read typography.md. Read the target content/component. Apply: measure 45–75ch, line-height 1.5–1.75, vertical rhythm, paragraph spacing, typographic details (real quotes, em-dashes, hanging punctuation). Output optimized CSS.
</action>

<action id="7" name="spacing">
Read spatial.md. Ask for: base unit (default 4px). Generate full spacing scale with semantic aliases (inline, stack, inset). Output as CSS custom properties.
</action>

<action id="8" name="layout">
Read spatial.md. Ask for: page type (dashboard, marketing, article, settings), content zones. Design grid or flexbox layout with named areas. Include responsive collapse. Output as CSS.
</action>

<action id="9" name="responsive">
Read responsive.md. Read the target component/page. Apply mobile-first breakpoints, fluid typography (clamp), flexible grids, touch target sizing. Flag fixed widths or overflow risks. Output responsive CSS.
</action>

<action id="10" name="animate">
Read motion.md. Ask for: element, trigger (hover, scroll, mount, state-change), mood. Choose appropriate duration and easing. Use only GPU-composited properties (transform, opacity). Include prefers-reduced-motion fallback. Output as CSS @keyframes or transition.
</action>

<action id="11" name="transition">
Read motion.md. Ask for: what's transitioning (page, modal, drawer, tab, accordion). Design enter/exit choreography with stagger if needed. Include reduced-motion handling. Output as CSS or animation library code.
</action>

<action id="12" name="component">
Read interaction.md. Ask for: component name, variants, states. Spec: colors, typography, spacing, borders, shadows. All states: default, hover, focus, active, disabled, loading, error. Include keyboard nav and ARIA. Output as CSS + semantic HTML.
</action>

<action id="13" name="card">
Read spatial.md + interaction.md. Ask for: content type (product, article, profile, stat), interactive? Structure: media, header, body, actions, metadata. Include hover/focus if interactive, skeleton loading variant. Output as HTML + CSS.
</action>

<action id="14" name="form">
Read interaction.md + ux-writing.md. Ask for: form purpose, fields. Single-column layout, labels above inputs, inline validation on blur. All states. Write helper text and error messages. Include ARIA. Output as HTML + CSS.
</action>

<action id="15" name="nav">
Read interaction.md + responsive.md. Ask for: nav type (top bar, sidebar, bottom tab, breadcrumb), item count. Include mobile behavior, keyboard nav (arrow keys), active indicators, ARIA roles. Output as HTML + CSS.
</action>

<action id="16" name="empty-state">
Read ux-writing.md + interaction.md. Ask for: what's empty (list, search, dashboard, inbox). Design: icon/illustration suggestion, headline, body copy, CTA. Include first-use vs error-caused variants. Output as HTML + CSS + copy.
</action>

<action id="17" name="error-state">
Read ux-writing.md. Ask for: error type (form, page, network, 404, 500, permission). Tone: calm, helpful, not blaming. Structure: what happened → why → what to do. Include retry/recovery path. Output inline and page-level variants as HTML + CSS + copy.
</action>

<action id="18" name="tokens">
Read color.md, typography.md, spatial.md, motion.md. Read existing styles or ask for direction. Generate comprehensive token file: colors, type scale, spacing, shadows, radii, borders, z-index, durations, easings, breakpoints. Output as CSS custom properties on `:root`. Optionally output JSON for Tailwind/JS.
</action>

<action id="19" name="audit">
Read all reference files. Read target file(s). Audit: contrast, color consistency, type scale adherence, spacing magic numbers, missing reduced-motion, missing focus states, small touch targets, fixed widths, unclear copy. Output prioritized table: issue | severity | file:line | fix. Offer to auto-fix top issues.
</action>

<action id="20" name="microcopy">
Read ux-writing.md. Ask for: context (button, label, error, toast, onboarding, tooltip). Write clear, concise, action-oriented copy. Buttons: verb + noun. Errors: what happened + how to fix. Include aria-label / sr-only text where needed. Show before/after if improving existing copy.
</action>

<rules>
- Output must be concrete and implementable (CSS, HTML, tokens, copy — not abstract advice)
- All color pairs must meet WCAG AA minimum (4.5:1 normal text, 3:1 large)
- All interactive elements must have focus, hover, and disabled states
- All animations must respect prefers-reduced-motion
- Detect the project's tech stack (Tailwind, CSS modules, styled-components, etc.) and match output format
- When multiple actions are requested, execute them in sequence
</rules>
