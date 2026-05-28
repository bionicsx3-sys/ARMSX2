import SwiftUI
import MetalKit

struct ContentView: View {
    @State private var showFilePicker = false
    @State private var selectedGamePath: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.tint)

                Text("ARMSX2")
                    .font(.largeTitle.bold())

                Text("PS2 Emulator for iOS")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let path = selectedGamePath {
                    Text("Selected: \(URL(fileURLWithPath: path).lastPathComponent)")
                        .font(.caption)
                        .padding()

                    Button("Start Emulation") {
                        startEmulation(path: path)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Button("Select Game") {
                    showFilePicker = true
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("ARMSX2")
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.data]) { result in
                switch result {
                case .success(let url):
                    selectedGamePath = url.path
                case .failure(let error):
                    print("File selection error: \(error)")
                }
            }
        }
    }

    private func startEmulation(path: String) {
        print("Starting emulation with: \(path)")
    }
}

#Preview {
    ContentView()
}
