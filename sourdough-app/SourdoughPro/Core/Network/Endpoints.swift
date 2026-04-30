import Foundation

/// Supabase REST endpoints per DEV_SPEC.md §6. URLs resolve against
/// `Environment.supabaseURL`; real implementations add the anon key and
/// JWT headers via `APIClient`.
enum Endpoint {

    case signUp
    case signIn
    case refresh
    case signOut
    case me

    case starters
    case starter(UUID)
    case feedings(starterId: UUID)

    case recipes
    case recipe(UUID)

    case bakeSessions
    case bakeSession(UUID)
    case completeStep(sessionId: UUID)

    case analyzeStarter
    case analyzeCrumb

    case starterPhoto(userId: UUID, starterId: UUID, timestamp: Int)
    case bakePhoto(userId: UUID, sessionId: UUID, timestamp: Int)

    var path: String {
        switch self {
        case .signUp:                           return "/auth/v1/signup"
        case .signIn:                           return "/auth/v1/token?grant_type=password"
        case .refresh:                          return "/auth/v1/token?grant_type=refresh_token"
        case .signOut:                          return "/auth/v1/logout"
        case .me:                               return "/auth/v1/user"

        case .starters:                         return "/rest/v1/starters"
        case .starter(let id):                  return "/rest/v1/starters?id=eq.\(id)"
        case .feedings(let id):                 return "/rest/v1/feedings?starter_id=eq.\(id)"

        case .recipes:                          return "/rest/v1/recipes"
        case .recipe(let id):                   return "/rest/v1/recipes?id=eq.\(id)"

        case .bakeSessions:                     return "/rest/v1/bake_sessions"
        case .bakeSession(let id):              return "/rest/v1/bake_sessions?id=eq.\(id)"
        case .completeStep(let id):             return "/rest/v1/bake_sessions/\(id)/complete_step"

        case .analyzeStarter:                   return "/functions/v1/analyze-starter"
        case .analyzeCrumb:                     return "/functions/v1/analyze-crumb"

        case .starterPhoto(let u, let s, let t):return "/storage/v1/object/starter-photos/\(u)/\(s)/\(t).jpg"
        case .bakePhoto(let u, let s, let t):   return "/storage/v1/object/bake-photos/\(u)/\(s)/\(t).jpg"
        }
    }
}
