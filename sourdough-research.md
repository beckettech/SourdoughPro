# Sourdough App Research

## Goal
Research existing sourdough baking apps, guides, and tools to identify unique features for our sourdough starter & baking app.

## Research Areas

### 1. Existing Apps to Analyze
- Sourdough apps on iOS/Android App Stores
- Bread baking calculators
- Fermentation tracking apps

### 2. Key Pain Points for Sourdough Bakers
- **Starter maintenance**: When to feed, how much, hydration tracking
- **Timing**: Bulk fermentation, proofing times vary with temperature
- **Temperature**: Ambient temp affects everything
- **Hydration math**: Baker's percentage calculations
- **Consistency**: Reproducing good results
- **Troubleshooting**: Why didn't it rise? Why is it too sour?

### 3. What Existing Guides Cover
From King Arthur Baking research:
- Creating starter from scratch (7-14 days)
- Maintaining starter (feeding schedules)
- Understanding wild yeast + lactobacilli relationship
- Temperature and hydration importance
- Flavor development (lactic vs acetic acids)

### 4. Potential Unique Features

#### AI-Powered Features
- [ ] Photo analysis of starter activity (bubble count, rise level) ⚠️ Loaflo does this
- [ ] Predict fermentation timing based on temperature ⚠️ Autoproofer does this
- [ ] Troubleshooting assistant ("my bread didn't rise" → diagnosis) ✅ UNIQUE
- [ ] Recipe scaling calculator ⚠️ Common
- [ ] Flavor profile predictor based on fermentation time/temp ✅ UNIQUE
- [ ] **Multi-starter management** (different starters for different breads) ✅ UNIQUE
- [ ] **Voice-guided baking** (hands-free during kneading/shaping) ✅ UNIQUE
- [ ] **AR shaping guides** (overlays on dough) ✅ UNIQUE
- [ ] **Climate-adaptive recipes** (adjusts for humidity/altitude) ✅ UNIQUE

#### Tracking & Logging
- [ ] Starter feeding schedule with reminders ⚠️ Common
- [ ] Ambient temperature logging ⚠️ Common
- [ ] Bake journal with photos and notes ⚠️ Common
- [ ] Hydration calculator for starter and dough ⚠️ Common
- [ ] Baker's percentage converter ⚠️ Common
- [ ] **Starter lineage tracking** (who you shared starters with, generations) ✅ UNIQUE
- [ ] **Consistency score** (how similar was this bake to your best?) ✅ UNIQUE
- [ ] **Ingredient cost tracking** (cost per loaf) ✅ UNIQUE

#### Smart Features
- [ ] Weather-aware fermentation timing (humidity, temp) ⚠️ Partial
- [ ] "Ready to bake?" starter assessment ⚠️ Loaflo does this
- [ ] Bulk fermentation timer with temp adjustment ⚠️ Common
- [ ] Proofing stage detector (poke test guide) ✅ UNIQUE
- [ ] Crumb analysis from photos ⚠️ SourdoughGuru does this
- [ ] **Smart shopping list** (what you need for next bake based on recipes) ✅ UNIQUE
- [ ] **Fermentation station pairing** (which containers at what temp) ✅ UNIQUE

#### Community & Learning
- [ ] Recipe sharing with baker's percentages ⚠️ Common
- [ ] Video guides for techniques (stretch & fold, shaping) ⚠️ Common
- [ ] Common mistakes library ✅ UNIQUE if personalized
- [ ] Seasonal adjustments (summer vs winter baking) ⚠️ Partial
- [ ] **Local baker network** (nearby bakers, starter sharing) ✅ UNIQUE
- [ ] **Challenge mode** (new techniques to try, badges) ✅ UNIQUE
- [ ] **Bread dating** (match with bakers for starter swaps) ✅ UNIQUE & FUN

---

## Research Log

### 2026-04-14 11:48 PM - Initial Research
- King Arthur Baking guide: covers basics well, mentions "bakers' intuition" is as important as science
- Key insight: Temperature and hydration are the main variables
- Flavor is controlled by lactic vs acetic acid balance (affected by time/temp)
- Many approaches exist - no single "right" way

### 2026-04-14 12:15 AM - Reddit Pain Points Analysis

#### Top Problems from r/Sourdough troubleshooting posts:

1. **UNDERFERMENTATION IS #1** ⚠️
   - "90% of sourdough problems are underfermentation"
   - People use clock instead of watching dough
   - Quote: "don't watch the clock, watch the dough"

2. **Starter Maturity Misconception**
   - People think starter is ready too early
   - Real test: needs to double in 4-6 hours CONSISTENTLY
   - Can take 8+ weeks to mature properly

3. **Temperature Confusion**
   - Cold kitchen = longer fermentation
   - People don't adjust for winter vs summer
   - Need to find warm spots ("oven with light on" trick)

4. **No Visual Feedback Loop**
   - Can't tell when dough has risen 75%
   - Don't know what "jiggly" dough looks like
   - Need poke test guidance

5. **Flour Type Confusion**
   - Protein % matters for gluten development
   - Different flours need different hydration
   - Whole wheat tolerates higher hydration

### Key Opportunities Identified:

#### 🔥 HIGH IMPACT FEATURES

1. **"Is It Ready?" AI Photo Analyzer**
   - Take photo of dough → get fermentation progress %
   - Detect if under/over fermented
   - Show what proper bulk ferment looks like

2. **Starter Maturity Tracker**
   - Log feeding times and rise heights
   - Alert when starter is truly ready to bake
   - Track peak time patterns

3. **Visual Bulk Ferment Guide**
   - Show target volume increase (75%)
   - Time-lapse comparison photos
   - "Dough cam" overlay for your container

4. **Temperature-Adjusted Timer**
   - Input kitchen temp → get adjusted ferment times
   - Suggest warm spots in your home
   - Account for starter maturity

#### 💡 MEDIUM IMPACT FEATURES

5. **Flour-Specific Recipes**
   - Adjust hydration based on flour protein %
   - Account for whole wheat vs AP vs bread flour

6. **Poke Test Guide**
   - Visual guide for finger dent test
   - Video examples of properly proofed dough

7. **"What Went Wrong?" Troubleshooter**
   - Upload photo of failed loaf
   - AI diagnoses: underproofed, overproofed, weak gluten, etc.
   - Suggest fixes for next bake

---

## Competitor App Analysis

### Top Apps Identified (from Google search)

#### 1. **Rise: Baking & Bread Recipes**
- Rise time calculator
- Hydration calculator
- Water temperature calculator
- "Rise factor" tracker for consistency
- Highly praised by users ("data nerd" friendly)

#### 2. **Loaflo** ⭐ AI-Powered
- Scans starter photos to assess health
- Detects mold and starter issues
- AI-powered bread baking assistant

#### 3. **SourdoughGuru**
- AI-powered photo analysis
- Crumb and rise feedback from photos

#### 4. **Autoproofer**
- Fermentation guidance
- Environmental temperature control

#### 5. **Sourdough Forge**
- All-in-one sourdough system
- Comprehensive approach

#### 6. **Breadly**
- Sourdough scheduler
- Timing focused

#### 7. **Loaf Hacker**
- **Unique**: Tailors recipes to YOUR starter's performance
- Prompts every step of the way

#### 8. **Homebaker**
- Recipe creation with/without yeast
- Custom starter hydration input
- Exact dough calculations

#### 9. **Sour & Dough**
- Simple, no-nonsense approach
- Flour-based dough calculator
- Free on iOS

#### 10. **King Arthur Baking App**
- Free on iOS and Android
- Recipes and guidance
- Backed by King Arthur expertise

#### 11. **Sourdough Baker AI** (Android)
- AI bread analysis from photos
- Feedback on texture, rise, crust

### Web Tools
- **Flower Hour** - Generates full step-by-step timeline based on start/eat time
- **Loafy.ai** - AI chatbot using "Sourdough Framework" book, 24/7 in any language

---

## Feature Prioritization
*Based on research findings - Updated after Reddit pain point analysis*

| Feature | Impact | Effort | Priority | Notes |
|---------|--------|--------|----------|-------|
| **Fermentation Progress AI** | 🔥🔥🔥 | High | P0 | Solves #1 problem (underfermentation) |
| **Starter Maturity Tracker** | 🔥🔥🔥 | Medium | P0 | People bake too early with weak starter |
| **Temp-Adjusted Timing** | 🔥🔥 | Medium | P1 | Most existing apps miss this |
| **Visual Bulk Guide** | 🔥🔥 | Low | P1 | Simple but powerful |
| Hydration calculator | High | Low | P2 | Common, must-have baseline |
| Starter feeding reminders | Medium | Low | P2 | Common feature |
| **"What Went Wrong" AI** | 🔥🔥 | High | P2 | High differentiation |
| Recipe journal | Medium | Low | P3 | Standard feature |
| Community recipes | Medium | High | P4 | Nice to have |
| **Voice-guided baking** | 🔥 | Medium | P3 | Unique, hands-free during kneading |
| **Local baker network** | Low | High | P4 | Fun but niche |

---

## Notes
- Focus on solving real pain points, not just adding features
- AI should enhance intuition, not replace it
- Consider offline-first design (baking often happens away from screens)
