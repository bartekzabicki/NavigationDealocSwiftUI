//
//  ContentView.swift
//  NavTest
//
//  Created by Bart on 01/05/2023.
//

import SwiftUI

enum Routes: String {
    case testView
}

struct ContentView: View {
    
    @StateObject var authDataStore = AuthDataStore()
    
    var body: some View {
        if authDataStore.isLoggedIn {
            TestModuleView(authDataStore: authDataStore)
        } else {
            Text("Auth module")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TestModuleView: View {
    
    @StateObject var testObserver = TestObserver()
    @ObservedObject var authDataStore: AuthDataStore
    @State var blockingState = ""
    
    var body: some View {
        NavigationSplitView {
            NavigationStack() {
                TestView(isTestModuleDisplayed: $authDataStore.isLoggedIn, testObserver: testObserver)
                    .padding()
                    .navigationDestination(for: String.self) { value in
                        // Not working
                        // Using reference to any of view's properties causes issues with deallocation of `TestObserver`
//                        let _ = print("blockingState: \(blockingState)")
//                        let _ = print("testObserver: \(testObserver)")
                        Text("Not important view")
                    }
            }
        } detail: {
            Text("Detail")
        }
    }
    
}


struct TestView: View {
    
    @Binding var isTestModuleDisplayed: Bool
    var testObserver: TestObserver
    
    var body: some View {
        VStack {
            Text("Logged in view")
            Button("Go back") {
                isTestModuleDisplayed = false
            }
        }
    }
    
}

final class AuthDataStore: ObservableObject {
    
    @Published var isLoggedIn = true
    
}

final class TestObserver: ObservableObject {
    
    init() {
        print("Init TestObserver")
    }
    
    deinit {
        print("Deinit TestObserver")
    }
    
}
