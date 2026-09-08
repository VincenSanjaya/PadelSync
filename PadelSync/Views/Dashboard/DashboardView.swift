//
//  DashboardView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 06/09/26.
//

import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Query(sort: \Match.date, order: .forward) private var matches: [Match]
    @State private var viewModel = DashboardViewModel()
    @State private var showingSessionSetup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.padelBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Sederhana & Bersih
                    HStack {
                        Image(systemName: "figure.tennis")
                            .foregroundColor(.padelNeon)
                        Text("PADELSYNC")
                            .font(.headline.bold())
                            .foregroundColor(.padelNeon)
                        Spacer()
                        Image(systemName: "bell")
                            .foregroundColor(.padelMutedText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            ratingDashboard
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100) // Ruang untuk tombol bawah
                    }
                }
                
                // Tombol Start Session di Bawah
                VStack {
                    Spacer()
                    Button(action: { showingSessionSetup = true }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("START SESSION")
                        }
                        .font(.title3.bold())
                        .foregroundColor(Color.padelBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.padelNeon)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .shadow(color: Color.padelNeon.opacity(0.3), radius: 15, x: 0, y: 5)
                }
            }
            .onChange(of: matches, initial: true) { _, newMatches in
                viewModel.matches = newMatches
            }
            .sheet(isPresented: $showingSessionSetup) {
                SessionSetupView(isPresented: $showingSessionSetup)
                    .presentationDetents([.large])
            }
        }
    }
    
    // MARK: - Rating & Progress Dashboard UI
    private var ratingDashboard: some View {
        VStack(spacing: 24) {
            // Big Number Rating
            VStack(spacing: 8) {
                Text(String(format: "%.1f", currentRating))
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.padelNeon)
                    .shadow(color: Color.padelNeon.opacity(0.5), radius: 10)
                
                HStack {
                    Image(systemName: "star.circle.fill")
                    Text("CURRENT LEVEL: \(currentLevelText)")
                        .font(.caption.bold())
                }
                .foregroundColor(.padelNeon)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.padelNeon.opacity(0.1))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.padelNeon.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Trend Chart Card
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Rating Trend")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("LAST 10 MATCHES")
                            .font(.caption)
                            .foregroundColor(.padelMutedText)
                    }
                    Spacer()
                    Text("+0.4")
                        .font(.headline.bold())
                        .foregroundColor(.padelNeon)
                }
                
                Chart {
                    ForEach(Array(dummyTrendData.enumerated()), id: \.offset) { index, value in
                        LineMark(
                            x: .value("Match", index),
                            y: .value("Rating", value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.padelNeon)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        PointMark(
                            x: .value("Match", index),
                            y: .value("Rating", value)
                        )
                        .foregroundStyle(Color.padelNeon)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 120)
            }
            .padding(20)
            .background(Color.padelCard)
            .cornerRadius(20)
            
            // Stats Grid (Wins & Losses)
            HStack(spacing: 16) {
                statBox(icon: "trophy", title: "WINS", value: "\(viewModel.totalWins)")
                statBox(icon: "tennis.racket", title: "LOSSES", value: "\(viewModel.totalLosses)")
            }
            
            // Best Partner Insight Card
            if let best = viewModel.bestPartner {
                PartnerInsightCard(
                    partnerName: best.name,
                    winRate: viewModel.winRate(with: best)
                )
            }
        }
    }

    // MARK: - Helpers
    private var currentRating: Double {
        let baseRating = 0.0
        let winPoints = Double(viewModel.totalWins) * 0.15
        let lossPoints = Double(viewModel.totalLosses) * 0.05
        let finalRating = baseRating + winPoints - lossPoints
        return max(0.0, finalRating)
    }
    
    private var currentLevelText: String {
        switch currentRating {
        case 0.0..<1.5:
            return "NOVICE"
        case 1.5..<3.0:
            return "BEGINNER"
        case 3.0..<4.5:
            return "INTERMEDIATE"
        case 4.5..<6.0:
            return "ADVANCED"
        default:
            return "ELITE"
        }
    }
    
    private var dummyTrendData: [Double] {
        [2.0, 2.15, 2.30, 2.25, 2.40, 2.55]
    }
    
    private func statBox(icon: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.padelNeon)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.padelMutedText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.padelCard)
        .cornerRadius(20)
    }
}
