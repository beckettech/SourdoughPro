import SwiftUI

@MainActor
final class PaywallViewModel: ObservableObject {
    @Published var offerings: [SubscriptionOffering] = []
    @Published var selectedOffering: SubscriptionOffering? = nil
    @Published var isLoading = false
    @Published var isPurchasing = false
    @Published var errorMessage: String? = nil
    @Published var didPurchase = false

    func load(services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        offerings = (try? await services.subscriptions.currentOfferings()) ?? []
        // default select pro_monthly
        selectedOffering = offerings.first(where: { $0.id == "pro_monthly" }) ?? offerings.first
    }

    func purchase(services: ServiceContainer) async {
        guard let offering = selectedOffering else { return }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            _ = try await services.subscriptions.purchase(offering)
            didPurchase = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func restore(services: ServiceContainer) async {
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            _ = try await services.subscriptions.restorePurchases()
            didPurchase = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct PaywallView: View {
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = PaywallViewModel()

    private let features: [(icon: String, text: String)] = [
        ("sparkles",              "Unlimited AI starter health scans"),
        ("book.closed.fill",      "Access all premium recipes"),
        ("chart.bar.fill",        "Advanced bake analytics"),
        ("bell.fill",             "Smart feeding reminders"),
        ("arrow.counterclockwise","Bake history & comparisons"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: SDSpace.s6) {
                // Hero
                VStack(spacing: SDSpace.s3) {
                    Image(systemName: SDIcon.sparkles)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(SDColor.accent)
                    Text("Unlock Sourdough Pro")
                        .font(SDFont.displaySmall)
                        .foregroundStyle(SDColor.textPrimary)
                    Text("Take your baking to the next level")
                        .font(SDFont.bodyLarge)
                        .foregroundStyle(SDColor.textSecondary)
                }
                .padding(.top, SDSpace.s6)

                // Feature list
                VStack(alignment: .leading, spacing: SDSpace.s4) {
                    ForEach(features, id: \.text) { feature in
                        HStack(spacing: SDSpace.s4) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(SDColor.primary)
                                .frame(width: 28)
                            Text(feature.text)
                                .font(SDFont.bodyMedium)
                                .foregroundStyle(SDColor.textPrimary)
                        }
                    }
                }
                .padding(.horizontal, SDSpace.screenMarginLg)

                // Offering selector
                if vm.isLoading {
                    ProgressView()
                } else {
                    VStack(spacing: SDSpace.s3) {
                        ForEach(vm.offerings) { offering in
                            OfferingTile(
                                offering: offering,
                                isSelected: vm.selectedOffering?.id == offering.id
                            ) {
                                vm.selectedOffering = offering
                            }
                        }
                    }
                    .padding(.horizontal, SDSpace.screenMargin)
                }

                if let err = vm.errorMessage {
                    Text(err)
                        .font(SDFont.captionMedium)
                        .foregroundStyle(SDColor.error)
                        .multilineTextAlignment(.center)
                }

                // Purchase button
                SDButton(title: "Continue", isLoading: vm.isPurchasing,
                         isEnabled: vm.selectedOffering != nil) {
                    Task { await vm.purchase(services: services) }
                }
                .padding(.horizontal, SDSpace.screenMargin)

                // Restore + disclaimer
                Button("Restore Purchases") {
                    Task { await vm.restore(services: services) }
                }
                .font(SDFont.labelSmall)
                .foregroundStyle(SDColor.textLink)

                Text("Payment charged to your Apple ID. Subscriptions auto-renew. Cancel anytime in Settings.")
                    .font(SDFont.captionSmall)
                    .foregroundStyle(SDColor.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SDSpace.screenMarginLg)
                    .padding(.bottom, SDSpace.s6)
            }
        }
        .sdBackground()
        .task { await vm.load(services: services) }
        .onChange(of: vm.didPurchase) { _, purchased in
            if purchased { dismiss() }
        }
    }
}

struct OfferingTile: View {
    let offering: SubscriptionOffering
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: SDSpace.s1) {
                    HStack(spacing: SDSpace.s2) {
                        Text(offering.tier.displayName)
                            .font(SDFont.labelLarge)
                            .foregroundStyle(SDColor.textPrimary)
                        Text(offering.period == .monthly ? "/ month" : "/ year")
                            .font(SDFont.captionMedium)
                            .foregroundStyle(SDColor.textSecondary)
                    }
                    if let savings = offering.savingsLabel {
                        Text(savings)
                            .font(SDFont.captionSmall)
                            .foregroundStyle(SDColor.success)
                    }
                }
                Spacer()
                Text(offering.price)
                    .font(SDFont.labelLarge)
                    .foregroundStyle(SDColor.textPrimary)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? SDColor.primary : SDColor.border)
                    .font(.system(size: 22))
            }
            .padding(SDSpace.s4)
            .background(isSelected ? SDColor.secondaryLight : SDColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: SDRadius.md)
                    .stroke(isSelected ? SDColor.primary : SDColor.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack { PaywallView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
