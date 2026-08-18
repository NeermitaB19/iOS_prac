//
//  Render.swift
//  SwiftUIBasics
//
//  Created by neermita.bhattacharya@wbd.com on 14/08/26.
//

import SwiftUI

struct RenderCounterView: View {
    @State private var count = 0
    
    // Using a stored property to keep a running count of body evaluations
    private var renderCount: Int {
        print("View body was evaluated/rendered!")
        return 1
    }

    var body: some View {
        // This line forces the evaluation tracking every time body runs
        let _ = Self._printChanges()
        let _ = renderCount
        
        
        VStack(spacing: 20) {
            Text("Render Counter Demo")
                .font(.title)
                .bold()
            
            Text("State Count: \(count)")
                .font(.headline)
            
            Button("Increment State (Triggers Re-render)") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// Preview to run it directly in Xcode
#Preview {
    RenderCounterView()
}

// EnvironmentObject is a property wrapper in SwiftUI used to share data across multiple views anywhere in your view hierarchy without manually passing it down through every initializer.
/*
 Source of Truth (@StateObject or ObservableObject): You create the data object once at a high level in your app.

 The Injector (.environmentObject(...)): You attach that object to a parent view, making it available to all views nested inside it.

 The Receiver (@EnvironmentObject): Any child view down the line can grab that object using @EnvironmentObject and use its properties or trigger methods.
 */
