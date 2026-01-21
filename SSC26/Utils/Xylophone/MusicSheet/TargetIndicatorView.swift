import SwiftUI

struct TargetIndicatorView : View {
    let color: Color
    @Binding var shakeTrigger: CGFloat
    let isCorrect: Bool

    var body: some View {
        Rectangle()
            .fill(color)
            .opacity(0.5)
            .cornerRadius(15)
            .frame(width: 50, height: 80)
            .modifier(ShakeEffect(animatableData: shakeTrigger))
            .onAppear {
                if !isCorrect {
                    withAnimation(.linear(duration: 0.4).repeatCount(1, autoreverses: false)) {
                        shakeTrigger += 1
                    }
                }
            }
            .onChange(of: isCorrect) { _, isC in
                if !isC {
                    withAnimation(.linear(duration: 0.4).repeatCount(1, autoreverses: false)) {
                        shakeTrigger += 1
                    }
                }
            }
    }
}
