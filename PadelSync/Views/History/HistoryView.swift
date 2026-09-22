//
//  HistoryView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 07/09/26.
//
import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Match.date, order: .reverse) private var matches: [Match]
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var selectedFilter: MatchFilter = .all
    
    enum MatchFilter: String, CaseIterable {
        case all = "All"
        case wins = "Wins"
        case draws = "Draws"
        case losses = "Losses"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.padelBackground.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Search Bar & Filter Pills
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.padelMutedText)
                            TextField("Search opponent, court, or partner...", text: $searchText)
                                .foregroundColor(.white)
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.padelMutedText)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.padelCard)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(MatchFilter.allCases, id: \.self) { filter in
                                    Button(action: {
                                        withAnimation(.easeInOut) { selectedFilter = filter }
                                    }) {
                                        Text(filter.rawValue)
                                            .font(.caption.bold())
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .foregroundColor(selectedFilter == filter ? Color.padelBackground : .padelMutedText)
                                            .background(selectedFilter == filter ? Color.padelNeon : Color.padelCard)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(selectedFilter == filter ? Color.padelNeon : Color.padelBorder, lineWidth: 1)
                                            )
                                    }
                                }
                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Content List / Sessions
                    Group {
                        if filteredSessions.isEmpty {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 48))
                                    .foregroundColor(.padelMutedText)
                                Text("No Matching Sessions Found")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Try adjusting your search or filter.")
                                    .font(.caption)
                                    .foregroundColor(.padelMutedText)
                            }
                            Spacer()
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(filteredSessions, id: \.id) { session in
                                        // Mengarah ke SessionDetailView terpisah yang baru kita buat
                                        NavigationLink(destination: SessionDetailView(session: session)) {
                                            sessionCard(session: session)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(20)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Session History")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // Algoritma Pengelompokan & Filter Sesi
    private var filteredSessions: [PadelSession] {
        let searchedMatches = matches.filter { match in
            let matchesSearch = searchText.isEmpty ||
                match.courtName.localizedCaseInsensitiveContains(searchText) ||
                match.opponents.localizedCaseInsensitiveContains(searchText) ||
                (match.partner?.name.localizedCaseInsensitiveContains(searchText) ?? false)
            
            let matchesFilter: Bool = {
                switch selectedFilter {
                case .all: return true
                case .wins: return match.result == .win
                case .draws: return match.result == .draw
                case .losses: return match.result == .loss
                }
            }()
            
            return matchesSearch && matchesFilter
        }
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let groupedDict = Dictionary(grouping: searchedMatches) { match in
            let dateKey = calendar.startOfDay(for: match.date)
            return "\(match.courtName.lowercased())_\(dateKey.timeIntervalSince1970)"
        }
        
        let sessions = groupedDict.map { (_, sessionMatches) in
            let firstMatch = sessionMatches.first!
            let dateKey = calendar.startOfDay(for: firstMatch.date)
            return PadelSession(
                courtName: firstMatch.courtName,
                dateString: formatter.string(from: dateKey),
                date: dateKey,
                matches: sessionMatches.sorted(by: { $0.date > $1.date })
            )
        }
        
        return sessions.sorted(by: { $0.date > $1.date })
    }
    
    // Kartu Ringkasan Sesi
    private func sessionCard(session: PadelSession) -> some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text("\(session.winsCount)W")
                    .font(.headline.bold())
                    .foregroundColor(.padelBackground)
                Text("\(session.lossesCount)L")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
                Text("\(session.drawsCount)D")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
            }
            .frame(width: 52, height: 52)
            .background(sessionSummaryColor(for: session))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(session.courtName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(session.dateString)
                        .font(.caption2)
                        .foregroundColor(.padelMutedText)
                }
                
                HStack(spacing: 8) {
                    Label("\(session.matches.count) Games Played", systemImage: "tennis.racket")
                        .font(.caption)
                        .foregroundColor(.padelNeon)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundColor(.padelMutedText)
                }
            }
        }
        .padding(16)
        .background(Color.padelCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.padelBorder, lineWidth: 1)
        )
    }
    
    private func sessionSummaryColor(for session: PadelSession) -> Color {
        if session.winsCount > session.lossesCount {
            return .padelMint
        } else if session.winsCount == session.lossesCount {
            return .padelNeon
        } else {
            return .padelLoss
        }
    }
}
