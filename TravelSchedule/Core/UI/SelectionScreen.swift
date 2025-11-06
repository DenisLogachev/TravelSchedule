import SwiftUI

struct SelectionScreen<Content: View>: View {
    
    let title: String
    @ViewBuilder let content: () -> Content
    let onDismiss: (() -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    init(title: String, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.onDismiss = onDismiss
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    if let onDismiss = onDismiss {
                        onDismiss()
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(width: 24)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            content()
        }
        .background(DS.surface.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

