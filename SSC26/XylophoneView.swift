import SwiftUI

struct XylophoneView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Xylophone")
                .font(.largeTitle)
                .bold()
            Text("This is where your interactive xylophone will appear!")
                .foregroundStyle(.secondary)
                .padding()
            Rectangle()
                .fill(.blue)
                .frame(height: 40)
                .cornerRadius(8)
                .padding(.horizontal, 40)
            Rectangle()
                .fill(.green)
                .frame(height: 40)
                .cornerRadius(8)
                .padding(.horizontal, 50)
            Rectangle()
                .fill(.orange)
                .frame(height: 40)
                .cornerRadius(8)
                .padding(.horizontal, 60)
        }
        .navigationTitle("Free Play")
    }
}

#Preview {
    XylophoneView()
}
