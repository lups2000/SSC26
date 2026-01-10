import SwiftUI

struct XylophoneTile: View {
    var note: String
    var color: Color
    var height: CGFloat
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            Rectangle()
                .fill(color)
                .frame(height: height)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 20, height: 20)
                            .padding(.top, 20)
                        Spacer()
                        Text(note)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        Spacer()
                        Circle()
                            .fill(Color.black)
                            .frame(width: 20, height: 20)
                            .padding(.bottom, 20)
                    }
                )
                .padding(.horizontal, 16)
                .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    XylophoneTile(note: "C", color: .red, height: 100)
}
