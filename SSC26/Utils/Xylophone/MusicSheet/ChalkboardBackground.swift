import SwiftUI

struct ChalkboardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.08, blue: 0.09),
                        Color(red: 0.06, green: 0.06, blue: 0.07),
                        Color(red: 0.07, green: 0.07, blue: 0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                // Main chalk texture
                ZStack {
                    
                    // Chalk dust residue - scattered white spots
                    ChalkDustOverlay()
                    
                    // Grainy texture
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .blendMode(.overlay)
                    
                    // Chalk dust on all edges
                    // Bottom edge
                    VStack {
                        Spacer()
                        ChalkDustBottomEdge()
                            .frame(height: 7)
                    }
                    
                    // Top edge
                    VStack {
                        ChalkDustTopEdge()
                            .frame(height: 7)
                        Spacer()
                    }
                    
                    // Left edge
                    HStack {
                        ChalkDustLeftEdge()
                            .frame(width: 7)
                        Spacer()
                    }
                    
                    // Right edge
                    HStack {
                        Spacer()
                        ChalkDustRightEdge()
                            .frame(width: 7)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            )
            .overlay(
                // Inner border slightly lighter (wear)
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .padding(20)
            .overlay(
                // Chalk tray with eraser
                VStack {
                    Spacer()
                    ChalkboardTray()
                        .offset(y: 15)
                }
            )
            .background(
                // Wooden frame
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.5, green: 0.32, blue: 0.14),
                                Color(red: 0.45, green: 0.28, blue: 0.12),
                                Color(red: 0.38, green: 0.24, blue: 0.11)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        // Wood texture
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.black.opacity(0.1), .clear, Color.black.opacity(0.05)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.black.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 10)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            )
    }
}

// Overlay to simulate chalk dust residue
struct ChalkDustOverlay: View {
    var body: some View {
        Canvas { context, size in
            // Create random chalk dust spots
            let dustSpots = [
                (x: size.width * 0.15, y: size.height * 0.25, radius: 80.0, opacity: 0.05),
                (x: size.width * 0.65, y: size.height * 0.15, radius: 100.0, opacity: 0.05),
                (x: size.width * 0.45, y: size.height * 0.5, radius: 120.0, opacity: 0.05),
                (x: size.width * 0.8, y: size.height * 0.7, radius: 90.0, opacity: 0.05),
                (x: size.width * 0.25, y: size.height * 0.8, radius: 110.0, opacity: 0.05),
                (x: size.width * 0.5, y: size.height * 0.35, radius: 70.0, opacity: 0.05),
                (x: size.width * 0.9, y: size.height * 0.4, radius: 85.0, opacity: 0.05),
            ]
            
            for spot in dustSpots {
                let gradient = Gradient(colors: [
                    Color.white.opacity(spot.opacity),
                    Color.white.opacity(spot.opacity * 0.1),
                    .clear
                ])
                let radialGradient = GraphicsContext.Shading.radialGradient(
                    gradient,
                    center: CGPoint(x: spot.x, y: spot.y),
                    startRadius: 0,
                    endRadius: spot.radius
                )
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: spot.x - spot.radius,
                        y: spot.y - spot.radius,
                        width: spot.radius * 2,
                        height: spot.radius * 2
                    )),
                    with: radialGradient
                )
            }
        }
    }
}

// Vertical smudges simulating erasing marks
struct ChalkStreaks: View {
    var body: some View {
        Canvas { context, size in
            let streaks = [
                (x: size.width * 0.2, width: 40.0, height: size.height * 0.6, y: size.height * 0.1),
                (x: size.width * 0.5, width: 60.0, height: size.height * 0.8, y: size.height * 0.05),
                (x: size.width * 0.75, width: 35.0, height: size.height * 0.5, y: size.height * 0.3),
            ]
            
            for streak in streaks {
                let gradient = Gradient(colors: [
                    .clear,
                    Color.white.opacity(0.015),
                    Color.white.opacity(0.025),
                    Color.white.opacity(0.015),
                    .clear
                ])
                let linearGradient = GraphicsContext.Shading.linearGradient(
                    gradient,
                    startPoint: CGPoint(x: streak.x - streak.width / 2, y: streak.y),
                    endPoint: CGPoint(x: streak.x + streak.width / 2, y: streak.y)
                )
                
                context.fill(
                    Path(roundedRect: CGRect(
                        x: streak.x - streak.width / 2,
                        y: streak.y,
                        width: streak.width,
                        height: streak.height
                    ), cornerRadius: streak.width / 2),
                    with: linearGradient
                )
            }
        }
    }
}

// Chalk dust residue on bottom edge
struct ChalkDustBottomEdge: View {
    var body: some View {
        Canvas { context, size in
            // Main dust gradient
            let mainDustGradient = Gradient(colors: [
                .clear,
                Color.white.opacity(0.15),
                Color.white.opacity(0.12),
                Color.white.opacity(0.06),
            ])
            
            let mainShading = GraphicsContext.Shading.linearGradient(
                mainDustGradient,
                startPoint: CGPoint(x: size.width / 2, y: 0),
                endPoint: CGPoint(x: size.width / 2, y: size.height)
            )
            
            context.fill(
                Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)),
                with: mainShading
            )
            
            // Denser dust clumps
            let denseSpots = [
                (x: size.width * 0.3, radius: 40.0, opacity: 0.1),
                (x: size.width * 0.5, radius: 50.0, opacity: 0.12),
                (x: size.width * 0.7, radius: 35.0, opacity: 0.08),
                (x: size.width * 0.15, radius: 30.0, opacity: 0.06),
                (x: size.width * 0.85, radius: 28.0, opacity: 0.07),
            ]
            
            for spot in denseSpots {
                let spotGradient = Gradient(colors: [
                    Color.white.opacity(spot.opacity),
                    Color.white.opacity(spot.opacity * 0.5),
                    .clear
                ])
                let radialGradient = GraphicsContext.Shading.radialGradient(
                    spotGradient,
                    center: CGPoint(x: spot.x, y: size.height * 0.6),
                    startRadius: 0,
                    endRadius: spot.radius
                )
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: spot.x - spot.radius,
                        y: size.height * 0.6 - spot.radius,
                        width: spot.radius * 2,
                        height: spot.radius * 2
                    )),
                    with: radialGradient
                )
            }
        }
    }
}

// Chalk dust residue on top edge
struct ChalkDustTopEdge: View {
    var body: some View {
        Canvas { context, size in
            // Main dust gradient (reversed for top)
            let mainDustGradient = Gradient(colors: [
                Color.white.opacity(0.06),
                Color.white.opacity(0.10),
                Color.white.opacity(0.06),
                .clear,
            ])
            
            let mainShading = GraphicsContext.Shading.linearGradient(
                mainDustGradient,
                startPoint: CGPoint(x: size.width / 2, y: size.height),
                endPoint: CGPoint(x: size.width / 2, y: 0)
            )
            
            context.fill(
                Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)),
                with: mainShading
            )
            
            // Denser dust clumps
            let denseSpots = [
                (x: size.width * 0.25, radius: 35.0, opacity: 0.08),
                (x: size.width * 0.55, radius: 40.0, opacity: 0.09),
                (x: size.width * 0.8, radius: 30.0, opacity: 0.07),
            ]
            
            for spot in denseSpots {
                let spotGradient = Gradient(colors: [
                    Color.white.opacity(spot.opacity),
                    Color.white.opacity(spot.opacity * 0.5),
                    .clear
                ])
                let radialGradient = GraphicsContext.Shading.radialGradient(
                    spotGradient,
                    center: CGPoint(x: spot.x, y: size.height * 0.4),
                    startRadius: 0,
                    endRadius: spot.radius
                )
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: spot.x - spot.radius,
                        y: size.height * 0.4 - spot.radius,
                        width: spot.radius * 2,
                        height: spot.radius * 2
                    )),
                    with: radialGradient
                )
            }
        }
    }
}

// Chalk dust residue on left edge
struct ChalkDustLeftEdge: View {
    var body: some View {
        Canvas { context, size in
            // Main dust gradient
            let mainDustGradient = Gradient(colors: [
                .clear,
                Color.white.opacity(0.06),
                Color.white.opacity(0.09),
                Color.white.opacity(0.05),
            ])
            
            let mainShading = GraphicsContext.Shading.linearGradient(
                mainDustGradient,
                startPoint: CGPoint(x: 0, y: size.height / 2),
                endPoint: CGPoint(x: size.width, y: size.height / 2)
            )
            
            context.fill(
                Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)),
                with: mainShading
            )
            
            // Denser dust clumps
            let denseSpots = [
                (y: size.height * 0.3, radius: 30.0, opacity: 0.07),
                (y: size.height * 0.6, radius: 35.0, opacity: 0.08),
                (y: size.height * 0.85, radius: 25.0, opacity: 0.06),
            ]
            
            for spot in denseSpots {
                let spotGradient = Gradient(colors: [
                    Color.white.opacity(spot.opacity),
                    Color.white.opacity(spot.opacity * 0.5),
                    .clear
                ])
                let radialGradient = GraphicsContext.Shading.radialGradient(
                    spotGradient,
                    center: CGPoint(x: size.width * 0.5, y: spot.y),
                    startRadius: 0,
                    endRadius: spot.radius
                )
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.5 - spot.radius,
                        y: spot.y - spot.radius,
                        width: spot.radius * 2,
                        height: spot.radius * 2
                    )),
                    with: radialGradient
                )
            }
        }
    }
}

// Chalk dust residue on right edge
struct ChalkDustRightEdge: View {
    var body: some View {
        Canvas { context, size in
            // Main dust gradient
            let mainDustGradient = Gradient(colors: [
                Color.white.opacity(0.05),
                Color.white.opacity(0.09),
                Color.white.opacity(0.06),
                .clear,
            ])
            
            let mainShading = GraphicsContext.Shading.linearGradient(
                mainDustGradient,
                startPoint: CGPoint(x: size.width, y: size.height / 2),
                endPoint: CGPoint(x: 0, y: size.height / 2)
            )
            
            context.fill(
                Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)),
                with: mainShading
            )
            
            // Denser dust clumps
            let denseSpots = [
                (y: size.height * 0.25, radius: 28.0, opacity: 0.07),
                (y: size.height * 0.55, radius: 33.0, opacity: 0.08),
                (y: size.height * 0.8, radius: 26.0, opacity: 0.06),
            ]
            
            for spot in denseSpots {
                let spotGradient = Gradient(colors: [
                    Color.white.opacity(spot.opacity),
                    Color.white.opacity(spot.opacity * 0.5),
                    .clear
                ])
                let radialGradient = GraphicsContext.Shading.radialGradient(
                    spotGradient,
                    center: CGPoint(x: size.width * 0.5, y: spot.y),
                    startRadius: 0,
                    endRadius: spot.radius
                )
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: size.width * 0.5 - spot.radius,
                        y: spot.y - spot.radius,
                        width: spot.radius * 2,
                        height: spot.radius * 2
                    )),
                    with: radialGradient
                )
            }
        }
    }
}

// Wooden chalk tray with eraser
struct ChalkboardTray: View {
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            // Chalk tray
            ZStack {
                // Tray base
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.52, green: 0.34, blue: 0.16),
                                Color(red: 0.45, green: 0.28, blue: 0.12),
                                Color(red: 0.40, green: 0.26, blue: 0.11)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 600, height: 24)
                    .overlay(
                        // Inner shadow
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
                
                HStack(spacing: 10) {
                    Spacer()

                    // Chalk pieces
                    ZStack(alignment: .leading) {
                        Capsule(style: .continuous)
                            .fill(Color.white)
                            .frame(width: 40, height: 8)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                            .rotationEffect(.degrees(-4))
                            .offset(y: -4)

                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.95))
                            .frame(width: 30, height: 8)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                            .rotationEffect(.degrees(4))
                            .offset(x: -50, y: -3)
                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.95))
                            .frame(width: 35, height: 8)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                            .rotationEffect(.degrees(2))
                            .offset(x: 130, y: -3)
                    }

                    // Eraser
                    ChalkEraser()
                        .offset(y: -10)

                    Spacer()
                }
                .frame(width: 260)
            }
            
            Spacer()
        }
    }
}

// Chalk eraser
struct ChalkEraser: View {
    var body: some View {
        ZStack {
            // Eraser body
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.75, blue: 0.60),
                            Color(red: 0.75, green: 0.65, blue: 0.50),
                            Color(red: 0.70, green: 0.60, blue: 0.45)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 60, height: 28)
                .overlay(
                    // Dark border
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 3)
            
            // Felt part (bottom) dirty with chalk
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.35, green: 0.35, blue: 0.40),
                                Color(red: 0.45, green: 0.45, blue: 0.50)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 60, height: 8)
                    .overlay(
                        // Chalk residue on felt
                        Rectangle()
                            .fill(Color.white.opacity(0.4))
                            .blendMode(.overlay)
                    )
            }
            .frame(width: 60, height: 28)
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            
            // Separation lines on body
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.black.opacity(0.15))
                    .frame(width: 60, height: 0.5)
                    .offset(y: -6)
                
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 0.5)
                    .offset(y: -5.5)
            }
            .frame(width: 60, height: 28)
        }
    }
}

#Preview {
    ChalkboardBackground().frame(width: 650, height: 300)
}
