import SwiftUI
import SwiftData

// MARK: - Struktur Data Sesi Padel
// MARK: - Struktur Data Sesi Padel
struct PadelSession: Identifiable {
    let id = UUID()
    let courtName: String
    let dateString: String
    let date: Date
    let matches: [Match]
    
    var winsCount: Int {
        matches.filter { $0.result == .win }.count
    }
    var lossesCount: Int {
        matches.filter { $0.result == .loss }.count
    }
}

// MARK: - Session Detail View
struct SessionDetailView: View {
    let session: PadelSession
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            Color.padelBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Header Ringkasan Sesi
                    VStack(alignment: .leading, spacing: 8) {
                        Text(session.courtName)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        HStack {
                            Label(session.dateString, systemImage: "calendar")
                            Spacer()
                            Text("Record: \(session.winsCount)W - \(session.lossesCount)L")
                                .bold()
                                .foregroundColor(.padelMint)
                        }
                        .font(.subheadline)
                        .foregroundColor(.padelMutedText)
                    }
                    .padding(20)
                    .background(Color.padelCard)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.padelBorder, lineWidth: 1))
                    
                    Text("MATCHES IN THIS SESSION")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.padelMutedText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                    
                    // List Detail Match & Fitur Swipe-to-Delete + Share
                    LazyVStack(spacing: 12) {
                        ForEach(session.matches) { match in
                            matchDetailCard(match: match)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        modelContext.delete(match)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Session Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func matchDetailCard(match: Match) -> some View {
        HStack(spacing: 16) {
            Text(match.result == .win ? "W" : "L")
                .font(.subheadline.bold())
                .foregroundColor(match.result == .win ? Color.padelBackground : .white)
                .frame(width: 36, height: 36)
                .background(match.result == .win ? Color.padelMint : Color.padelLoss)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("vs \(match.opponents)")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Text(match.scoreDetails)
                        .font(.subheadline.bold())
                        .foregroundColor(.padelNeon)
                }
                
                HStack {
                    if let partner = match.partner {
                        Text("Partner: \(partner.name)")
                            .font(.caption2)
                            .foregroundColor(.padelMutedText)
                    }
                    Spacer()
                    
                    // Tombol Share Card ke Story/WhatsApp
                    ShareLink(
                        item: renderShareCard(match: match),
                        preview: SharePreview("PadelSync Match Result", image: renderShareCard(match: match))
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.caption2.bold())
                            .foregroundColor(.padelNeon)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.padelNeon.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding(14)
        .background(Color.padelCard)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.padelBorder, lineWidth: 1))
    }
    
    // MARK: - Render Share Image
    @MainActor
    private func renderShareCard(match: Match) -> Image {
        let cardView = ShareableMatchCard(
            courtName: match.courtName,
            dateString: formatDate(match.date),
            opponents: match.opponents,
            scoreDetails: match.scoreDetails,
            partnerName: match.partner?.name,
            isWin: match.result == .win
        )
        
        let renderer = ImageRenderer(content: cardView)
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "photo")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
