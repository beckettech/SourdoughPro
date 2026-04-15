# Sourdough App — Developer Specification

**Project:** Sourdough starter & baking companion app  
**Platform:** iOS (Swift)  
**Target:** iOS 16+  
**Last Updated:** 2026-04-14

---

## 1. Executive Summary

An AI-powered sourdough baking app that helps users track starters, time bakes, and improve their bread through computer vision. Key differentiator: AI-powered starter health scoring and crumb analysis via photos.

### Tiers
- **Free:** 1 starter, basic tracking, 10 recipes, 3 AI scans/month
- **Pro ($4.99/mo):** Unlimited starters, unlimited AI scans, proofing camera, advanced timers
- **Baker ($9.99/mo):** All Pro + AI coach chat, custom recipes, community features

---

## 2. Tech Stack

### Frontend (iOS)
| Component | Technology |
|-----------|------------|
| Language | Swift 5.9 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator |
| Networking | Alamofire + Combine |
| Local Storage | SwiftData (iOS 17+) or Core Data fallback |
| Push Notifications | UNUserNotificationCenter |
| Camera | AVFoundation + Vision |
| Charts | Swift Charts |

### Backend
| Component | Technology |
|-----------|------------|
| API | Supabase (PostgreSQL + Auth + Storage) |
| Serverless Functions | Supabase Edge Functions (Deno) |
| AI Vision | OpenAI GPT-4o Vision API |
| Payments | RevenueCat (manages Stripe/App Store) |
| Push | Supabase + APNs |
| File Storage | Supabase Storage (S3-compatible) |

### Third-Party Services
| Service | Purpose |
|---------|---------|
| OpenAI API | Starter/crumb analysis via GPT-4o Vision |
| RevenueCat | Subscription management |
| Mixpanel | Analytics |
| Sentry | Crash reporting |

---

## 3. App Architecture

```
SourdoughApp/
├── App/
│   ├── SourdoughApp.swift          # App entry point
│   ├── AppDelegate.swift           # Push notifications, deep links
│   └── Coordinator.swift           # Navigation coordination
├── Core/
│   ├── Network/
│   │   ├── APIClient.swift         # Base API client
│   │   ├── Endpoints.swift         # API endpoints
│   │   └── Interceptors.swift      # Auth, retry logic
│   ├── Storage/
│   │   ├── SwiftDataContainer.swift
│   │   └── UserDefaultsManager.swift
│   └── Services/
│       ├── AIService.swift         # OpenAI Vision calls
│       ├── NotificationService.swift
│       └── SubscriptionService.swift
├── Features/
│   ├── Onboarding/
│   ├── StarterTracking/
│   ├── RecipeLibrary/
│   ├── BakeTimer/
│   ├── AIVision/
│   ├── Profile/
│   └── Settings/
├── Shared/
│   ├── Components/                 # Reusable UI components
│   ├── Extensions/
│   ├── Models/
│   └── Utils/
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

---

## 4. Data Models

### Core Entities

```swift
// MARK: - Starter
struct Starter: Identifiable, Codable {
    let id: UUID
    var name: String
    var createdAt: Date
    var flourType: FlourType          // bread, rye, whole wheat, etc.
    var hydration: Int               // percentage, usually 100
    var feedingHistory: [Feeding]
    var photos: [StarterPhoto]
    var healthScore: Double?         // 0-10, updated by AI
    var lastFedAt: Date?
    var nextFeedingAt: Date?         // calculated based on patterns
    var isActive: Bool
    var notes: String
}

struct Feeding: Identifiable, Codable {
    let id: UUID
    let date: Date
    let starterGrams: Int
    let flourGrams: Int
    let waterGrams: Int
    var notes: String?
    var photoUrl: String?
    var riseHeight: Int?             // cm
    var smellRating: SmellRating?    // pleasant, sour, funky, off
    var bubbleSize: BubbleSize?      // small, medium, large
}

// MARK: - Recipe
struct Recipe: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var difficulty: Difficulty        // beginner, intermediate, advanced
    var prepTime: Int                // minutes
    var totalDuration: Int           // hours
    var servings: Int
    var ingredients: [Ingredient]
    var steps: [RecipeStep]
    var hydration: Int
    var flourType: FlourType
    var imageUrl: String?
    var authorId: UUID?              // nil = official recipe
    var isPremium: Bool
    var tags: [String]
}

struct RecipeStep: Identifiable, Codable {
    let id: UUID
    var order: Int
    var title: String
    var instructions: String
    var duration: Int?               // minutes (if timed step)
    var timerType: TimerType?        // bulk, proof, bake, rest
    var imageUrl: String?
}

// MARK: - Bake Session
struct BakeSession: Identifiable, Codable {
    let id: UUID
    let starterId: UUID
    let recipeId: UUID
    var startedAt: Date
    var currentStep: Int
    var stepHistory: [StepCompletion]
    var photos: [BakePhoto]
    var crumbAnalysisId: UUID?
    var notes: String
    var rating: Int?                 // 1-5 stars
}

struct StepCompletion: Codable {
    let stepId: UUID
    let completedAt: Date
    let actualDuration: Int?         // if different from expected
}

// MARK: - AI Analysis
struct StarterAnalysis: Identifiable, Codable {
    let id: UUID
    let starterId: UUID
    let imageUrl: String
    let createdAt: Date
    var healthScore: Double          // 0-10
    var riseEstimate: Int?           // predicted peak hours
    var issues: [String]             // "hooch layer", "no bubbles", etc.
    var recommendations: [String]
    var rawResponse: String          // for debugging
}

struct CrumbAnalysis: Identifiable, Codable {
    let id: UUID
    let bakeSessionId: UUID
    let imageUrl: String
    let createdAt: Date
    var overallScore: Double         // 0-10
    var crumbStructure: CrumbStructure  // open, tight, irregular, perfect
    var fermentationScore: Double
    var shapingScore: Double
    var bakeScore: Double
    var observations: [String]
    var recommendations: [String]
}

// MARK: - User
struct User: Identifiable, Codable {
    let id: UUID
    var email: String
    var displayName: String?
    var avatarUrl: String?
    var subscriptionTier: SubscriptionTier
    var subscriptionExpiresAt: Date?
    var aiScansRemaining: Int        // for free tier
    var createdAt: Date
    var settings: UserSettings
}

enum SubscriptionTier: String, Codable {
    case free = "free"
    case pro = "pro"
    case baker = "baker"
}
```

---

## 5. Screen Specifications

### 5.1 Onboarding Flow

```
┌─────────────────────────────────┐
│  Welcome Screen                 │
│                                 │
│  [Hero illustration: bread]     │
│                                 │
│  "Master Sourdough"             │
│  "Track, bake, improve"         │
│                                 │
│  [Get Started]  [Sign In]       │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Create Account                 │
│                                 │
│  Email: [________________]      │
│  Password: [________________]   │
│                                 │
│  [Continue with Apple]          │
│  [Continue with Google]         │
│                                 │
│  ────── or ──────               │
│                                 │
│  Already have account? Sign In  │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Name Your Starter              │
│                                 │
│  "Every journey starts with     │
│   your first starter"           │
│                                 │
│  Name: [________________]       │
│  e.g., "Bubbles", "Bread Pitt"  │
│                                 │
│  Flour type:                    │
│  ○ Bread flour (recommended)    │
│  ○ Whole wheat                  │
│  ○ All-purpose                  │
│  ○ Rye                          │
│                                 │
│  [Create Starter]               │
└─────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  How to Create Your Starter     │
│                                 │
│  Step-by-step guide with        │
│  illustrations:                 │
│                                 │
│  1. Mix 50g flour + 50g water   │
│     [📸 Photo example]          │
│                                 │
│  2. Cover loosely               │
│     [📸 Photo example]          │
│                                 │
│  3. Wait 24 hours...            │
│     [I've Done This →]          │
│                                 │
│  [Skip for now]                 │
└─────────────────────────────────┘
```

### 5.2 Main Tab Structure

```
┌─────────────────────────────────┐
│  Tab Bar                        │
├─────────────────────────────────┤
│  🏠 Home    🥖 Recipes    👤 Profile
│  🍞 Starters    📊 Bake Timer
└─────────────────────────────────┘
```

### 5.3 Home Screen

```
┌─────────────────────────────────┐
│  Good morning, Beck! ☀️          │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │ 🔔 Bubbles needs feeding!  │  │
│  │ Last fed: 18 hours ago     │  │
│  │                            │  │
│  │ [Feed Now] [Snooze 2h]     │  │
│  └───────────────────────────┘  │
│                                 │
│  YOUR STARTERS                  │
│  ┌─────────┐ ┌─────────┐        │
│  │Bubbles  │ │Gerty    │  [+]   │
│  │🟢 92%   │ │🟡 78%   │        │
│  │18h ago  │ │2d ago   │        │
│  └─────────┘ └─────────┘        │
│                                 │
│  QUICK ACTIONS                  │
│  ┌───────┐ ┌───────┐ ┌───────┐  │
│  │📷 AI  │ │⏱ Start│ │📖 New │  │
│  │Check  │ │ Bake   │ │Recipe │  │
│  └───────┘ └───────┘ └───────┘  │
│                                 │
│  RECENT BAKES                   │
│  ┌───────────────────────────┐  │
│  │ Classic Sourdough         │  │
│  │ 2 days ago ⭐⭐⭐⭐☆        │  │
│  └───────────────────────────┘  │
│                                 │
└─────────────────────────────────┘
```

### 5.4 Starter Detail Screen

```
┌─────────────────────────────────┐
│  ← Bubbles               [✏️]   │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │                           │  │
│  │    [📸 Starter Photo]     │  │
│  │                           │  │
│  │    Health Score: 8.5/10   │  │
│  │    ════════════════░░     │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  DETAILS                        │
│  Created: Jan 15, 2026          │
│  Flour: Bread flour             │
│  Hydration: 100%                │
│  Age: 89 days                   │
│                                 │
│  NEXT FEEDING                   │
│  In ~4 hours (peak activity)    │
│                                 │
│  FEEDING HISTORY                │
│  ┌───────────────────────────┐  │
│  │ Today, 6:00 AM            │  │
│  │ 25g starter + 50g + 50g   │  │
│  │ Rise: 4cm  Bubbles: Large │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │
│  │ Yesterday, 6:00 PM        │  │
│  │ 25g starter + 50g + 50g   │  │
│  └───────────────────────────┘  │
│                                 │
│  [🤖 AI Health Check]           │
│  [📝 Add Feeding]               │
│                                 │
└─────────────────────────────────┘
```

### 5.5 AI Vision Screen

```
┌─────────────────────────────────┐
│  ← AI Analysis                  │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │                           │  │
│  │    [Camera Viewfinder]    │  │
│  │                           │  │
│  │    Position starter       │  │
│  │    in the frame           │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌─────┐ ┌─────┐ ┌─────┐        │
│  │Starter│ │Crumb│ │Proof│      │
│  └─────┘ └─────┘ └─────┘        │
│                                 │
│         [📸 Take Photo]         │
│                                 │
└─────────────────────────────────┘

         │ After photo
         ▼

┌─────────────────────────────────┐
│  ← Analysis Results             │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │    [Your starter photo]   │  │
│  └───────────────────────────┘  │
│                                 │
│  HEALTH SCORE                   │
│  8.5 / 10                       │
│  ════════════════░░             │
│                                 │
│  ✅ Good bubble activity        │
│  ✅ Healthy rise height         │
│  ⚠️ Slight hooch layer          │
│                                 │
│  RECOMMENDATIONS                │
│  • Feed within 4-6 hours        │
│  • Consider a 1:3:3 ratio       │
│  • Warmer spot (75-78°F)        │
│                                 │
│  ┌───────────────────────────┐  │
│  │ Estimated Peak: ~6 hours  │  │
│  │ [Set Reminder]            │  │
│  └───────────────────────────┘  │
│                                 │
│  [Save to History]              │
│                                 │
└─────────────────────────────────┘
```

### 5.6 Recipe Detail Screen

```
┌─────────────────────────────────┐
│  ← Classic Sourdough            │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │    [Recipe Hero Image]    │  │
│  │                           │  │
│  │   Classic Sourdough       │  │
│  │   ⭐⭐⭐⭐⭐ (234 reviews)  │  │
│  └───────────────────────────┘  │
│                                 │
│  ⏱ 24 hrs  •  🍞 2 loaves       │
│  💧 75% hydration               │
│  📊 Intermediate                │
│                                 │
│  INGREDIENTS                    │
│  ┌───────────────────────────┐  │
│  │ 500g  Bread flour         │  │
│  │ 375g  Water (warm)        │  │
│  │ 100g  Active starter      │  │
│  │ 10g   Salt                │  │
│  └───────────────────────────┘  │
│                                 │
│  [Start Baking →]               │
│                                 │
│  STEPS                          │
│  1. Feed starter (4-8 hrs)      │
│  2. Mix dough (10 min)          │
│  3. Bulk ferment (4-6 hrs)      │
│  4. Shape (15 min)              │
│  5. Cold proof (8-12 hrs)       │
│  6. Bake (45 min)               │
│                                 │
└─────────────────────────────────┘
```

### 5.7 Bake Timer Screen

```
┌─────────────────────────────────┐
│  ← Bake in Progress             │
├─────────────────────────────────┤
│                                 │
│  Classic Sourdough              │
│  Started: Today, 8:00 AM        │
│                                 │
│  CURRENT STEP                   │
│  ┌───────────────────────────┐  │
│  │                           │  │
│  │    Bulk Fermentation      │  │
│  │                           │  │
│  │    02:34:17               │  │
│  │                           │  │
│  │    ⏸ Pause    ✓ Complete  │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  PROGRESS                       │
│  ●──●──●──○──○──○              │
│  Mix Bulk Shape Proof Bake      │
│  ✓   ✓   ←                     │
│                                 │
│  NEXT STEPS                     │
│  • Shape dough (15 min)         │
│  • Cold proof (8-12 hrs)        │
│  • Bake (45 min)                │
│                                 │
│  NOTES                          │
│  [Add a note...]                │
│                                 │
│  📸 [Add Photo]                 │
│                                 │
└─────────────────────────────────┘
```

### 5.8 Profile & Settings

```
┌─────────────────────────────────┐
│  Profile                        │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │   [Avatar]                │  │
│  │   Beck                    │  │
│  │   beck@email.com          │  │
│  │   Pro Member              │  │
│  └───────────────────────────┘  │
│                                 │
│  STATS                          │
│  ┌─────┐ ┌─────┐ ┌─────┐        │
│  │ 47  │ │ 12  │ │ 89  │        │
│  │Bakes│ │Start│ │Days │        │
│  └─────┘ └─────┘ └─────┘        │
│                                 │
│  ACHIEVEMENTS                   │
│  🏆 First Loaf  🥖 10 Bakes     │
│  🔥 7-Day Streak                │
│                                 │
│  SUBSCRIPTION                   │
│  Pro Plan - $4.99/mo            │
│  [Manage Subscription]          │
│                                 │
│  SETTINGS                       │
│  > Notifications                │
│  > Units (Metric/Imperial)      │
│  > Theme                        │
│  > Privacy                      │
│  > Help & Support               │
│                                 │
│  [Sign Out]                     │
│                                 │
└─────────────────────────────────┘
```

---

## 6. API Endpoints

### Authentication (Supabase Auth)
```
POST /auth/v1/signup
POST /auth/v1/token?grant_type=password
POST /auth/v1/token?grant_type=refresh_token
POST /auth/v1/signout
GET  /auth/v1/user
```

### Starters
```
GET    /rest/v1/starters?user_id=eq.{userId}
POST   /rest/v1/starters
GET    /rest/v1/starters/{id}
PATCH  /rest/v1/starters/{id}
DELETE /rest/v1/starters/{id}

POST   /rest/v1/starters/{id}/feedings
GET    /rest/v1/feedings?starter_id=eq.{starterId}
```

### Recipes
```
GET    /rest/v1/recipes?is_premium=eq.false
GET    /rest/v1/recipes/{id}
POST   /rest/v1/recipes              # User-created (Baker tier)
GET    /rest/v1/recipes?author_id=eq.{userId}
```

### Bake Sessions
```
POST   /rest/v1/bake-sessions
GET    /rest/v1/bake-sessions/{id}
PATCH  /rest/v1/bake-sessions/{id}
POST   /rest/v1/bake-sessions/{id}/complete-step
```

### AI Analysis (Edge Functions)
```
POST /functions/v1/analyze-starter
  Body: { image_base64: string, starter_id: uuid }
  Response: { health_score, issues[], recommendations[], estimated_peak_hours }

POST /functions/v1/analyze-crumb
  Body: { image_base64: string, bake_session_id: uuid }
  Response: { overall_score, crumb_structure, fermentation_score, observations[], recommendations[] }
```

### Storage
```
POST /storage/v1/object/starter-photos/{userId}/{starterId}/{timestamp}.jpg
POST /storage/v1/object/bake-photos/{userId}/{sessionId}/{timestamp}.jpg
```

---

## 7. AI Integration

### GPT-4o Vision Prompt Templates

**Starter Analysis:**
```
You are a sourdough expert analyzing a photo of a sourdough starter.

Analyze this starter photo and provide:
1. Health score (0-10) based on:
   - Bubble activity and size
   - Rise height estimate
   - Color and texture
   - Any visible issues (hooch, mold, separation)

2. List of issues detected (if any)

3. Specific recommendations for improvement

4. Estimated hours until peak activity

Respond in JSON format:
{
  "health_score": 8.5,
  "issues": ["slight hooch layer visible"],
  "recommendations": [
    "Feed within 4-6 hours",
    "Consider increasing feeding ratio to 1:3:3",
    "Store in warmer location (75-78°F)"
  ],
  "estimated_peak_hours": 6
}
```

**Crumb Analysis:**
```
You are a professional baker analyzing the crumb structure of a sourdough loaf.

Analyze this cross-section photo and provide:
1. Overall score (0-10)
2. Crumb structure classification
3. Fermentation assessment (under/over proofed)
4. Shaping assessment
5. Bake assessment
6. Specific observations
7. Recommendations for improvement

Respond in JSON format:
{
  "overall_score": 7.5,
  "crumb_structure": "open",
  "fermentation_score": 8,
  "shaping_score": 7,
  "bake_score": 8,
  "observations": [
    "Good open crumb structure",
    "Slight denseness at bottom suggests minor under-proofing",
    "Nice ear on the score"
  ],
  "recommendations": [
    "Extend proof time by 30-60 minutes",
    "Consider slightly higher hydration for more openness"
  ]
}
```

---

## 8. Push Notifications

### Types
| Type | Trigger | Deep Link |
|------|---------|-----------|
| `feeding_reminder` | Starter due for feeding | `/starters/{id}` |
| `fermentation_complete` | Bulk ferment timer done | `/bake/{id}` |
| `proofing_complete` | Proof timer done | `/bake/{id}` |
| `bake_time` | Ready to bake | `/bake/{id}` |
| `ai_analysis_ready` | Analysis complete | `/starters/{id}/analysis/{analysisId}` |
| `subscription_expired` | Tier downgrade | `/profile/subscription` |
| `streak_reminder` | Haven't baked in 7 days | `/recipes` |

### Scheduling Logic
```swift
class NotificationService {
    
    // Called after each feeding
    func scheduleNextFeedingReminder(for starter: Starter) {
        // Calculate based on:
        // - Time since last feeding
        // - Historical patterns (peak activity time)
        // - Current temperature (if available)
        
        let estimatedPeak = calculatePeakTime(for: starter)
        let reminderTime = estimatedPeak - 2 hours // Alert before peak
        
        scheduleNotification(
            id: "feeding-\(starter.id)",
            title: "\(starter.name) needs feeding! 🍞",
            body: "Peak activity in ~2 hours. Feed now for best results.",
            at: reminderTime,
            deepLink: "sourdough://starters/\(starter.id)"
        )
    }
    
    // Bake session timers
    func scheduleBakeTimers(for session: BakeSession) {
        // Schedule notifications for each timed step
    }
}
```

---

## 9. Subscription Management (RevenueCat)

### Setup
```swift
// AppDelegate
import RevenueCat

func application(_ application: UIApplication, 
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: "app_store_api_key", appUserID: nil)
    
    return true
}
```

### Entitlements
```
Entitlements:
├── pro
│   ├── unlimited_starters
│   ├── unlimited_ai_scans
│   ├── proofing_camera
│   └── advanced_timers
└── baker
    ├── all pro features
    ├── ai_coach_chat
    ├── custom_recipes
    └── community_features
```

### Offerings
```
Offering: default
├── $4.99/month - Pro
├── $49.99/year - Pro (save 17%)
├── $9.99/month - Baker
└── $99.99/year - Baker (save 17%)
```

---

## 10. Development Phases

### Phase 1: MVP (4-6 weeks)
**Goal:** Core tracking + AI differentiation

| Week | Deliverables |
|------|--------------|
| 1 | Project setup, auth, onboarding flow |
| 2 | Starter CRUD, feeding logging, local storage |
| 3 | Push notifications, feeding reminders |
| 4 | AI vision integration (starter analysis) |
| 5 | Recipe library (10 recipes), basic bake timer |
| 6 | Polish, beta testing prep, App Store submission |

**MVP Features:**
- ✅ Auth (Apple Sign In, email)
- ✅ Create/edit/delete starters
- ✅ Log feedings with photos
- ✅ AI starter health analysis (3 free scans)
- ✅ Basic feeding reminders
- ✅ 10 beginner recipes
- ✅ Simple bake timer
- ✅ Subscription paywall

### Phase 2: Pro Features (4 weeks)
| Week | Deliverables |
|------|--------------|
| 1 | Unlimited starters |
| 2 | Proofing camera + AI |
| 3 | Crumb analysis AI |
| 4 | Advanced timers, seasonal adjustments |

### Phase 3: Baker Features (4 weeks)
| Week | Deliverables |
|------|--------------|
| 1 | Custom recipe builder |
| 2 | AI coach chat |
| 3 | Community recipes |
| 4 | Gamification, achievements |

---

## 11. Testing Strategy

### Unit Tests
- Data model validation
- Date/time calculations (feeding schedules, fermentation times)
- Recipe scaling logic
- Hydration calculator

### UI Tests
- Onboarding flow
- Starter creation flow
- Feeding log flow
- Bake session flow

### Integration Tests
- API client
- Auth flow
- Subscription flow
- AI analysis flow

### Beta Testing
- TestFlight internal (team)
- TestFlight external (100-1000 users)
- Focus groups: 5 beginners, 5 experienced bakers

---

## 12. Launch Checklist

### Pre-Launch
- [ ] App Store assets (screenshots, preview video)
- [ ] Privacy policy
- [ ] Terms of service
- [ ] Support email setup
- [ ] Landing page website
- [ ] Social media accounts
- [ ] Press kit

### App Store
- [ ] App Store Connect setup
- [ ] In-app purchases configured
- [ ] Age rating questionnaire
- [ ] Export compliance
- [ ] App review submission

### Post-Launch
- [ ] Monitor crash reports (Sentry)
- [ ] Monitor subscription conversion
- [ ] Respond to reviews
- [ ] Content marketing (Instagram, TikTok)
- [ ] Gather feedback for v2

---

## 13. Success Metrics

| Metric | Target (3 months) |
|--------|-------------------|
| Downloads | 10,000 |
| DAU/MAU | 25% |
| Free → Pro conversion | 8% |
| Pro → Baker upgrade | 15% |
| Avg AI scans/user/month | 5 |
| Retention (Day 30) | 40% |
| App Store rating | 4.5+ |

---

## 14. Open Questions

1. **Brand name** — "Sourdough" something? Need trademark search
2. **AI provider** — OpenAI GPT-4o vs Claude vs custom model?
3. **Initial content** — Who writes the 10 starter recipes?
4. **Community moderation** — How to handle user-submitted recipes?
5. **Internationalization** — Launch English-only or multi-language?

---

## Appendix: Design Assets

### Color Palette
```
Primary:     #8B4513 (Saddle Brown - bread crust)
Secondary:   #F5DEB3 (Wheat - flour)
Accent:      #D2691E (Chocolate - crust gradient)
Background:  #FFFAF0 (Floral White - paper)
Success:     #228B22 (Forest Green - healthy starter)
Warning:     #DAA520 (Goldenrod - needs attention)
Error:       #8B0000 (Dark Red - problem)
```

### Typography
```
Headlines:   SF Pro Display (Bold, 24-32pt)
Body:        SF Pro Text (Regular, 16-17pt)
Captions:    SF Pro Text (Regular, 13-14pt)
Numbers:     SF Mono (for timer displays)
```

### Icons
Use SF Symbols where possible:
- `bread` → Custom (not in SF Symbols)
- `timer` → `timer`
- `camera` → `camera.fill`
- `chart` → `chart.line.uptrend.xyaxis`
- `person` → `person.fill`
- `gear` → `gearshape.fill`

---

*Document version: 1.0*  
*Last updated: 2026-04-14*  
*Author: OpenClaw*
