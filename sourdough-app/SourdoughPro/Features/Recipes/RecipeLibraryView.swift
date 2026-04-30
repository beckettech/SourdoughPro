import SwiftUI

@MainActor
final class RecipeLibraryViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var selectedDifficulty: Difficulty? = nil
    @Published var selectedFlourType: FlourType? = nil

    var filtered: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty
                || recipe.name.localizedCaseInsensitiveContains(searchText)
                || recipe.summary.localizedCaseInsensitiveContains(searchText)
                || recipe.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            let matchesDiff  = selectedDifficulty == nil || recipe.difficulty == selectedDifficulty
            let matchesFlour = selectedFlourType == nil   || recipe.flourType == selectedFlourType
            return matchesSearch && matchesDiff && matchesFlour
        }
        .sorted { $0.difficulty < $1.difficulty }
    }

    func load(services: ServiceContainer) async {
        isLoading = true
        defer { isLoading = false }
        recipes = (try? await services.recipes.listRecipes(includePremium: true)) ?? []
    }
}

struct RecipeLibraryView: View {
    @Environment(\.services) private var services
    @StateObject private var vm = RecipeLibraryViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack(spacing: SDSpace.s3) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(SDColor.textSecondary)
                TextField("Search recipes…", text: $vm.searchText)
                    .font(SDFont.bodyMedium)
                if !vm.searchText.isEmpty {
                    Button { vm.searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(SDColor.textTertiary)
                    }
                }
            }
            .padding(SDSpace.s3)
            .background(SDColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: SDRadius.md))
            .padding(.horizontal, SDSpace.screenMargin)
            .padding(.vertical, SDSpace.s3)

            // Filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SDSpace.s2) {
                    filterChip(label: "All", selected: vm.selectedDifficulty == nil && vm.selectedFlourType == nil) {
                        vm.selectedDifficulty = nil
                        vm.selectedFlourType  = nil
                    }
                    ForEach(Difficulty.allCases) { diff in
                        filterChip(label: diff.displayName, selected: vm.selectedDifficulty == diff) {
                            vm.selectedDifficulty = vm.selectedDifficulty == diff ? nil : diff
                        }
                    }
                }
                .padding(.horizontal, SDSpace.screenMargin)
            }
            .padding(.bottom, SDSpace.s2)

            // Recipe list
            if vm.isLoading && vm.recipes.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.filtered.isEmpty {
                VStack(spacing: SDSpace.s3) {
                    Spacer()
                    Image(systemName: SDIcon.bookshelf)
                        .font(.system(size: 48))
                        .foregroundStyle(SDColor.border)
                    if vm.searchText.isEmpty {
                        Text("No recipes yet")
                            .font(SDFont.headingSmall)
                            .foregroundStyle(SDColor.textSecondary)
                    } else {
                        Text("Nothing matched")
                            .font(SDFont.headingSmall)
                            .foregroundStyle(SDColor.textSecondary)
                        Text("Try a different search or clear the filters.")
                            .font(SDFont.bodySmall)
                            .foregroundStyle(SDColor.textTertiary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, SDSpace.screenMargin)
                        Button {
                            vm.searchText = ""
                            vm.selectedDifficulty = nil
                            vm.selectedFlourType = nil
                        } label: {
                            Text("Clear search")
                                .font(SDFont.labelSmall)
                                .foregroundStyle(SDColor.primary)
                        }
                    }
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.filtered) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeRow(recipe: recipe)
                                    .padding(.horizontal, SDSpace.screenMargin)
                            }
                            .buttonStyle(.plain)
                            if recipe.id != vm.filtered.last?.id {
                                Divider()
                                    .padding(.leading, SDSpace.screenMargin + 64 + SDSpace.s4)
                            }
                        }
                    }
                    .background(SDColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
                    .padding(.horizontal, SDSpace.screenMargin)
                    .padding(.bottom, SDSpace.s4)
                }
            }
        }
        .sdBackground()
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load(services: services) }
        .refreshable { await vm.load(services: services) }
    }

    private func filterChip(label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(SDFont.labelSmall)
                .foregroundStyle(selected ? SDColor.textInverted : SDColor.textPrimary)
                .padding(.horizontal, SDSpace.s4)
                .padding(.vertical, SDSpace.s2)
                .background(selected ? SDColor.primary : SDColor.surface)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(selected ? SDColor.primary : SDColor.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack { RecipeLibraryView() }
        .environmentObject(AppState(services: .preview()))
        .environment(\.services, .preview())
}
