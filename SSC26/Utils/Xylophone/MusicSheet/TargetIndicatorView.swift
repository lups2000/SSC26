import SwiftUI

struct TargetIndicatorView : View {
    let color: Color
    @Binding var shakeTrigger: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(0.5),
                        color.opacity(0.35)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(color.opacity(0.6), lineWidth: 2)
            )
            .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 0)
            .frame(width: 50, height: 85)
            .modifier(ShakeEffect(animatableData: shakeTrigger))
    }
}
