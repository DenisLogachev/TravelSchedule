import SwiftUI

struct SelectionList: View {
    
    let items: [String]
    @Binding var searchText: String
    let onItemSelected: (String) -> Void
    let showChevron: Bool
    let emptyMessage: String
    
    @State private var debouncedSearchText: String = ""
    @State private var debounceTask: Task<Void, Never>?
    
    private enum Constants {
        static let rowHeight: CGFloat = 60
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let debounceDelay: TimeInterval = 0.3
    }
    
    init(
        items: [String],
        searchText: Binding<String>,
        onItemSelected: @escaping (String) -> Void,
        showChevron: Bool = false,
        emptyMessage: String = "Не найдено"
    ) {
        self.items = items
        self._searchText = searchText
        self.onItemSelected = onItemSelected
        self.showChevron = showChevron
        self.emptyMessage = emptyMessage
    }
    
    private var filtered: [String] {
        let searchLower = debouncedSearchText.lowercased()
        guard !searchLower.isEmpty else { return items }
        return items.filter { $0.lowercased().hasPrefix(searchLower) }
    }
    
    private var showEmptyMessage: Bool {
        !debouncedSearchText.isEmpty && filtered.isEmpty
    }
    
    @ViewBuilder
    private func rowContent(for item: String) -> some View {
        if showChevron {
            HStack {
                Text(item)
                    .padding(.leading, 16)
                Spacer()
                Image(systemName: "chevron.right")
                    .padding(.trailing, 16)
            }
        } else {
            Text(item)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $searchText)
                .padding([.horizontal, .top], Constants.horizontalPadding)
            
            ZStack {
                DS.surface.ignoresSafeArea()
                
                if showEmptyMessage {
                    Text(emptyMessage)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, Constants.topPadding)
                } else {
                    List(filtered, id: \.self) { item in
                        Button {
                            onItemSelected(item)
                        } label: {
                            rowContent(for: item)
                                .frame(maxWidth: .infinity, minHeight: Constants.rowHeight)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init())
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.top, Constants.topPadding)
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            debounceTask?.cancel()
            debounceTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(Constants.debounceDelay * 1_000_000_000))
                if !Task.isCancelled {
                    debouncedSearchText = newValue
                }
            }
        }
        .onAppear {
            debouncedSearchText = searchText
        }
        .onDisappear {
            debounceTask?.cancel()
        }
    }
}

