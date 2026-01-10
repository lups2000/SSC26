import SwiftUI

struct XylophoneView: View {
    var body: some View {
        ZStack {
            BackgroundGradient()
            HStack(spacing: 10) {
                XylophoneTile(note: "C", color: .red, height: 580)
                XylophoneTile(note: "D", color: .orange, height: 540)
                XylophoneTile(note: "E", color: .yellow, height: 500)
                XylophoneTile(note: "F", color: .green, height: 460)
                XylophoneTile(note: "G", color: .teal, height: 420)
                XylophoneTile(note: "A", color: .blue, height: 380)
                XylophoneTile(note: "B", color: .indigo, height: 340)
                XylophoneTile(note: "C", color: .purple, height: 300)
            }
        }
        .navigationTitle("Free Play")
    }
}

#Preview {
    XylophoneView()
}
