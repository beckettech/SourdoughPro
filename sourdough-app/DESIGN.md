# SourdoughPro — Design System Spec

> The single source of truth for visual decisions. Read alongside `PRODUCT.md`.
> When changing UI, update tokens here first, then in `Core/DesignSystem/`.

---

## Palette

Brand palette is **warm amber gold**, like a perfectly baked crust on cream. Hex is
canonical in code today; oklch values are noted alongside for migration when we move
off the `Color(hex:)` extension.

### Brand
| Token | Hex | oklch (target) | Role |
|---|---|---|---|
| `primary` | `#C8860A` | `oklch(64% 0.143 71)` | Brand amber. Buttons, highlights, focus rings. |
| `primaryLight` | `#D49914` | `oklch(70% 0.140 73)` | Hover state. |
| `primaryDark` | `#8A5C06` | `oklch(46% 0.130 64)` | Pressed state. |
| `accent` | `#E6B422` | `oklch(78% 0.150 87)` | Bright gold for emphasis (badges, peak states). |

### Surface (adaptive)
| Token | Light | Dark | Role |
|---|---|---|---|
| `background` | `#FFFEF5` | `#1A1600` | Outermost canvas. |
| `surface` | `#FFFFFF` | `#261E00` | Default card/sheet. |
| `surfaceElevated` | `#FFFDF0` | `#302800` | Elevated card on `surface`. |

### Semantic
| Token | Light | Dark | Role |
|---|---|---|---|
| `success` | `#228B22` | — | Ready-to-bake, good health, completed. |
| `warning` | `#E07B2F` | — | Past peak, attention needed. Distinct from primary. |
| `error` | `#C0392B` | — | Validation, destructive confirm. |
| `info` | `#1976D2` | — | Neutral status, "ready soon" banner. |

### Text (adaptive)
| Token | Light | Dark | Role |
|---|---|---|---|
| `textPrimary` | `#2C2000` | `#FFF3D0` | Body, headings. |
| `textSecondary` | `#8B7040` | `#C4A55A` | Meta, supporting copy. |
| `textTertiary` | `#A89060` | `#8B7040` | Placeholders, lowest emphasis. |
| `textInverted` | `#FFFFFF` | `#FFFFFF` | On amber primary. |

### Border (adaptive)
| Token | Light | Dark | Role |
|---|---|---|---|
| `border` | `#E8D5A0` | `#3D3000` | Default card/input border. |
| `borderLight` | `#F2EAC8` | `#2D2400` | Subtle dividers. |
| `borderDark` | `#C4A840` | `#5D4A00` | Selected / focus border. |

### Forbidden
- `#000` and `#FFF` in foreground/background. We have `textPrimary` and `surface`.
- Any pink/purple, full stop. The brand is amber.
- Gradient backgrounds on cards. (Gradient is allowed only on the launch screen and the AppIcon.)

---

## Typography

Apple system font (San Francisco) at all sizes. We don't ship a custom typeface in v1;
SF Pro Rounded would be the future direction if we re-evaluate.

**Fixed scale, no fluid sizing.**

| Token | Size / Line / Weight | Use |
|---|---|---|
| `displayLarge` | 34 / 41 / Bold | Single-screen heroes (Welcome). |
| `headingLarge` | 28 / 34 / Bold | Screen titles. |
| `headingMedium` | 22 / 28 / Semibold | Card titles, section heads. |
| `headingSmall` | 18 / 24 / Semibold | Subheads. |
| `bodyLarge` | 17 / 24 / Regular | Lead paragraphs. |
| `bodyMedium` | 15 / 22 / Regular | Default body. |
| `bodySmall` | 13 / 18 / Regular | Meta, captions in cards. |
| `labelLarge` | 16 / 22 / Semibold | Primary button labels. |
| `labelMedium` | 14 / 20 / Semibold | Default button / chip labels. |
| `labelSmall` | 12 / 16 / Semibold | Tertiary button labels. |
| `caption` | 11 / 14 / Regular | Tiny meta — feeding count, time-ago. |

Tracking: rely on system. No tightening. No loosening except `caption` which can use
`+0.4` letter-spacing if used as an eyebrow.

**Forbidden:** all-caps body text. Caps allowed only for `caption` used as a category eyebrow above a heading, and only sparingly.

---

## Spacing scale

4pt-aligned. Reference these via `SDSpace.*`. Anything between two steps must be
justified in PR description.

```
s0:  0     (no space)
s1:  2     (icon-to-text inside compact chips)
s2:  4     (tight related elements)
s3:  8     (default gap between sibling rows)
s4:  12    (label-to-input)
s5:  16    (default card inner padding)
s6:  20    (between sections within a card)
s7:  24    (between cards)
s8:  32    (between major sections of a screen)
s9:  40    (top-of-screen breathing room)
s10: 56    (hero spacing)
s11: 80    (full-bleed empty state)
```

`screenMargin` is a special token = 20pt. Always use it for the outer left/right gutter.

---

## Radius scale

```
none: 0
sm:   6     (chips, small badges)
md:   10    (text fields, small buttons)
lg:   14    (default card, default button)
xl:   20    (sheets, hero cards)
full: 999   (pills, avatars, FAB)
```

**Forbidden:** mixing 8 / 12 / 16 across a screen. Pick from the scale.

---

## Elevation

Three tiers. We use SwiftUI shadows.

| Token | Use | Spec |
|---|---|---|
| `card` | Default cards on background. | y=2, blur=8, color=black 6% |
| `raised` | Selected card, focused input. | y=4, blur=14, color=black 10% |
| `floating` | Sheets, popovers, FAB. | y=8, blur=24, color=black 14% |

**Forbidden:** drop-shadow on every container. Most surfaces should be flat against
`background`; shadow earns its keep.

---

## Components — current inventory

Located in `SourdoughPro/Core/Components/`.

| Component | Variants | Status |
|---|---|---|
| `SDButton` | primary, secondary, tertiary, destructive, icon | ✅ system-aligned |
| `SDCard` | default, elevated, interactive | ✅ |
| `SDTextField` | default, focused, error | ✅ |
| `SDProgressBar` | linear, health-score (color shifts with value) | ✅ |
| `SDChip` | filter, status, count | ✅ |
| `SDListItem` | one-line, two-line, with-trailing | ✅ |
| `SDAvatar` | xs (24), sm (32), md (44), lg (64) | ✅ |
| `SDBadge` | dot, count, status | ✅ |
| `SDToast` | success, warning, error | ✅ |
| `SDSegmentedControl` | 2-up, 3-up | ✅ |
| `SDShutterButton` | rest, capturing | ✅ |
| `SDTag` | default, removable | ✅ |
| `SDSectionHeader` | with eyebrow, with action | ✅ |
| `SDRadioOption` | single, in-group | ✅ |

States (apply to interactive components):
`rest → hover → pressed → disabled → focus → loading`. Loading state is required for
any button that does async work — never show a button without a loader.

---

## Motion

Three duration tokens, one easing function. Use sparingly.

```
fast:  120ms     (button press feedback, color cross-fade)
base:  200ms     (sheet present/dismiss, card insert, navigation)
slow:  320ms     (toast slide, hero reveals)
```

Easing: `.easeInOut` (default SwiftUI). Spring (`response: 0.4, dampingFraction: 0.8`)
for sheets only.

**What animates:**
- State changes (button pressed → loading → success).
- Entry/exit of new content (sheets, toasts, list-item insert).
- Progress (timer countdown).
- Reveal of AI analysis (brand surface — allowed to be expressive).

**What doesn't animate:**
- List items on scroll.
- Tab changes.
- Content already on screen.

---

## Do / Don't

### Do
1. Pull from tokens (`SDColor.primary`, `SDFont.bodyMedium`, `SDSpace.s4`).
2. Use `screenMargin` (20pt) for left/right gutter on every screen.
3. Pick one focal element per screen and let everything else recede.
4. Show a loading skeleton or count, not just a spinner.
5. Write empty states as first-class screens with copy + one action.
6. Hit WCAG AA on all text — 4.5:1 minimum body, 3:1 large.
7. Test in dark mode on every screen before committing.
8. Use SF Symbols via the `SDIcon` namespace, never `Image(systemName:)` inline.
9. Animate state changes; don't decorate with motion.
10. Use the warning color (`#E07B2F`) for "past peak" and similar — distinct from primary.

### Don't
1. **Purple gradients.** The brand is amber. Period.
2. **Cards inside cards.** One container layer. If you need grouping inside a card, use whitespace and `SDSectionHeader`.
3. **Gradient text on headings.** Solid color.
4. **Inline hex colors** in views. Add to `Color+Tokens.swift` first.
5. **Mixed border-radius** on a screen. Pick from the scale.
6. **Drop-shadow on every container.** Three tiers, used sparingly.
7. **All-caps body labels.** Reserve for `caption` eyebrows.
8. **Center-aligned forms.** Labels and fields are left-aligned.
9. **Placeholder-as-label.** Always provide a persistent label.
10. **Emoji as icons.** Use SF Symbols.

---

## Implementation map

| Concept | File |
|---|---|
| Color tokens | `SourdoughPro/Core/DesignSystem/Color+Tokens.swift` |
| Type tokens | `SourdoughPro/Core/DesignSystem/Font+Tokens.swift` |
| Spacing tokens | `SourdoughPro/Core/DesignSystem/Spacing.swift` |
| Radius tokens | `SourdoughPro/Core/DesignSystem/Radius.swift` |
| Shadow tokens | `SourdoughPro/Core/DesignSystem/Shadow+Tokens.swift` |
| Icon namespace | `SourdoughPro/Core/DesignSystem/Icons.swift` |
| Components | `SourdoughPro/Core/Components/SD*.swift` |

When this DESIGN.md and the code disagree, **the code is wrong, not the doc.**
Fix the code first, in a focused PR.

---

## Migration intent (post-v1)

- Move colors from `Color(hex:)` to `Color(.sRGB, ...)` with `oklch`-derived values
  for perceptual uniformity, especially in dark mode.
- Audit elevation — likely too much shadow on cards today; tighten the `card` tier.
- Adopt SF Pro Rounded for `display*` and `heading*` to soften the bakery feel.
- Add a 7-day sparkline (Swift Charts) to `StarterDetailView` health card.
