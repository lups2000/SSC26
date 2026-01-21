import SwiftUI

struct StaffLinesView: View {
    let lineSpacing: CGFloat

    var body: some View {
        VStack(spacing: lineSpacing) {
            ForEach(0..<5) { _ in
                Capsule()
                    .fill(Color.white.opacity(0.9))
                    .frame(height: 2)
                    .shadow(color: .white.opacity(0.08), radius: 0.5, x: 0, y: 0.5)
            }
        }
    }
}
