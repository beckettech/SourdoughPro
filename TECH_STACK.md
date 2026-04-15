# Sourdough App — Tech Stack Options

## Mobile Framework

### Option A: React Native (Expo) ⭐ Recommended
- **Pros:** Massive ecosystem, Beck already knows JS/TS, Expo Go for rapid prototyping, OTA updates, great React Native community
- **Cons:** Native module friction for advanced camera/vision, occasional performance hiccups
- **Verdict:** Fastest path to MVP

### Option B: Flutter
- **Pros:** Excellent performance, beautiful UI out of the box, single codebase for iOS/Android/Web, strong camera plugins
- **Cons:** Dart learning curve, smaller hiring pool, Beck less familiar
- **Verdict:** Better long-term, higher upfront cost

### Option C: Native (Swift + Kotlin)
- **Pros:** Best performance, full platform API access
- **Cons:** 2x codebases, 2x development time, brutal for solo/small team
- **Verdict:** Skip unless performance becomes a blocker

## Backend

### Option A: Supabase (PostgreSQL) ⭐ Recommended
- **Pros:** Auth, DB, storage, realtime, edge functions in one. Generous free tier. Great for MVP
- **Cons:** Vendor lock-in, cold starts on edge functions
- **Verdict:** Fastest to ship, scales fine to $1M+ ARR

### Option B: Firebase
- **Pros:** Mature, Google-backed, excellent real-time
- **Cons:** NoSQL is awkward for relational data (recipes + ingredients + starters), pricing can spike

### Option C: Custom (Node/Express + PostgreSQL)
- **Pros:** Full control, no vendor lock-in
- **Cons:** More ops work, slower to start

## AI Vision Model

### Option A: GPT-4o Vision ⭐ Recommended for MVP
- **Pros:** Best-in-class image understanding, easy API, structured output
- **Cons:** Cost per image (~$0.01-0.03), latency
- **Verdict:** Ship first, optimize later

### Option B: Fine-tuned Custom Model (e.g., ViT or CLIP)
- **Pros:** Much cheaper at scale, faster inference, own the IP
- **Cons:** Need training data (1000+ labeled images), ML expertise, ongoing maintenance
- **Verdict:** Phase 2 optimization once we have user photos

### Option C: Google Gemini Vision
- **Pros:** Cheap, good multimodal, generous free tier
- **Cons:** Less consistent than GPT-4o for structured analysis

## Infrastructure
- **Hosting:** Vercel (landing page), Supabase (backend)
- **CI/CD:** GitHub Actions
- **Analytics:** Mixpanel or PostHog
- **Payments:** RevenueCat (in-app subscriptions)
- **Push notifications:** Expo Notifications + OneSignal
- **Image storage:** Supabase Storage or Cloudflare R2

## Recommended Stack Summary
| Layer | Choice |
|---|---|
| Mobile | React Native (Expo) |
| Backend | Supabase |
| AI Vision | GPT-4o (MVP) → Custom model (scale) |
| Payments | RevenueCat |
| Hosting | Vercel + Supabase |
