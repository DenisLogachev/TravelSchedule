import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                do {
                    let tester = try ServicesTester()
                    await tester.testAll()
                } catch {
                    print("Init error: \(error)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
