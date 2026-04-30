# SourdoughPro — Product Brief

> Shared design memory. Read before doing any UI work. See also `DESIGN.md`.

---

## Audience

**Primary:** home sourdough bakers, mostly intermediate. They've kept a starter alive
for at least a few weeks and now want to track it, follow recipes, and improve their
loaves. Skews 28–55, slightly more women than men, in the kitchen, sometimes hands-on
floury, often cooking for family.

**Reading context:**
- Phone in one hand, dough on the counter or in a banneton, possibly a kitchen timer
  going. They will not read paragraphs of body copy.
- Reading speed: scanning, not reading. Hierarchy must do the work.
- Lighting: kitchen daylight or evening. Dark mode matters.
- Glance frequency: many short check-ins (90 seconds), few long sessions (4 hours of
  baking on a Saturday).

**Secondary:** beginners on day 1 of starting a starter. They will be intimidated by
jargon. The first three screens have to feel forgiving.

---

## Brand voice

Three adjectives:
1. **Warm.** Like the bakery counter, not the SaaS dashboard.
2. **Rigorous.** We respect bakers' actual skill — we're a tool, not a coach.
3. **Unfussy.** No gradients, no "✨ AI ✨" decoration, no flourishes. The food is the flourish.

Tone in copy:
- Imperative and direct in instructions ("Feed the starter 4 hours before mixing").
- Plain in error states ("That doesn't look right — paste a number").
- Specific in praise ("Great rise. The crumb is open through the middle.")
- Never cute. No "Your dough is so cute! 🥖" — bakers aren't five.

---

## Register

**Default: product.** The home screen, starter list, recipe library, bake timer, all
profile/settings — these are working surfaces. Reserved animation, hierarchy-driven,
one focal element per screen.

**Brand surfaces** (allowed to be expressive):
- WelcomeView (first impression — can show off the palette)
- PaywallView (selling)
- AICameraView shutter moment + analysis reveal (delight on a result)
- StarterReadinessBanner when state is `readyNow` (a small celebration)

Anywhere else, default to product register.

---

## Anti-references — apps we do NOT want to look like

- **Generic recipe apps with masonry photo grids and pink-purple gradients.** Yummly,
  Tasty's discovery surface. We are not a content app, we are a tool.
- **The "modern SaaS" hero.** Big bold headline, two-button row, gradient background,
  device mockup. We are an iPhone app, not a B2B landing page.
- **Cooking apps that try to be Instagram.** Round profile pics, like buttons,
  share-to-stories. Sourdough is a craft, not a feed.
- **Crypto-style neon dark mode.** Saturated accents on near-black. Ours is muted,
  warm, like dim kitchen light at night.

---

## References — apps we admire

- **Strava activity detail.** Dense data, calm layout, a single hero metric, charts
  that earn their pixels.
- **iA Writer.** One thing on screen at a time. Typography does the work.
- **Apple Weather.** Color from the data, not from decoration.
- **Procreate's tool palettes.** Deep but never cluttered; tools surface only when needed.

---

## Vocabulary — terms we use vs. terms we don't

| Use | Don't use |
|---|---|
| starter | levain (too restrictive), mother (sentimental) |
| feed | refresh (correct but jargon) |
| bulk ferment | first rise (loses precision) |
| cold proof | retard (technically correct but unfortunate) |
| crumb | inside (loses craft) |
| score | slash (informal) |
| ear | crust ridge (clunky) |
| hydration | wetness (childish) |

---

## Decisions still open

- **Light vs. dark first.** Most bakers shoot photos in daylight, so light is primary.
  But evening/morning checks are common in dark. Both must look intentional, neither
  is "the inverted version of the other."
- **Whether to ship a Watch app.** Out of scope for v1, but the home screen layout
  should anticipate it (one critical glanceable metric).
- **iPad layout.** Phone-first. iPad is a v2 question.
