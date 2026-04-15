import SwiftUI

/// List item per FIGMA_SPECS.md §Components > List Item.
struct SDListItem<Leading: View, Trailing: View>: View {

    let title: String
    var subtitle: String? = nil
    var subtitle2: String? = nil
    @ViewBuilder let leading: () -> Leading
    @ViewBuilder let trailing: () -> Trailing
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: SDSpace.s3) {
                leading()
                VStack(alignment: .leading, spacing: SDSpace.s1) {
                    Text(title).font(SDFont.bodyLarge).foregroundStyle(SDColor.textPrimary)
                    if let subtitle {
                        Text(subtitle).font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
                    }
                    if let subtitle2 {
                        Text(subtitle2).font(SDFont.captionMedium).foregroundStyle(SDColor.textSecondary)
                    }
                }
                Spacer(minLength: 0)
                trailing()
            }
            .padding(.horizontal, SDSpace.s4)
            .frame(minHeight: 56)
            .padding(.vertical, SDSpace.s2)
            .background(SDColor.surface)
        }
        .buttonStyle(PressableListStyle())
        .disabled(onTap == nil)
    }
}

extension SDListItem where Leading == EmptyView, Trailing == EmptyView {
    init(title: String, subtitle: String? = nil, subtitle2: String? = nil, onTap: (() -> Void)? = nil) {
        self.init(title: title, subtitle: subtitle, subtitle2: subtitle2,
                  leading: { EmptyView() }, trailing: { EmptyView() }, onTap: onTap)
    }
}

extension SDListItem where Leading == EmptyView {
    init(title: String, subtitle: String? = nil, subtitle2: String? = nil,
         @ViewBuilder trailing: @escaping () -> Trailing, onTap: (() -> Void)? = nil) {
        self.init(title: title, subtitle: subtitle, subtitle2: subtitle2,
                  leading: { EmptyView() }, trailing: trailing, onTap: onTap)
    }
}

extension SDListItem where Trailing == EmptyView {
    init(title: String, subtitle: String? = nil, subtitle2: String? = nil,
         @ViewBuilder leading: @escaping () -> Leading, onTap: (() -> Void)? = nil) {
        self.init(title: title, subtitle: subtitle, subtitle2: subtitle2,
                  leading: leading, trailing: { EmptyView() }, onTap: onTap)
    }
}

private struct PressableListStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? SDColor.overlayLight : .clear)
            .animation(nil, value: configuration.isPressed)
    }
}

#Preview("SDListItem") {
    VStack(spacing: 0) {
        SDListItem(title: "Created", trailing: { Text("Jan 15, 2026").font(SDFont.bodyMedium).foregroundStyle(SDColor.textSecondary) })
        Divider().padding(.leading, SDSpace.s4)
        SDListItem(title: "Flour", trailing: { Text("Bread flour").font(SDFont.bodyMedium).foregroundStyle(SDColor.textSecondary) })
        Divider().padding(.leading, SDSpace.s4)
        SDListItem(title: "Good bubble activity", leading: {
            Image(systemName: SDIcon.checkmarkCircle).foregroundStyle(SDColor.success).font(.system(size: 24))
        })
    }
    .background(SDColor.surface)
    .clipShape(RoundedRectangle(cornerRadius: SDRadius.lg))
    .padding()
    .background(SDColor.background)
}
