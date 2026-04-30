# SourdoughPro — Project Handoff & Roadmap

> Read this first when picking up the project cold.

---

## 1 · What this is

Native iOS app, **Swift 5.9 + SwiftUI**, iOS 17 deployment target, MVVM. Hand-written
`.xcodeproj` (no xcgen/tuist). Target users: home sourdough bakers tracking starters,
following recipes, scoring bakes with AI.

**Authoritative spec docs** live one level up:
- `/Users/beck/sourdough/DEV_SPEC.md`  — architecture, models, endpoints, AI prompts
- `/Users/beck/sourdough/FIGMA_SPECS.md` — design system + per-screen pixel specs
- `/Users/beck/sourdough/FEATURES.md`  — MVP vs nice-to-have
- `/Users/beck/sourdough/ROADMAP.md`   — phased plan
- `/Users/beck/sourdough/sourdough-research.md` — competitive research + pain-point analysis

---

## 2 · Layout

```
/Users/beck/sourdough/sourdough-app/
├── SourdoughPro.xcodeproj/                # hand-written pbxproj
└── SourdoughPro/
    ├── App/                # @main, AppCoordinator, AppState, Info.plist
    ├── Core/
    │   ├── DesignSystem/   # SDColor, SDFont, SDSpace, SDRadius, SDShadow, SDIcon
    │   ├── Components/     # SDButton, SDCard, SDTextField, SDProgressBar, …
    │   ├── Network/        # APIClient, APIError, Endpoints
    │   ├── Storage/        # UserDefaultsManager, JSONFileStore
    │   └── Services/       # protocol + Mock + Supabase/OpenAI/RC stubs
    ├── Models/             # Starter, Feeding, Recipe, BakeSession, Analysis, User, Enums
    ├── Features/
    │   ├── Onboarding/     # Welcome, SignIn, SignUp, CreateStarter, StarterGuide
    │   ├── Home/           # HomeView + cards
    │   ├── Starters/       # List, Detail, AddFeeding, Edit, DiscardCalculator
    │   ├── Recipes/        # Library, Detail, Row
    │   ├── BakeTimer/      # BakeSession (with temp adjustment), BakeStep, …
    │   ├── AIVision/       # AICameraView (starter | loaf), AnalysisResults
    │   ├── Profile/        # ProfileView, SubscriptionView, SettingsView
    │   └── Paywall/        # PaywallView
    ├── Shared/             # Date+Relative, View+SDStyle, BakersPercentage, FeedingScheduler, StreakCounter
    ├── MockData/           # MockStarters, MockRecipes, MockBakes, MockUser, MockAnalyses
    └── Resources/          # Info.plist, Assets.xcassets (AppIcon placeholder, AccentColor)
```

---

## 3 · Conventions

- **Views:** every screen has a `@MainActor final class XxxViewModel: ObservableObject` above
  it in the same file. Pull services from `@Environment(\.services)`, app state from `@EnvironmentObject`.
- **Services:** protocol in `Core/Services/`, concrete `MockXxxService` (works today),
  concrete `SupabaseXxxService` / `OpenAIXxxService` / `RevenueCatXxxService` (throws
  `APIError.notImplemented` until wired). `ServiceContainer` picks which via `#if USE_REAL_SERVICES`.
- **Design tokens:** never hardcode. Always `SDColor.primary`, `SDFont.headingMedium`,
  `SDSpace.s4`, `SDRadius.lg`, `SDShadow.card`, `SDIcon.sparkles`.
- **Persistence:** `MockStarterService` and `MockBakeService` write to JSON in the
  documents directory via `JSONFileStore`. Pass `persisted: false` for previews and tests.
- **Adding a Swift file to the project:** the pbxproj is hand-written with a deterministic
  ID scheme. Each new file needs **four** edits:
  1. `PBXBuildFile` line near the top — `AA000000000000000XXX /* foo.swift in Sources */`
  2. `PBXFileReference` line — `FA000000000000000XXX /* foo.swift */`
  3. Inside the appropriate `PBXGroup` — add the FA reference
  4. Inside `PBXSourcesBuildPhase` for the app target — add the AA reference

  Pick the next free `XXX` (currently 09D is the highest used).

---

## 4 · State as of this handoff

### ✅ Shipped (previous session)
| Feature | Files | Status |
|---|---|---|
| Temperature-adjusted bake timer | `Features/BakeTimer/BakeSessionView.swift` | Pre-bake setup screen, slider 16–32°C, live step-time preview, formula `2^((24−T)/10)` |
| Starter peak tracker | `Features/Starters/AddFeedingSheet.swift` + `StarterDetailView.swift` + `Models/Feeding.swift` | New `peakTimeMinutes: Int?` field, "Did it peak?" toggle in feeding sheet, "Ready to bake?" card on detail with `ReadinessStatus` enum |
| Golden color palette | `Core/DesignSystem/Color+Tokens.swift`, `Resources/Assets.xcassets/AccentColor.colorset/` | Saddle Brown → Amber Gold (`#C8860A`) across primary/accent/text/borders |
| JSON persistence | `Core/Storage/JSONFileStore.swift`, both mock services | Survives app relaunch; previews/tests use `persisted: false` |
| Discard calculator | `Features/Starters/DiscardCalculatorView.swift` | Quick action on Home + menu item on Starter Detail; ratio chips, refresh recipe preview, discard ideas |
| Loaf AI scoring | `Features/AIVision/AICameraView.swift` + `AnalysisResultsView.swift` | `ScanMode` enum (.starter/.loaf), `AIResult` enum render switch, "Score My Bake" CTA in BakeSession completionView |

### ✅ Shipped (this session)
| Feature | Files | Status |
|---|---|---|
| "Continue without account" | `Features/Onboarding/WelcomeView.swift` | Button sets `appState.user = MockUser.sample`; unblocks all testing without Supabase |
| Sign-in UX fixes | `Features/Onboarding/SignInView.swift`, `Core/Components/SDTextField.swift` | `autocorrectionDisabled: true` kills accent popup; `submitLabel` + `onSubmit` for Return-key chaining; same fixes applied to SignUpView |
| `ReadinessStatus` extracted | `Shared/Extensions/Starter+Readiness.swift` | Moved out of `StarterDetailViewModel`; now an extension on `Starter` so any screen can use it |
| Readiness banner on Home | `Features/Home/StarterReadinessBanner.swift`, `HomeView.swift` | Compact color-coded banner shows "Bubbles is ready to bake!" between starter chips and quick actions |
| Local notifications wired | `Features/Starters/AddFeedingSheet.swift`, `App/AppCoordinator.swift` | After each feeding logged: cancel + reschedule reminder; on app launch: refresh all reminders for all starters |
| Settings → Reset data | `Features/Profile/SettingsView.swift` | Confirmation dialog wipes `starters.json` + `bakes.json` + cancels all notifications |
| `.gitignore` | `.gitignore` | Covers `xcuserdata/`, `*.xcuserstate`, `DerivedData/`, `.DS_Store`, `.env` |
| GitHub Actions CI | `.github/workflows/ci.yml` | `xcodebuild build` + `xcodebuild test` on push/PR to main |
| Privacy manifest | `Resources/PrivacyInfo.xcprivacy` | Required for iOS 17+ App Store; declares UserDefaults + FileTimestamp API access |
| New unit tests (26 total → 41 total) | `SourdoughProTests/BakeSessionViewModelTests.swift` | Tests for `tempAdjustmentFactor`, `tempAdjustmentLabel`, `ReadinessStatus`, `averagePeakMinutes`, `DiscardCalculatorViewModel` math; all 41 tests pass |
| Real GPT-4o Vision wired | `Core/Services/AIVisionService.swift`, `Core/Services/ServiceContainer.swift` | `OpenAIVisionService` now calls `https://api.openai.com/v1/chat/completions` directly; auto-activates if `OpenAIAPIKey` is set in Info.plist, mock fallback otherwise |
| Mock starters slimmed | `MockData/MockStarters.swift`, `Core/Services/StarterService.swift`, `BakeService.swift` | Gerty removed; fresh installs start with empty starter/bake stores instead of seeded fixtures |
| 8 new recipes | `MockData/MockRecipes.swift` | Jalapeño Cheddar, Pizza Loaf, Honey Oat Sandwich, Roasted Garlic & Asiago, Lemon Blueberry, NY Bagels, Chocolate Cherry, Sun-dried Tomato & Olive (now 18 total) |
| App icon | `Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` | Amber gradient bg, cream boule with gold rim, single bold score slash, three wheat sprigs at base |
| **Project rename** | _everything_ | `SourdoughApp` → `SourdoughPro` everywhere — folders, schemes, target names, bundle id `com.sourdough.app` → `com.sourdough.pro`, `@main struct SourdoughApp` → `SourdoughProApp`, all `@testable import` |
| **Secrets out of git** | `Config/Secrets.xcconfig` (gitignored) + `.template` | `OPENAI_API_KEY` lives in `Config/Secrets.xcconfig`, attached to both Debug/Release as `baseConfigurationReference` in pbxproj. Pbxproj contains zero secrets. |
| Design docs | `PRODUCT.md`, `DESIGN.md` | Impeccable-style design memory: audience, voice, register in PRODUCT; full token spec in DESIGN. Read both before touching UI. |
| Impeccable skill | `~/.claude/skills/impeccable/SKILL.md` | Global skill that codifies the 25 anti-patterns and design workflow; auto-triggers on UI work |

### 🟢 Existing & solid
- All MVP screens render & navigate
- 11 recipes in `MockRecipes`, 2 starters in `MockStarters` with feeding history
- Mock AI returns canned `StarterAnalysis` + `CrumbAnalysis` after 2-second sleep
- Build clean on Xcode 26.4 / iOS 26.4 simulator (`platform=iOS Simulator,name=iPhone 17 Pro Max`)
- 41 unit tests pass across 4 test files
- Local notifications fully wired: permission request on login, schedule/cancel on each feeding update

---

## 5 · MUST DO before TestFlight / public ship

**Priority 0 — blocking**

1. ~~**Real auth or no-account flow.**~~ ✅ **DONE** — "Continue without account" button on `WelcomeView.swift` sets `appState.user = MockUser.sample`. Real Supabase auth still a stub if/when you want a real backend.

2. **App icon.**
   `Resources/Assets.xcassets/AppIcon.appiconset/` is a placeholder. Need a 1024×1024
   master and the rest. With the new golden palette, the brand color is `#C8860A`. Suggested
   motif: stylised loaf cross-section or wheat sheaf in amber on cream `#FFFEF5`.

3. ~~**Sign-in UX bug.**~~ ✅ **DONE** — Added `autocorrectionDisabled: true` to email fields,
   `submitLabel` + `onSubmit` chaining so Return moves to password then submits. Verify on
   device (simulator-only macOS accent popup may still appear; the "Continue without account"
   button is the preferred test path).

4. ~~**Local notifications wired to scheduler.**~~ ✅ **DONE** — `AddFeedingSheet.save()` cancels
   + reschedules the feeding reminder after each feeding. `AppCoordinator` requests permission
   and schedules all reminders on login.

5. **Project hygiene.**
   - ✅ `.gitignore` — covers `xcuserdata/`, `*.xcuserstate`, `DerivedData/`, `.DS_Store`, `.env`
   - ✅ GitHub Actions CI — `.github/workflows/ci.yml` builds + tests on push to main
   - ⬜ `swiftlint` / `swiftformat` — run once and commit to lock in style

**Priority 1 — required for App Store**

6. **App Store metadata** — name, subtitle, keywords, screenshots (4 required), privacy policy URL
   (NSCameraUsageDescription / NSUserNotificationsUsageDescription are already in `Info.plist`).
7. ~~**Privacy manifest**~~ ✅ **DONE** — `Resources/PrivacyInfo.xcprivacy` created and added to the
   app target's Resources build phase.
8. **Subscription products in App Store Connect** — RevenueCat is a stub
   (`Core/Services/SubscriptionService.swift`). Either wire it for real or remove the paywall
   path until v2 and ship as fully-free first.

---

## 6 · SHOULD DO — research-driven, high impact

Numbered roughly by impact-per-effort. Each entry: what / where / why.

1. ~~**Surface readiness on Home**~~ ✅ **DONE** — `StarterReadinessBanner` in
   `Features/Home/StarterReadinessBanner.swift` shows color-coded banner for the selected
   starter between the chip row and quick actions. Logic lives in `Shared/Extensions/Starter+Readiness.swift`.

2. **Starter activity sparkline** — On `StarterDetailView`, the meta row shows feeding
   *count* (`45`) but no time-series. Even a 7-day sparkline of rise heights or peak
   times in the health card would feel earned. Use Swift Charts.

3. ~~**Tests for the new code**~~ ✅ **DONE** — `SourdoughProTests/BakeSessionViewModelTests.swift`
   covers `tempAdjustmentFactor`, `tempAdjustmentLabel`, all `ReadinessStatus` cases,
   `averagePeakMinutes`, and all `DiscardCalculatorViewModel` math. 41 tests pass total.

4. **"What went wrong?" troubleshooter** — Research's #2 unique opportunity. The
   loaf scoring infra we just built is ~80% of this. Add a `troubleshoot` mode to
   `AICameraView` that re-uses `analyzeCrumb` but renders different copy in
   `AnalysisResultsView` framed as "what to fix", with photos of common defects.

5. **Visual bulk-ferment guide** — Research P1. New screen accessible from
   `BakeStepView` when the current step is `.bulkFerment`. Show target-volume
   illustration (a container 75% full vs current), a poke-test guide, and example
   photos. Could ship as static content; no AI required.

6. ~~**Settings → "Reset app data"**~~ ✅ **DONE** — "Reset All App Data" button in
   `Features/Profile/SettingsView.swift` with confirmation dialog. Wipes `starters.json`,
   `bakes.json`, and cancels all pending notifications.

7. **Empty-state copy pass** — Most screens have one but with the new palette they
   could be punchier. Particular targets: `RecipeLibraryView` no-results, `StarterListView`
   no-starters, `Features/Home/HomeView` recent-bakes empty, `Features/Profile/ProfileView`
   subscription-tier free.

8. **iPad layout** — All views are iPhone-portrait-locked
   (`UISupportedInterfaceOrientations` in Info.plist). Several screens (Recipes,
   Starters list) would benefit from a sidebar on iPad. Probably v2.

9. **Watch app / complication** — In `ROADMAP.md` post-launch list. Real value:
   feeding reminder on the wrist. Not blocking ship.

10. **Voice-guided baking** — Hands-free during kneading/shaping. Research called
    this out as unique. Implementation: tap a step → AVSpeechSynthesizer reads the
    instruction. Then "Hey Siri, next step" via App Intents. v2 territory.

---

## 7 · Backend wiring checklist (when we're ready)

Only do this after the app icon + auth + persistence questions are settled.

- [ ] Create Supabase project; set `APIClient(baseURL:)` in
      `Core/Services/ServiceContainer.swift`
- [ ] Run schema SQL — DEV_SPEC §4 has the model shapes. Tables: `starters`, `feedings`,
      `recipes`, `recipe_steps`, `bake_sessions`, `step_completions`, `users`,
      `starter_analyses`, `crumb_analyses`.
- [ ] Fill in `SupabaseAuthService` — endpoint comments are in `AuthService.swift`
- [ ] Fill in `SupabaseStarterService` / `SupabaseBakeService` / `SupabaseRecipeService`
- [ ] Set up Edge Functions `analyze-starter` and `analyze-crumb` per DEV_SPEC §7.
      They should accept `image_base64` + ID, call GPT-4o Vision with the prompts
      from §7, return JSON matching `StarterAnalysis` / `CrumbAnalysis`.
- [ ] Configure RevenueCat with two products: `pro_monthly`, `baker_yearly`. Wire
      `RevenueCatSubscriptionService`.
- [ ] Flip `USE_REAL_SERVICES` build flag in Debug → Release configs.

---

## 8 · Gotchas & how-tos

### Build & run
```bash
# Build for simulator
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project /Users/beck/sourdough/sourdough-app/SourdoughPro.xcodeproj \
  -scheme SourdoughPro \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -derivedDataPath /tmp/sourdough-build build

# Install + launch on the running simulator
SIM=A0760316-A6E1-49CA-B718-9D0E1A20B293   # iPhone 17 Pro Max, iOS 26.4
APP=/tmp/sourdough-build/Build/Products/Debug-iphonesimulator/SourdoughPro.app
/Applications/Xcode.app/Contents/Developer/usr/bin/simctl install "$SIM" "$APP"
/Applications/Xcode.app/Contents/Developer/usr/bin/simctl launch "$SIM" com.sourdough.pro

# Run tests
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild test \
  -project /Users/beck/sourdough/sourdough-app/SourdoughPro.xcodeproj \
  -scheme SourdoughPro \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max'
```

### When working with Claude's computer-use
- Xcode is granted at **click-tier** — you can press its Run button and read the build
  log, but **cannot type into the editor or integrated terminal**. Edit files via the
  Bash/Edit tools, then click Run.
- Simulator is granted at **full tier** — typing & dragging work.
- The simulator window can sit behind Xcode; drag it to the right (`left_click_drag`
  on its title bar) before precise interactions.
- Sign-in shortcut: tap "I have an account" → "Continue with Apple". The mock accepts
  with no credentials. Don't try to type into the email field — see Must-do #3.

### Mock data lives long
- Everything written by `MockStarterService` / `MockBakeService` is in the simulator's
  documents dir at `~/Library/Developer/CoreSimulator/Devices/<SIM-UUID>/data/Containers/Data/Application/<APP-UUID>/Documents/{starters,bakes}.json`.
- To reset: uninstall & reinstall the app (`simctl uninstall`), or call
  `JSONFileStore.reset()` from a future Settings → Reset action (see Should-do #6).

### Useful invariants
- Every UUID in `MockStarters` / `MockRecipes` is stable across launches — fine to
  hardcode in tests (`MockStarters.bubblesId`, `MockRecipes.classicSourdoughId`).
- `services.starters` is the only place mutations to starters happen; the
  `@Published var starters` is the source of truth, all VMs subscribe.
- `Recipe` is read-only (no service mutations) — `MockRecipeService` always returns
  `MockRecipes.all`. Custom recipes are post-MVP.

---

## 9 · Files most likely to need touching next

If picking up work, these are the highest-traffic files in priority order:

| File | Why |
|---|---|
| `Resources/Assets.xcassets/AppIcon.appiconset/` | Drop generated 1024×1024 icon set (Must-do #2 — only blocking item left) |
| `Features/Starters/StarterDetailView.swift` | Activity sparkline using Swift Charts (Should-do #2) |
| `Features/AIVision/AICameraView.swift` | "What went wrong?" troubleshooter mode (Should-do #4) |
| `Features/BakeTimer/BakeStepView.swift` | Visual bulk-ferment guide when step type is `.bulkFerment` (Should-do #5) |
| `Core/Services/AuthService.swift` | Wire `SupabaseAuthService` if/when real backend is ready |
| `Core/Services/SubscriptionService.swift` | Wire RevenueCat or remove paywall for v1 free ship |

---

## 10 · Open questions for the user

These need decisions before continuing:

- **Account model** — real Supabase backend, or local-only forever? Affects #1 + ROADMAP.
- **Subscription** — keep Free/Pro/Baker tiers from FEATURES.md, or ship v1 fully-free?
- **App Store name** — "Sourdough", "Master Sourdough", something else? Affects icon design.
- **Icon direction** — abstract loaf, wheat sheaf, fermenting jar with bubbles? With
  the golden palette there's a lot of room.
- **Target launch date** — drives whether to invest in SwiftData migration (currently
  Codable-on-disk via JSONFileStore) before the schema sets.
