# Sourdough App — Figma Design Specifications

**Design System Version:** 1.0  
**Last Updated:** 2026-04-14  
**Target Device:** iPhone 14 Pro (393 × 852 pt)

---

## Design Tokens

### Colors

```
PRIMARY PALETTE
├── Primary          #8B4513   Saddle Brown (bread crust)
├── Primary Light    #A0522D   Sienna (hover state)
├── Primary Dark     #5D2E0C   Dark Brown (pressed state)
│
SECONDARY PALETTE
├── Secondary        #F5DEB3   Wheat (flour)
├── Secondary Light  #FFF8DC   Cornsilk (background accent)
├── Secondary Dark   #D2B48C   Tan (borders)
│
ACCENT PALETTE
├── Accent           #D2691E   Chocolate (crust gradient)
├── Accent Light     #E07B2F   Light Chocolate
│
BACKGROUND PALETTE
├── Background       #FFFAF0   Floral White (paper)
├── Surface          #FFFFFF   White (cards)
├── Surface Elevated #FEFCF7   Cream (elevated cards)
│
SEMANTIC PALETTE
├── Success          #228B22   Forest Green (healthy)
├── Success Light    #32CD32   Lime Green (healthy bg)
├── Success Bg       #E8F5E9   Light Green (success bg)
├── Warning          #DAA520   Goldenrod (needs attention)
├── Warning Bg       #FFF8E1   Light Yellow (warning bg)
├── Error            #8B0000   Dark Red (problem)
├── Error Bg         #FFEBEE   Light Red (error bg)
├── Info             #1976D2   Blue
├── Info Bg          #E3F2FD   Light Blue
│
TEXT PALETTE
├── Text Primary     #2C1810   Dark Brown
├── Text Secondary   #8B7355   Medium Brown
├── Text Tertiary    #A89078   Light Brown
├── Text Inverted    #FFFFFF   White
├── Text Link        #8B4513   Primary
│
BORDER PALETTE
├── Border           #E5D5C3   Light Tan
├── Border Light     #F0E8DC   Very Light Tan
├── Border Dark      #C4A77D   Medium Tan
│
OVERLAY PALETTE
├── Overlay Light    rgba(0,0,0,0.04)
├── Overlay Medium   rgba(0,0,0,0.08)
├── Overlay Dark     rgba(0,0,0,0.48)
```

### Typography

```
FONT FAMILY: SF Pro (System)

HEADINGS
├── Display Large    SF Pro Display    34pt   Bold      Line Height 41pt
├── Display Medium   SF Pro Display    28pt   Bold      Line Height 34pt
├── Display Small    SF Pro Display    24pt   Bold      Line Height 29pt
├── Heading Large    SF Pro Display    22pt   Semibold  Line Height 28pt
├── Heading Medium   SF Pro Display    20pt   Semibold  Line Height 25pt
├── Heading Small    SF Pro Display    18pt   Semibold  Line Height 23pt

BODY
├── Body Large       SF Pro Text       17pt   Regular   Line Height 24pt
├── Body Medium      SF Pro Text       16pt   Regular   Line Height 22pt
├── Body Small       SF Pro Text       15pt   Regular   Line Height 20pt

LABELS & CAPTIONS
├── Label Large      SF Pro Text       15pt   Medium    Line Height 20pt
├── Label Medium     SF Pro Text       14pt   Medium    Line Height 18pt
├── Label Small      SF Pro Text       13pt   Medium    Line Height 17pt
├── Caption Large    SF Pro Text       14pt   Regular   Line Height 18pt
├── Caption Medium   SF Pro Text       13pt   Regular   Line Height 17pt
├── Caption Small    SF Pro Text       12pt   Regular   Line Height 16pt

NUMBERS & TIMERS
├── Timer Display    SF Mono           48pt   Bold      Line Height 58pt
├── Timer Secondary  SF Mono           32pt   Medium    Line Height 38pt
├── Number Large     SF Pro Display    32pt   Bold      Line Height 38pt
├── Number Medium    SF Pro Display    24pt   Semibold  Line Height 29pt
```

### Spacing

```
BASE UNIT: 4pt

SPACING SCALE
├── Space 0    0pt
├── Space 1    4pt
├── Space 2    8pt
├── Space 3    12pt
├── Space 4    16pt
├── Space 5    20pt
├── Space 6    24pt
├── Space 7    28pt
├── Space 8    32pt
├── Space 10   40pt
├── Space 12   48pt
├── Space 16   64pt
├── Space 20   80pt
├── Space 24   96pt

SCREEN MARGINS
├── Horizontal     16pt (default)
├── Horizontal Sm  12pt (compact)
├── Horizontal Lg  24pt (relaxed)

COMPONENT PADDING
├── Card Padding        16pt
├── Card Padding Lg     20pt
├── Button Padding H    24pt
├── Button Padding V    14pt
├── Input Padding H     16pt
├── Input Padding V     12pt
```

### Border Radius

```
BORDER RADIUS SCALE
├── Radius None      0pt
├── Radius XS        4pt    (chips, tags)
├── Radius SM        8pt    (buttons small, inputs)
├── Radius MD        12pt   (buttons, cards small)
├── Radius LG        16pt   (cards, modals)
├── Radius XL        20pt   (hero cards)
├── Radius 2XL       24pt   (bottom sheets)
├── Radius Full      999pt  (pills, avatars)
```

### Shadows

```
SHADOW SCALE
├── Shadow SM
│   ├── Offset: 0 1pt 2pt
│   ├── Blur: 4pt
│   └── Color: rgba(0,0,0,0.04)
│
├── Shadow MD
│   ├── Offset: 0 2pt 8pt
│   ├── Blur: 12pt
│   └── Color: rgba(0,0,0,0.08)
│
├── Shadow LG
│   ├── Offset: 0 4pt 16pt
│   ├── Blur: 24pt
│   └── Color: rgba(0,0,0,0.12)
│
├── Shadow XL
│   ├── Offset: 0 8pt 32pt
│   ├── Blur: 48pt
│   └── Color: rgba(0,0,0,0.16)
│
├── Shadow Card
│   ├── Offset: 0 4pt 12pt
│   ├── Blur: 16pt
│   └── Color: rgba(139,69,19,0.08)
│
├── Shadow Button
│   ├── Offset: 0 2pt 4pt
│   ├── Blur: 8pt
│   └── Color: rgba(139,69,19,0.12)
```

### Icons

```
ICON LIBRARY: SF Symbols 5

ICON SIZES
├── Icon XS      16pt
├── Icon SM      20pt
├── Icon MD      24pt
├── Icon LG      32pt
├── Icon XL      40pt
├── Icon 2XL     48pt

CUSTOM ICONS NEEDED
├── bread-loaf        24pt, 32pt
├── sourdough-jar     24pt, 32pt
├── starter-bubbles   24pt
├── rise-arrow        16pt, 24pt
├── thermometer-bread 24pt
├── scale-flour       24pt
```

---

## Components

### Button

```
BUTTON VARIANTS
├── Primary
│   ├── Background: Primary #8B4513
│   ├── Text: Text Inverted #FFFFFF
│   ├── Border: None
│   ├── Radius: Radius MD 12pt
│   ├── Height: 56pt (large), 48pt (medium), 40pt (small)
│   ├── Padding: 24pt horizontal
│   ├── Font: Label Large (15pt Medium)
│   ├── Shadow: Shadow Button
│   └── States:
│       ├── Hover: Background Primary Light #A0522D
│       ├── Pressed: Background Primary Dark #5D2E0C
│       └── Disabled: Background #D2B48C, Text #FFFFFF
│
├── Secondary
│   ├── Background: Surface #FFFFFF
│   ├── Text: Primary #8B4513
│   ├── Border: 1pt Primary #8B4513
│   ├── Radius: Radius MD 12pt
│   ├── Height: 56pt (large), 48pt (medium), 40pt (small)
│   └── States:
│       ├── Hover: Background Secondary Light #FFF8DC
│       ├── Pressed: Background Secondary #F5DEB3
│       └── Disabled: Border #E5D5C3, Text #A89078
│
├── Tertiary
│   ├── Background: Transparent
│   ├── Text: Primary #8B4513
│   ├── Border: None
│   ├── Height: 44pt
│   └── States:
│       ├── Hover: Background rgba(139,69,19,0.04)
│       ├── Pressed: Background rgba(139,69,19,0.08)
│       └── Disabled: Text #A89078
│
├── Icon Button
│   ├── Size: 44pt × 44pt
│   ├── Icon: Icon MD 24pt
│   ├── Radius: Radius Full 999pt
│   └── Background: Transparent or Surface

BUTTON WITH ICON
├── Icon Position: Left (default) or Right
├── Icon-Text Gap: 8pt
├── Icon Size: 20pt (large button), 18pt (medium), 16pt (small)
```

### Card

```
CARD VARIANTS
├── Card Default
│   ├── Background: Surface #FFFFFF
│   ├── Border: None
│   ├── Radius: Radius LG 16pt
│   ├── Padding: 16pt
│   ├── Shadow: Shadow Card
│   └── Content:
│       ├── Header (optional)
│       │   ├── Height: 24pt + padding
│       │   └── Title: Heading Small 18pt Semibold
│       ├── Body
│       └── Footer (optional)
│           └── Padding Top: 12pt
│
├── Card Elevated
│   ├── Background: Surface Elevated #FEFCF7
│   ├── Shadow: Shadow LG
│   └── (same as default)
│
├── Card Interactive
│   ├── (same as default)
│   └── States:
│       ├── Hover: Shadow LG, scale 1.01
│       └── Pressed: Shadow MD, scale 0.99
│
├── Card Starter (special)
│   ├── Background: Surface #FFFFFF
│   ├── Radius: Radius LG 16pt
│   ├── Height: 160pt
│   ├── Shadow: Shadow Card
│   ├── Layout:
│       ├── Top Section: 16pt padding
│       │   ├── Name: Heading Medium 20pt Semibold
│       │   └── Status Dot: 8pt circle
│       ├── Middle Section:
│       │   ├── Health Score: Number Large 32pt Bold
│       │   └── Progress Bar: 120pt × 8pt
│       └── Bottom Section: 16pt padding
│           └── Last Fed: Caption Medium 13pt
```

### Input

```
TEXT INPUT
├── Height: 56pt
├── Background: Surface #FFFFFF
├── Border: 1pt Border #E5D5C3
├── Radius: Radius SM 8pt
├── Padding: 16pt horizontal, 12pt vertical
├── Font: Body Large 17pt Regular
├── Placeholder Color: Text Tertiary #A89078
├── Label:
│   ├── Position: Top, 4pt gap
│   ├── Font: Label Medium 14pt Medium
│   └── Color: Text Secondary #8B7355
├── States:
│   ├── Default: Border #E5D5C3
│   ├── Focused: Border Primary #8B4513, 2pt
│   ├── Filled: Border #E5D5C3
│   ├── Error: Border Error #8B0000
│   └── Disabled: Background #F5F5F5, Text #A89078
│
├── Helper Text:
│   ├── Position: Bottom, 4pt gap
│   ├── Font: Caption Medium 13pt Regular
│   └── Color: Text Secondary #8B7355
│
├── Error Text:
│   ├── Same as helper
│   └── Color: Error #8B0000

SELECT INPUT
├── (same as text input)
├── Right Icon: chevron.down (16pt, Text Secondary)
├── Value Color: Text Primary
└── Placeholder Color: Text Tertiary

TEXTAREA
├── Min Height: 100pt
├── Max Height: 200pt
└── (same styling as text input)
```

### Progress Bar

```
PROGRESS BAR
├── Height: 8pt (default), 12pt (large), 4pt (small)
├── Radius: Radius Full 999pt
├── Track:
│   ├── Background: Secondary Dark #D2B48C
│   └── Height: 100%
├── Fill:
│   ├── Background: Primary #8B4513
│   └── Radius: same as track
├── Animation: 300ms ease-out
│
├── Health Score Variant:
│   ├── Track: Secondary Dark #D2B48C
│   └── Fill Colors by Score:
│       ├── 0-3: Error #8B0000
│       ├── 4-6: Warning #DAA520
│       └── 7-10: Success #228B22
│
├── With Label:
│   ├── Label above, 4pt gap
│   └── Percentage/Score right-aligned
```

### Chip / Tag

```
CHIP
├── Height: 32pt
├── Padding: 12pt horizontal
├── Radius: Radius Full 999pt
├── Font: Label Small 13pt Medium
├── Variants:
│   ├── Default
│   │   ├── Background: Secondary #F5DEB3
│   │   └── Text: Text Primary #2C1810
│   ├── Selected
│   │   ├── Background: Primary #8B4513
│   │   └── Text: Text Inverted #FFFFFF
│   └── Status
│       ├── Success: Background Success Bg, Text Success
│       ├── Warning: Background Warning Bg, Text Warning
│       └── Error: Background Error Bg, Text Error

TAG (Read-only)
├── Height: 28pt
├── Padding: 8pt horizontal
├── Radius: Radius XS 4pt
├── Background: Secondary Light #FFF8DC
└── Font: Caption Medium 13pt Regular
```

### List Item

```
LIST ITEM
├── Height: 56pt (single line), 72pt (two lines), 88pt (three lines)
├── Padding: 16pt horizontal
├── Background: Surface #FFFFFF
├── Divider: 1pt Border Light, full width, inset 16pt left
├── Layout:
│   ├── Leading (optional)
│   │   ├── Icon: 24pt, 16pt right margin
│   │   ├── Avatar: 40pt, 12pt right margin
│   │   └── Thumbnail: 56pt, 12pt right margin
│   ├── Content
│   │   ├── Title: Body Large 17pt Regular
│   │   ├── Subtitle (optional): Caption Medium 13pt, Text Secondary
│   │   └── Vertical: 4pt gap between lines
│   └── Trailing (optional)
│       ├── Value: Body Medium 16pt, Text Secondary
│       ├── Icon: 20pt, Text Secondary
│       └── Badge/Chip
│
├── States:
│   ├── Default: Background Surface
│   └── Pressed: Background Overlay Light
```

### Avatar

```
AVATAR
├── Sizes:
│   ├── XS: 24pt
│   ├── SM: 32pt
│   ├── MD: 40pt
│   ├── LG: 56pt
│   └── XL: 80pt
├── Radius: Radius Full 999pt
├── Border: None (default) or 2pt white (stacked)
├── Placeholder:
│   ├── Background: Secondary Dark #D2B48C
│   └── Initials: Heading Small 18pt, Text Inverted
└── Status Indicator:
    ├── Size: 12pt (SM avatar), 16pt (LG avatar)
    ├── Position: Bottom right, overlapping
    └── Colors: Success (online), Text Tertiary (offline)
```

### Badge

```
BADGE
├── Min Width: 20pt
├── Height: 20pt
├── Padding: 6pt horizontal (when number)
├── Radius: Radius Full 999pt
├── Background: Error #8B0000
├── Text: Caption Small 12pt Bold, Text Inverted
└── Position: Top right of parent element, overlapping
```

### Toast / Snackbar

```
TOAST
├── Width: Full width - 32pt margins
├── Min Height: 48pt
├── Padding: 16pt
├── Radius: Radius MD 12pt
├── Background: Text Primary #2C1810
├── Text: Body Medium 16pt, Text Inverted
├── Position: Bottom of screen, 16pt from bottom + safe area
├── Shadow: Shadow LG
├── Duration: 4000ms (auto-dismiss)
├── Animation: Slide up from bottom, 300ms
└── Variants:
    ├── Default: Background Text Primary
    ├── Success: Background Success, Text Inverted
    ├── Warning: Background Warning, Text Inverted
    └── Error: Background Error, Text Inverted
```

### Modal / Bottom Sheet

```
BOTTOM SHEET
├── Width: Full width
├── Max Height: 80% of screen height
├── Background: Surface #FFFFFF
├── Radius: Radius 2XL 24pt (top corners only)
├── Shadow: Shadow XL
├── Handle:
│   ├── Width: 36pt
│   ├── Height: 5pt
│   ├── Background: Border #E5D5C3
│   ├── Radius: Radius Full
│   └── Position: Top center, 8pt from top
├── Content Padding: 16pt horizontal, 12pt vertical
├── Header (optional):
│   ├── Height: 56pt
│   ├── Title: Heading Medium 20pt Semibold, centered
│   └── Close Button: Right, Icon Button style
└── Animation: Slide up from bottom, 300ms ease-out
```

### Tab Bar

```
TAB BAR
├── Height: 49pt + safe area bottom
├── Background: Surface #FFFFFF
├── Border Top: 1pt Border Light #F0E8DC
├── Items: 3-5 tabs
├── Tab Item:
│   ├── Icon: 24pt
│   ├── Label: Caption Small 12pt, below icon, 4pt gap
│   ├── States:
│   │   ├── Inactive: Icon & Label Text Secondary
│   │   └── Active: Icon & Label Primary #8B4513
│   └── Badge: Top right of icon, overlapping
└── Safe Area: Additional padding at bottom for home indicator
```

### Navigation Bar

```
NAVIGATION BAR (Large Title)
├── Height: 96pt (expanded), 44pt (collapsed)
├── Background: Background #FFFAF0, blur effect
├── Border Bottom: 1pt Border Light (when scrolled)
├── Large Title:
│   ├── Font: Display Large 34pt Bold
│   ├── Color: Text Primary
│   └── Position: Left aligned, 16pt from left
├── Back Button:
│   ├── Icon: chevron.left (20pt)
│   ├── Text: Previous screen title (Body Large 17pt)
│   └── Color: Primary #8B4513
└── Right Actions:
    ├── Up to 2 icon buttons
    └── 16pt spacing between buttons

NAVIGATION BAR (Standard)
├── Height: 44pt
├── Background: Background #FFFAF0
├── Title: Heading Large 22pt Semibold, centered
└── (same back button and actions)
```

---

## Screen Specifications

### Screen 1: Welcome / Splash

```
SCREEN: Welcome
Dimensions: 393 × 852 pt (iPhone 14 Pro)
Background: Background #FFFAF0

┌─────────────────────────────────────────────────────┐
│                                                     │
│                                                     │
│                 [Hero Illustration]                 │
│                                                     │
│                  280 × 280 pt                       │
│              (bread loaf, warm colors)              │
│                                                     │
│                                                     │
│                                                     │
│                "Master Sourdough"                   │
│           Display Medium 28pt Bold                  │
│               Text Primary, centered                │
│                                                     │
│                                                     │
│              "Track, bake, improve"                 │
│           Body Large 17pt Regular                   │
│              Text Secondary, centered               │
│                                                     │
│                                                     │
│                                                     │
│                                                     │
│          ┌─────────────────────────────┐            │
│          │       Get Started           │            │
│          │     Button Primary LG       │            │
│          │      361 × 56 pt            │            │
│          └─────────────────────────────┘            │
│                 16pt from bottom                    │
│                                                     │
│          ┌─────────────────────────────┐            │
│          │       I have an account     │            │
│          │     Button Tertiary         │            │
│          │      361 × 44 pt            │            │
│          └─────────────────────────────┘            │
│                 8pt below primary                   │
│                                                     │
└─────────────────────────────────────────────────────┘

SPACING:
├── Hero to Title: 32pt
├── Title to Subtitle: 8pt
├── Subtitle to Buttons: Auto (flex)
├── Button to Button: 8pt
└── Buttons to Bottom: 48pt + safe area
```

### Screen 2: Sign In

```
SCREEN: Sign In
Dimensions: 393 × 852 pt
Background: Background #FFFAF0

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Back                                             │
│  Navigation Bar 44pt                                │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│                                                     │
│                "Welcome back"                       │
│           Display Small 24pt Bold                   │
│                                                     │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │ Email                           │        │
│          │ [________________________]      │        │
│          │ Text Input 56pt                 │        │
│          └─────────────────────────────────┘        │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │ Password                        │        │
│          │ [________________________] 👁   │        │
│          │ Text Input 56pt                 │        │
│          └─────────────────────────────────┘        │
│                                                     │
│                 Forgot password?                    │
│              Label Small 13pt, right                │
│                 Text Link #8B4513                   │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │         Sign In                │        │
│          │     Button Primary LG          │        │
│          │      361 × 56 pt               │        │
│          └─────────────────────────────────┘        │
│                                                     │
│                 ───── or ─────                      │
│              Caption Medium 13pt                    │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │    Continue with Apple        │        │
│          │     Button Secondary           │        │
│          │      361 × 56 pt               │        │
│          └─────────────────────────────────┘        │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │  G  Continue with Google       │        │
│          │     Button Secondary           │        │
│          │      361 × 56 pt               │        │
│          └─────────────────────────────────┘        │
│                                                     │
│                                                     │
│           Don't have an account? Sign Up            │
│               Caption Medium, centered              │
│                                                     │
└─────────────────────────────────────────────────────┘

SPACING:
├── Title to First Input: 32pt
├── Input to Input: 16pt
├── Input to Forgot: 8pt
├── Forgot to Sign In: 24pt
├── Sign In to Divider: 24pt
├── Divider to Social: 16pt
├── Social Button to Social Button: 12pt
└── Last Social to Footer: 32pt
```

### Screen 3: Create Starter (Onboarding)

```
SCREEN: Create Starter
Dimensions: 393 × 852 pt
Background: Background #FFFAF0

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Back                               Skip          │
│  Navigation Bar 44pt                                │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│                                                     │
│           "Name Your Starter"                       │
│        Display Small 24pt Bold                      │
│                                                     │
│       "Every journey starts with your"              │
│        "first starter"                              │
│        Body Large 17pt, Text Secondary              │
│                                                     │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │ Name                            │        │
│          │ [________________________]      │        │
│          │ e.g., "Bubbles", "Bread Pitt"  │        │
│          │ Text Input 56pt                 │        │
│          └─────────────────────────────────┘        │
│                                                     │
│                                                     │
│              "Flour Type"                           │
│           Label Medium 14pt                         │
│                                                     │
│    ┌─────────────────────────────────────────┐      │
│    │  ○  Bread flour (recommended)           │      │
│    │  Radio List Item 56pt                   │      │
│    └─────────────────────────────────────────┘      │
│    ┌─────────────────────────────────────────┐      │
│    │  ○  Whole wheat                         │      │
│    │  Radio List Item 56pt                   │      │
│    └─────────────────────────────────────────┘      │
│    ┌─────────────────────────────────────────┐      │
│    │  ○  All-purpose                         │      │
│    │  Radio List Item 56pt                   │      │
│    └─────────────────────────────────────────┘      │
│    ┌─────────────────────────────────────────┐      │
│    │  ○  Rye                                 │      │
│    │  Radio List Item 56pt                   │      │
│    └─────────────────────────────────────────┘      │
│                                                     │
│                                                     │
│          ┌─────────────────────────────────┐        │
│          │       Create Starter           │        │
│          │     Button Primary LG          │        │
│          │      361 × 56 pt               │        │
│          └─────────────────────────────────┘        │
│                                                     │
└─────────────────────────────────────────────────────┘

RADIO LIST ITEM:
├── Height: 56pt
├── Padding: 16pt horizontal
├── Background: Surface #FFFFFF
├── Border: 1pt Border #E5D5C3
├── Radius: Radius SM 8pt
├── Radio Circle: 22pt, Border 2pt
├── Selected: Circle fill Primary #8B4513
├── Label: Body Large 17pt
├── Helper: Caption Medium 13pt, Text Secondary (if present)
└── Gap between items: 8pt
```

### Screen 4: Home Dashboard

```
SCREEN: Home Dashboard
Dimensions: 393 × 852 pt
Background: Background #FFFAF0
Scrollable: Yes

┌─────────────────────────────────────────────────────┐
│                                                     │
│  Good morning, Beck! ☀️                              │
│  Display Small 24pt Bold                            │
│  Left margin 16pt                                   │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  🔔 Bubbles needs feeding!                   │    │
│  │  Heading Small 18pt Semibold                │    │
│  │                                             │    │
│  │  Last fed: 18 hours ago                     │    │
│  │  Caption Medium 13pt                        │    │
│  │                                             │    │
│  │  ┌────────────┐  ┌────────────┐             │    │
│  │  │ Feed Now   │  │ Snooze 2h  │             │    │
│  │  │ Btn SM     │  │ Btn SM     │             │    │
│  │  │ Primary    │  │ Secondary  │             │    │
│  │  └────────────┘  └────────────┘             │    │
│  │                                             │    │
│  │  Card Elevated                               │    │
│  │  361 × 120 pt                               │    │
│  │  Background: Success Bg #E8F5E9             │    │
│  │  Border Left: 4pt Success #228B22           │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "YOUR STARTERS"                                    │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌──────────────┐ ┌──────────────┐ ┌───┐            │
│  │ Bubbles      │ │ Gerty        │ │ + │            │
│  │ ● 92%        │ │ ● 78%        │ │   │            │
│  │ 🟢 Healthy   │ │ 🟡 Needs     │ │Add│            │
│  │ 18h ago      │ │ 2d ago       │ │   │            │
│  │              │ │              │ │   │            │
│  │ Card Starter │ │ Card Starter │ │ + │            │
│  │ 115 × 160 pt │ │ 115 × 160 pt │ │115│            │
│  └──────────────┘ └──────────────┘ └───┘            │
│   Horizontal scroll                                 │
│                                                     │
│                                                     │
│  "QUICK ACTIONS"                                    │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                │
│  │   📷    │ │   ⏱    │ │   📖    │                │
│  │ AI Scan │ │Start    │ │  New    │                │
│  │         │ │ Bake    │ │ Recipe  │                │
│  │ 80pt sq │ │ 80pt sq │ │ 80pt sq │                │
│  └─────────┘ └─────────┘ └─────────┘                │
│   8pt gap between action cards                      │
│                                                     │
│                                                     │
│  "RECENT BAKES"                                     │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  🍞 Classic Sourdough                       │    │
│  │  Body Large 17pt                            │    │
│  │                                             │    │
│  │  2 days ago  ⭐⭐⭐⭐☆                        │    │
│  │  Caption Medium 13pt                        │    │
│  │                                             │    │
│  │  List Item 72pt                             │    │
│  │  Thumbnail: 56pt right                      │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  🥖 Seeded Rye                              │    │
│  │  Body Large 17pt                            │    │
│  │                                             │    │
│  │  5 days ago  ⭐⭐⭐⭐⭐                       │    │
│  │  Caption Medium 13pt                        │    │
│  │                                             │    │
│  │  List Item 72pt                             │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
├─────────────────────────────────────────────────────┤
│  🏠 Home   🍞 Starters   🥖 Recipes   👤 Profile    │
│  Tab Bar 49pt + safe area                           │
└─────────────────────────────────────────────────────┘

QUICK ACTION CARD:
├── Width: (Screen width - 48pt) / 3 = ~115pt
├── Height: 80pt
├── Background: Surface #FFFFFF
├── Radius: Radius LG 16pt
├── Shadow: Shadow SM
├── Layout: Icon (32pt) top, Label (Caption Medium) bottom
├── Gap: 4pt
└── Alignment: Center

STARTER CARD (Horizontal scroll):
├── Width: 115pt
├── Height: 160pt
├── Background: Surface #FFFFFF
├── Radius: Radius LG 16pt
├── Shadow: Shadow Card
├── Padding: 12pt
├── Layout:
│   ├── Top: Name (Body Medium 16pt Semibold)
│   ├── Health: Score + Progress bar
│   ├── Status: Chip ("Healthy" / "Needs Feeding")
│   └── Bottom: Last fed time (Caption Small)
└── Gap between cards: 12pt
```

### Screen 5: Starter Detail

```
SCREEN: Starter Detail
Dimensions: 393 × 852 pt
Background: Background #FFFAF0
Scrollable: Yes

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Back                                   ✏️ Edit   │
│  Navigation Bar 44pt                                │
│  Title: "Bubbles"                                   │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │                                             │    │
│  │         [Starter Photo Placeholder]         │    │
│  │                                             │    │
│  │          361 × 180 pt                       │    │
│  │          Object-fit: cover                  │    │
│  │                                             │    │
│  │                                             │    │
│  │  ┌───────────────────────────────────────┐  │    │
│  │  │  Health Score: 8.5 / 10               │  │    │
│  │  │  Number Large 32pt Bold               │  │    │
│  │  │  ════════════════░░░                  │  │    │
│  │  │  Progress Bar 280 × 12pt              │  │    │
│  │  │  Fill: Success #228B22                │  │    │
│  │  └───────────────────────────────────────┘  │    │
│  │                                             │    │
│  │  Card Default                               │    │
│  │  361 × 240 pt                               │    │
│  │  Photo: Top corners rounded                 │    │
│  │  Score overlay: Bottom of photo             │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "DETAILS"                                          │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Created      │  Jan 15, 2026               │    │
│  │  Label        │  Value                      │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Flour        │  Bread flour                │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Hydration    │  100%                       │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Age          │  89 days                    │    │
│  └─────────────────────────────────────────────┘    │
│  List Item style, no leading icon                   │
│  Background: Surface                                │
│  Height: 48pt per row                               │
│                                                     │
│                                                     │
│  "NEXT FEEDING"                                     │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  🕐 In ~4 hours (peak activity)             │    │
│  │  Heading Small 18pt                         │    │
│  │                                             │    │
│  │  Feed at 2:00 PM for best results          │    │
│  │  Caption Medium 13pt, Text Secondary        │    │
│  │                                             │    │
│  │  Card 361 × 80pt                            │    │
│  │  Background: Info Bg #E3F2FD                │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "FEEDING HISTORY"                                  │
│  Label Medium 14pt, Text Secondary                  │
│  "See all →" right aligned, Text Link               │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Today, 6:00 AM                              │    │
│  │  Caption Medium 13pt, Text Secondary         │    │
│  │                                             │    │
│  │  25g starter + 50g flour + 50g water        │    │
│  │  Body Medium 16pt                           │    │
│  │                                             │    │
│  │  Rise: 4cm  •  Bubbles: Large               │    │
│  │  Caption Medium 13pt                        │    │
│  │                                             │    │
│  │  List Item 88pt                             │    │
│  │  Leading: 40pt photo thumbnail              │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Yesterday, 6:00 PM                          │    │
│  │  25g starter + 50g flour + 50g water        │    │
│  │                                             │    │
│  │  List Item 72pt                             │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  🤖 AI Health Check                         │    │
│  │  Button Primary LG 361 × 56pt               │    │
│  │  Icon: camera.fill (20pt)                   │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Add Feeding                                │    │
│  │  Button Secondary LG 361 × 56pt             │    │
│  │  Icon: plus (20pt)                          │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
└─────────────────────────────────────────────────────┘

SPACING:
├── Photo Card to Details: 16pt
├── Details to Next Feeding: 16pt
├── Next Feeding to History: 24pt
├── History Items: 8pt gap
├── Last History to Buttons: 24pt
└── Button to Button: 12pt
```

### Screen 6: AI Vision - Camera

```
SCREEN: AI Camera
Dimensions: 393 × 852 pt
Background: Black #000000

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Cancel                                          │
│  Navigation Bar 44pt, Text White                    │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │                                             │    │
│  │                                             │    │
│  │                                             │    │
│  │         [Camera Viewfinder]                 │    │
│  │                                             │    │
│  │         Full width, ~500pt height           │    │
│  │                                             │    │
│  │                                             │    │
│  │                                             │    │
│  │     ┌─────────────────────────────┐         │    │
│  │     │                             │         │    │
│  │     │  Position starter in frame  │         │    │
│  │     │  Caption Large 14pt White   │         │    │
│  │     │                             │         │    │
│  │     └─────────────────────────────┘         │    │
│  │                                             │    │
│  │                                             │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐               │
│  │ Starter │ │  Crumb  │ │  Proof  │               │
│  │ Selected│ │         │ │         │               │
│  └─────────┘ └─────────┘ └─────────┘               │
│   Segmented Control                                │
│   Background: rgba(255,255,255,0.1)                 │
│   Selected: Surface #FFFFFF, Text Primary           │
│   Unselected: Text White                            │
│   Height: 40pt                                      │
│   Radius: Radius SM 8pt                             │
│                                                     │
│                                                     │
│                                                     │
│                 ┌───────────┐                       │
│                 │           │                       │
│                 │     📸    │                       │
│                 │           │                       │
│                 │  Shutter  │                       │
│                 │   Button  │                       │
│                 │           │                       │
│                 │  72pt dia │                       │
│                 │  White    │                       │
│                 │  border   │                       │
│                 │  4pt      │                       │
│                 └───────────┘                       │
│                                                     │
│                                                     │
│   💡 Tip: Take photo in natural light              │
│   Caption Medium 13pt, Text Tertiary               │
│                                                     │
│                                                     │
│                                                     │
│   [🔄] [⚡]  Camera controls bottom left            │
│   Flash toggle, Camera flip                        │
│   32pt icons, white                                 │
│                                                     │
└─────────────────────────────────────────────────────┘

SHUTTER BUTTON:
├── Size: 72pt diameter
├── Outer Ring: White, 4pt stroke
├── Inner Circle: White fill, 60pt diameter
├── Gap: 6pt between ring and fill
└── Action: Fill animates on press
```

### Screen 7: AI Analysis Results

```
SCREEN: Analysis Results
Dimensions: 393 × 852 pt
Background: Background #FFFAF0
Scrollable: Yes

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Back                                            │
│  Navigation Bar 44pt                                │
│  Title: "Analysis"                                  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │         [Your Starter Photo]                │    │
│  │                                             │    │
│  │          361 × 200 pt                       │    │
│  │          Object-fit: cover                  │    │
│  │                                             │    │
│  │  Card Default                               │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "HEALTH SCORE"                                     │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │              8.5                            │    │
│  │         Timer Display 48pt                  │    │
│  │              /10                            │    │
│  │         Body Large 17pt                     │    │
│  │                                             │    │
│  │         ════════════════░░                  │    │
│  │         Progress Bar 280 × 12pt             │    │
│  │         Fill: Success #228B22               │    │
│  │                                             │    │
│  │  Card 361 × 120pt                           │    │
│  │  Background: Surface                        │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  ✅ Good bubble activity                    │    │
│  │  Body Large 17pt                            │    │
│  │                                             │    │
│  │  List Item 56pt                             │    │
│  │  Leading: checkmark.circle.fill, Success    │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  ✅ Healthy rise height                     │    │
│  │  List Item 56pt                             │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  ⚠️ Slight hooch layer                      │    │
│  │  List Item 56pt                             │    │
│  │  Leading: exclamationmark.triangle, Warning │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "RECOMMENDATIONS"                                  │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  • Feed within 4-6 hours                    │    │
│  │  Body Medium 16pt                           │    │
│  │                                             │    │
│  │  • Consider a 1:3:3 ratio                   │    │
│  │                                             │    │
│  │  • Warmer spot (75-78°F)                    │    │
│  │                                             │    │
│  │  Card 361 × 140pt                           │    │
│  │  Background: Secondary Light #FFF8DC        │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  🕐 Estimated Peak: ~6 hours                │    │
│  │  Heading Small 18pt                         │    │
│  │                                             │    │
│  │  ┌─────────────────────────────────────┐    │    │
│  │  │      Set Reminder                    │    │    │
│  │  │     Button Secondary MD             │    │    │
│  │  │      280 × 48pt                     │    │    │
│  │  └─────────────────────────────────────┘    │    │
│  │                                             │    │
│  │  Card 361 × 100pt                           │    │
│  │  Background: Info Bg #E3F2FD                │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Save to History                            │    │
│  │  Button Primary LG 361 × 56pt               │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Screen 8: Recipe Detail

```
SCREEN: Recipe Detail
Dimensions: 393 × 852 pt
Background: Background #FFFAF0
Scrollable: Yes

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Back                                            │
│  Navigation Bar 44pt, transparent over hero         │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │                                             │    │
│  │         [Recipe Hero Image]                 │    │
│  │                                             │    │
│  │          393 × 280 pt                       │    │
│  │          Object-fit: cover                  │    │
│  │                                             │    │
│  │                                             │    │
│  │  ┌───────────────────────────────────────┐  │    │
│  │  │  Classic Sourdough                    │  │    │
│  │  │  Display Small 24pt Bold              │  │    │
│  │  │  Text Inverted #FFFFFF                │  │    │
│  │  │                                       │  │    │
│  │  │  ⭐⭐⭐⭐⭐ (234 reviews)               │  │    │
│  │  │  Caption Medium 13pt                  │  │    │
│  │  │  Text Inverted                        │  │    │
│  │  └───────────────────────────────────────┘  │    │
│  │                                             │    │
│  │  Gradient Overlay: bottom 120pt             │    │
│  │  rgba(0,0,0,0) to rgba(0,0,0,0.6)            │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  ⏱ 24 hrs  •  🍞 2 loaves  •  💧 75%        │    │
│  │  Body Medium 16pt, Text Secondary           │    │
│  │                                             │    │
│  │  ───────────────────────────────────────    │    │
│  │                                             │    │
│  │  Intermediate                              │    │
│  │  Chip (default style)                       │    │
│  │                                             │    │
│  │  Card 361 × 60pt                            │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "INGREDIENTS"                                      │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  500g   Bread flour                         │    │
│  │  List Item 48pt                             │    │
│  ├─────────────────────────────────────────────┤    │
│  │  375g  Water (warm)                         │    │
│  ├─────────────────────────────────────────────┤    │
│  │  100g  Active starter                       │    │
│  ├─────────────────────────────────────────────┤    │
│  │  10g   Salt                                 │    │
│  └─────────────────────────────────────────────┘    │
│  Background: Surface                                │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Start Baking →                             │    │
│  │  Button Primary LG 361 × 56pt               │    │
│  │  Sticky bottom                              │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "STEPS"                                            │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  1. Feed starter (4-8 hrs)                  │    │
│  │  List Item 56pt                             │    │
│  │  Leading: Number badge 28pt circle          │    │
│  ├─────────────────────────────────────────────┤    │
│  │  2. Mix dough (10 min)                      │    │
│  ├─────────────────────────────────────────────┤    │
│  │  3. Bulk ferment (4-6 hrs)                  │    │
│  ├─────────────────────────────────────────────┤    │
│  │  4. Shape (15 min)                          │    │
│  ├─────────────────────────────────────────────┤    │
│  │  5. Cold proof (8-12 hrs)                   │    │
│  ├─────────────────────────────────────────────┤    │
│  │  6. Bake (45 min)                           │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
└─────────────────────────────────────────────────────┘

NUMBER BADGE:
├── Size: 28pt circle
├── Background: Primary #8B4513
├── Text: Caption Small 12pt Bold, Text Inverted
└── Margin right: 12pt
```

### Screen 9: Bake Timer (Active)

```
SCREEN: Bake Timer (In Progress)
Dimensions: 393 × 852 pt
Background: Background #FFFAF0
Scrollable: Yes

┌─────────────────────────────────────────────────────┐
│                                                     │
│  ← Back                                            │
│  Navigation Bar 44pt                                │
│  Title: "Classic Sourdough"                         │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Started: Today, 8:00 AM                            │
│  Caption Medium 13pt, Text Secondary                │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  "CURRENT STEP"                                     │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │                                             │    │
│  │         Bulk Fermentation                   │    │
│  │         Heading Large 22pt Semibold         │    │
│  │                                             │    │
│  │                                             │    │
│  │              02:34:17                       │    │
│  │         Timer Display 48pt Bold             │    │
│  │         SF Mono, Primary #8B4513            │    │
│  │                                             │    │
│  │                                             │    │
│  │  ┌────────────┐  ┌────────────┐             │    │
│  │  │  ⏸ Pause   │  │ ✓ Complete │             │    │
│  │  │ Btn SM     │  │ Btn SM     │             │    │
│  │  │ Secondary  │  │ Primary    │             │    │
│  │  └────────────┘  └────────────┘             │    │
│  │                                             │    │
│  │                                             │    │
│  │  Card Elevated                               │    │
│  │  361 × 220 pt                               │    │
│  │  Background: Surface Elevated                │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "PROGRESS"                                         │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ●──●──●──○──○──○                                   │
│  Mix Bulk Shape Proof Bake                          │
│  ✓   ✓   ←                                          │
│                                                     │
│  Step Indicator:                                    │
│  ├── Completed: Primary #8B4513, filled              │
│  ├── Current: Primary, larger, pulse animation       │
│  └── Upcoming: Border #E5D5C3, empty                 │
│  Gap: 8pt between dots                              │
│  Labels: Caption Small 12pt                         │
│                                                     │
│                                                     │
│  "NEXT STEPS"                                       │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  • Shape dough (15 min)                     │    │
│  │  Caption Medium 13pt                        │    │
│  ├─────────────────────────────────────────────┤    │
│  │  • Cold proof (8-12 hrs)                    │    │
│  ├─────────────────────────────────────────────┤    │
│  │  • Bake (45 min)                            │    │
│  └─────────────────────────────────────────────┘    │
│  Card 361 × 140pt, Background: Surface              │
│                                                     │
│                                                     │
│  "NOTES"                                            │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  [Add a note...]                            │    │
│  │  Text Input 56pt                            │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  📸 [Add Photo]                                     │
│  Button Tertiary 44pt                               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Screen 10: Profile & Settings

```
SCREEN: Profile
Dimensions: 393 × 852 pt
Background: Background #FFFAF0
Scrollable: Yes

┌─────────────────────────────────────────────────────┐
│                                                     │
│  Profile                                           │
│  Large Title Navigation 96pt                        │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │                                             │    │
│  │         ┌─────────┐                         │    │
│  │         │  [ IMG  │                         │    │
│  │         │   80pt  │  Avatar XL              │    │
│  │         └─────────┘                         │    │
│  │                                             │    │
│  │              Beck                           │    │
│  │         Heading Medium 20pt                 │    │
│  │                                             │    │
│  │          beck@email.com                     │    │
│  │         Body Medium 16pt, Text Secondary    │    │
│  │                                             │    │
│  │         ┌─────────────────┐                 │    │
│  │         │ Pro Member      │                 │    │
│  │         │ Chip Selected   │                 │    │
│  │         └─────────────────┘                 │    │
│  │                                             │    │
│  │  Card 361 × 180pt                           │    │
│  │  Background: Surface Elevated                │    │
│  │  Alignment: Center                          │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "STATS"                                            │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐               │
│  │   47    │ │   12    │ │   89    │               │
│  │ Number  │ │ Number  │ │ Number  │               │
│  │ Large   │ │ Medium  │ │ Medium  │               │
│  │ 32pt    │ │ 24pt    │ │ 24pt    │               │
│  │         │ │         │ │         │               │
│  │  Bakes  │ │ Starters│ │  Days   │               │
│  │ Caption │ │ Caption │ │ Caption │               │
│  │ Medium  │ │ Medium  │ │ Medium  │               │
│  └─────────┘ └─────────┘ └─────────┘               │
│   Stats Row: 3 equal columns, centered              │
│   Background: Surface                               │
│   Height: 80pt                                      │
│   Radius: Radius LG 16pt                            │
│                                                     │
│                                                     │
│  "ACHIEVEMENTS"                                     │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  🏆 First Loaf    🥖 10 Bakes    🔥 7-Day Streak    │
│  Badge style: Caption Medium, horizontal scroll      │
│                                                     │
│                                                     │
│  "SUBSCRIPTION"                                     │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Pro Plan - $4.99/mo                        │    │
│  │  Body Large 17pt                            │    │
│  │                                             │    │
│  │  Renews Apr 15, 2026                       │    │
│  │  Caption Medium 13pt, Text Secondary        │    │
│  │                                             │    │
│  │  ┌─────────────────────────────────────┐    │    │
│  │  │    Manage Subscription               │    │    │
│  │  │   Button Tertiary                    │    │    │
│  │  └─────────────────────────────────────┘    │    │
│  │                                             │    │
│  │  Card 361 × 120pt                           │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
│  "SETTINGS"                                         │
│  Label Medium 14pt, Text Secondary                  │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Notifications                         >    │    │
│  │  List Item 56pt                             │    │
│  │  Trailing: chevron.right 20pt               │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Units (Metric/Imperial)                >    │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Theme                                  >    │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Privacy                                >    │    │
│  ├─────────────────────────────────────────────┤    │
│  │  Help & Support                         >    │    │
│  └─────────────────────────────────────────────┘    │
│  Card 361 × 280pt, Background: Surface              │
│                                                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │  Sign Out                                   │    │
│  │  Button Secondary LG 361 × 56pt             │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│                                                     │
├─────────────────────────────────────────────────────┤
│  🏠 Home   🍞 Starters   🥖 Recipes   👤 Profile    │
│  Tab Bar 49pt + safe area                           │
└─────────────────────────────────────────────────────┘
```

---

## Motion & Animation

### Transitions

```
SCREEN TRANSITIONS
├── Push/Pop: Default iOS navigation transition (slide right/left)
├── Modal: Slide up from bottom, 350ms ease-out
├── Bottom Sheet: Slide up, 300ms ease-out
├── Tab Switch: Crossfade, 200ms
└── Card Tap: Scale to 0.97, 150ms ease-in-out

MICRO-INTERACTIONS
├── Button Press: Scale to 0.97, 100ms
├── Button Release: Scale to 1.0, 100ms, spring(0.5, 0.8)
├── Switch Toggle: 250ms spring animation
├── Checkbox: 200ms fill animation
├── Progress Fill: 300ms ease-out
├── Timer Tick: Subtle pulse, 1s loop
├── Success State: Scale pulse (1.0 → 1.05 → 1.0), 400ms
├── Error Shake: Horizontal shake, 300ms
└── Loading Spinner: Continuous rotation, 1s linear loop

HOVER STATES (iOS trackpad/mouse)
├── Cards: Scale 1.01, shadow increase
├── Buttons: Background color shift, 150ms
└── List Items: Background overlay, 150ms
```

### Loading States

```
SKELETON LOADING
├── Background: Border Light #F0E8DC
├── Shimmer: Linear gradient animation
├── Duration: 1.5s loop
├── Radius: Match actual content
└── Used for: Cards, List Items, Images

LOADING INDICATORS
├── Spinner: 24pt circle, Primary #8B4513, 2pt stroke
├── Progress: Linear progress bar at top of screen
└── Full Screen: Spinner centered with "Loading..." text
```

---

## Responsive Considerations

```
DEVICE SIZES
├── iPhone SE (375 × 667): Reduce card sizes, smaller margins
├── iPhone 14 Pro (393 × 852): Default specs
├── iPhone 14 Pro Max (430 × 932): Increase card widths
├── iPad (744 × 1133): 2-column layout for cards, split view
└── iPad Pro (1024 × 1366): 3-column layout, sidebar navigation

ORIENTATION
├── Portrait: Default specs
└── Landscape:
    ├── Navigation: Sidebar instead of tab bar
    ├── Cards: Horizontal grid
    └── Timer: Larger display, landscape-optimized layout

DYNAMIC TYPE
├── Support: xSmall to Accessibility XXL
├── Minimum: 14pt body text
├── Maximum: 23pt body text
├── Scale: All text scales proportionally
└── Layout: Adjust spacing and line heights accordingly

SAFE AREAS
├── Top: Status bar + navigation (varies by device)
├── Bottom: Home indicator + tab bar (34pt typical)
├── Leading/Trailing: 16pt (varies by device)
└── Landscape: Notch/Dynamic Island considerations
```

---

## Accessibility

```
COLOR CONTRAST
├── Text on Background: Minimum 4.5:1
├── Text on Surface: Minimum 4.5:1
├── Text on Primary: Minimum 4.5:1 (white on brown)
└── Disabled Text: Minimum 3:1

TOUCH TARGETS
├── Minimum: 44pt × 44pt
├── Buttons: 56pt height (exceeds minimum)
├── List Items: 56pt minimum height
└── Icon Buttons: 44pt × 44pt touch area

VOICEOVER
├── All interactive elements: Accessible labels
├── Images: Descriptive alt text
├── Progress bars: Value announcements
├── Timers: Time announcements
└── Icons: Semantic labels (e.g., "Check mark, completed")

REDUCE MOTION
├── Disable: All spring/bounce animations
├── Replace: Crossfades for slides
└── Maintain: Essential state changes (no animation)

HAPTIC FEEDBACK
├── Selection: Light impact (tab switch, list tap)
├── Success: Medium impact (task complete)
├── Error: Heavy impact (validation fail)
└── Timer Alert: Medium impact, repeat 3x
```

---

## Export Guidelines

### Figma Setup

```
FILE STRUCTURE
├── 🎨 Design System
│   ├── Colors
│   ├── Typography
│   ├── Spacing
│   ├── Effects (shadows, blurs)
│   └── Icons
│
├── 🧩 Components
│   ├── Buttons
│   ├── Cards
│   ├── Inputs
│   ├── Navigation
│   └── ...
│
├── 📱 Screens
│   ├── 01 Onboarding
│   ├── 02 Home
│   ├── 03 Starters
│   ├── 04 Recipes
│   ├── 05 Bake Timer
│   ├── 06 AI Vision
│   └── 07 Profile
│
└── 🎭 Prototypes
    └── Interactive flows

NAMING CONVENTION
├── Screens: [Number] - [Name] (e.g., "01 - Welcome")
├── Components: [Type]/[Variant] (e.g., "Button/Primary")
├── Colors: [Category]/[Name] (e.g., "Primary/Brown")
├── Text: [Size]/[Weight] (e.g., "Heading/Large")
└── Icons: [Name] (e.g., "bread-loaf")

VARIANTS
├── Use component variants for states (default, hover, pressed, disabled)
├── Use boolean properties for optional elements
└── Use instance swaps for icons
```

### Developer Handoff

```
EXPORT SETTINGS
├── Images: PNG @1x, @2x, @3x
├── Icons: SVG (optimized)
├── Colors: Hex + RGB values
├── Text: Style name + tokens
└── Spacing: Point values

ANNOTATIONS
├── All measurements in points (pt)
├── Note any platform-specific behaviors
├── Mark prototype interaction points
└── Include edge cases and error states
```

---

*Document version: 1.0*  
*Last updated: 2026-04-14*  
*Total screens: 10*  
*Total components: 15+*