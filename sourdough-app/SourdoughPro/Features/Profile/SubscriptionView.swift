import SwiftUI

struct SubscriptionView: View {
    @Environment(\.services) private var services
    @EnvironmentObject private var appState: AppState
    @State private var showPaywall = false

    var tier: SubscriptionTier { appState.user?.subscriptionTier ?? .free }

    var body: some View {
        ScrollView {
            VStack(spacing: SDSpace.s6) {

                // Current plan card
                SDCard(variant: .elevated) {
                    VStack(alignment: .leading, spacing: SDSpace.s4) {
                        HStack {
                            VStack(alignment: .leading, spacing: SDSpace.s1) {
                                Text("Current Plan")
                                    .font(SDFont.labelMedium)
                                    .foregroundStyle(SDColor.textSecondary)
                                Text(tier.displayName)
                                    .font(SDFont.headingMedium)
                                    .foregroundStyle(SDColor.textPrimary)
                            }
                            Spacer()
                            tierBadge
                        }
                        if tier == .free {
                            SDButton(title: "Upgrade to Pro") { showPaywall = true }
                        }
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)

                // AI scans remaining (free only)
                if tier == .free, let user = appState.user {
                    SDCard {
                        HStack {
                            VStack(alignment: .leading, spacing: SDSpace.s1) {
                                Text("AI Scans Remaining")
                                    .font(SDFont.labelMedium)
                                    .foregroundStyle(SDColor.textPrimary)
                                Text("Resets monthly")
                                    .font(SDFont.captionSmall)
                                    .foregroundStyle(SDColor.textSecondary)
                            }
                            Spacer()
                            Text("\(user.aiScansRemaining)")
                                .font(SDFont.numberMedium)
                                .foregroundStyle(user.aiScansRemaining > 0 ? SDColor.textPrimary : SDColor.error)
                        }
                    }
                    .padding(.horizontal, SDSpace.screenMargin)
                }

                // Feature comparison table
                featureTable
                    .padding(.horizontal, SDSpace.screenMargin)

                // Manage button (paid users)
                if tier != .free {
                    Button("Manage Subscription") {
                        if let url = services.subscriptions.manageSubscription() {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(SDFont.labelMedium)
                    .foregroundStyle(SDColor.textLink)
                }
            }
            .padding(.vertical, SDSpace.s4)
        }
        .sdBackground()
        .navigationTitle("Subscription")
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var tierBadge: some View {
        let color: Color = {
            switch tier {
            case .free:  return SDColor.border
            case .pro:   return SDColor.info
            case .baker: return SDColor.accent
            }
        }()
        return Text(tier.displayName)
            .font(SDFont.labelSmall)
            .foregroundStyle(.white)
            .padding(.horizontal, SDSpace.s3)
            .padding(.vertical, SDSpace.s1)
            .background(color)
            .clipShape(Capsule())
    }

    private var featureTable: some View {
        SDCard {
            VStack(spacing: 0) {
                featureRow(feature: "Starter tracking",    free: true,  pro: true,  baker: true)
                Divider()
                featureRow(feature: "Recipe library",      free: true,  pro: true,  baker: true)
                Divider()
                featureRow(feature: "Bake timer",          free: true,  pro: true,  baker: true)
                Divider()
                featureRow(feature: "AI scans",            free: "3/mo", pro: "∞",  baker: "∞")
                Divider()
                featureRow(feature: "Premium recipes",     free: false, pro: true,  baker: true)
                Divider()
                featureRow(feature: "Smart reminders",     free: false, pro: true,  baker: true)
                Divider()
                featureRow(feature: "Bake analytics",      free: false, pro: true,  baker: true)
            }
        }
    }

    private func featureRow(feature: String, free: Any, pro: Any, baker: Any) -> some View {
        HStack {
            Text(feature)
                .font(SDFont.captionMedium)
                .foregroundStyle(SDColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            featureCell(free)
            featureCell(pro)
            featureCell(baker)
        }
        .padding(.vertical, SDSpace.s3)
    }

    private func featureCell(_ value: Any) -> some View {
        Group {
            if let boolVal = value as? Bool {
                Image(systemName: boolVal ? "checkmark" : "minus")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(boolVal ? SDColor.success : SDColor.border)
            } else if let strVal = value as? String {
                Text(strVal)
                    .font(SDFont.captionMedium)
                    .foregroundStyle(SDColor.textSecondary)
            }
        }
        .frame(width: 48)
    }
}

#Preview {
    NavigationStack { SubscriptionView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
