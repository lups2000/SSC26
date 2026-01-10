//
//  ContentView.swift
//  SSC26
//
//  Created by matteo luppi on 10/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var hasStarted = false
    
    var body: some View {
        if !hasStarted {
            WelcomeView(startAction: {
                hasStarted = true
            })
        } else {
            NavigationSplitView {
                List {
                    NavigationLink("About", destination: AboutView())
                    NavigationLink("Tutorial", destination: TutorialView())
                    NavigationLink("Free Play", destination: XylophoneView())
                }
                .navigationTitle("XyloFingers")
            } detail: {
                Text("Select a section")
            }
        }
    }
}

#Preview {
    ContentView()
}
