//
//  ActiveSessionView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 07/09/26.
//

import SwiftUI
import SwiftData

struct ActiveSessionView: View {
    // Data dari SessionSetupView sebelumnya
    let location: String
    let scoringSystem: String
    let partnerMode: String
    let fixedPartnerName: String
    
    @Binding var isRootPresented: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var existingPartners: [Partner]
    
    @State private var showingAddGameSheet = false
    
    @Query(sort: \Match.date, order: .reverse) private var allMatches: [Match]
    
    var body: some View {
        ZStack {
            Color.padelBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Session Header Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ACTIVE SESSION")
                                .font(.caption2.bold())
                                .foregroundColor(.padelNeon)
                            Text(location)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        // Badge Sesi Info
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(sessionMatches.count) GAMES")
                                .font(.headline.bold())
                                .foregroundColor(.padelMint)
                            Text(partnerMode == "Fixed" ? "Fixed: \(fixedPartnerName)" : "Rotate Mode")
                                .font(.caption2)
                                .foregroundColor(.padelMutedText)
                        }
                    }
                }
                .padding(20)
                .background(Color.padelCard)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.padelBorder, lineWidth: 1))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // 2. Daftar Game yang sudah di-log di Sesi Ini (Live Feed)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("SESSION MATCHES")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.padelMutedText)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        if sessionMatches.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "tennis.racket")
                                    .font(.system(size: 40))
                                    .foregroundColor(.padelMutedText)
                                Text("No games recorded in this session yet.")
                                    .font(.subheadline)
                                    .foregroundColor(.padelMutedText)
                                Text("Tap 'Add Game' below to log your first match.")
                                    .font(.caption2)
                                    .foregroundColor(.padelMutedText.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(sessionMatches) { match in
                                    sessionGameCard(match: match)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    // Tombol End Session
                    Button(action: {
                        isRootPresented = false
                    }) {
                        Text("END SESSION")
                            .font(.subheadline.bold())
                            .foregroundColor(.padelLoss)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.padelCard)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.padelLoss, lineWidth: 1))
                    }
                    
                    // Tombol Add Game
                    Button(action: { showingAddGameSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("ADD GAME")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(Color.padelBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.padelNeon)
                        .cornerRadius(16)
                        .shadow(color: Color.padelNeon.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(
                    LinearGradient(
                        colors: [Color.padelBackground.opacity(0), Color.padelBackground],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            }
        }
        .navigationTitle("Live Session")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // Memunculkan Form Input Game khusus untuk sesi ini
        .sheet(isPresented: $showingAddGameSheet) {
            AddGameInSessionView(
                location: location,
                scoringSystem: scoringSystem,
                partnerMode: partnerMode,
                fixedPartnerName: fixedPartnerName,
                existingPartners: existingPartners
            )
            .presentationDetents([.large])
        }
    }
    
    // MARK: - Filter Match hanya untuk sesi hari ini & lokasi ini
    private var sessionMatches: [Match] {
        let calendar = Calendar.current
        return allMatches.filter { match in
            match.courtName.lowercased() == location.lowercased() &&
            calendar.isDateInToday(match.date)
        }
    }
    
    // MARK: - Card Tampilan Game di Sesi Ini
    private func sessionGameCard(match: Match) -> some View {
        HStack(spacing: 16) {
            Text(match.result == .win ? "W" : "L")
                .font(.headline.bold())
                .foregroundColor(match.result == .win ? Color.padelBackground : .white)
                .frame(width: 40, height: 40)
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
                
                if let partner = match.partner {
                    Text("Partner: \(partner.name)")
                        .font(.caption2)
                        .foregroundColor(.padelMutedText)
                }
            }
        }
        .padding(14)
        .background(Color.padelCard)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.padelBorder, lineWidth: 1))
    }
}
