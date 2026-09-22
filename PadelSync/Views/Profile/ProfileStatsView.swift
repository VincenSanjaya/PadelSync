//
//  ProfileStatsView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 08/09/26.
//

import SwiftUI
import SwiftData
import Charts

struct ProfileStatsView: View {
    @Query(sort: \Match.date, order: .reverse) private var matches: [Match]
    @Query private var partners: [Partner]
    
    // Hitung Win Rate di sini agar berada di dalam scope yang benar
    private var globalWinRate: Int {
        guard !matches.isEmpty else { return 0 }
        let wins = matches.filter { $0.result == .win }.count
        return Int((Double(wins) / Double(matches.count)) * 100)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.padelBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // 1. Overview KPI Cards
                        HStack(spacing: 12) {
                            kpiCard(title: "TOTAL MATCHES", value: "\(matches.count)", icon: "tennis.racket", color: .padelNeon)
                            kpiCard(title: "GLOBAL WIN RATE", value: "\(globalWinRate)%", icon: "chart.line.uptrend.xyaxis", color: .padelMint)
                        }
                        
                        // 2. Performance Chart Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PERFORMANCE TREND")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.padelMutedText)
                            
                            if matches.count < 2 {
                                Text("Play at least 2 matches to unlock performance charts.")
                                    .font(.caption)
                                    .foregroundColor(.padelMutedText)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 30)
                            } else {
                                ChartContainerView(matches: matches)
                            }
                        }
                        .padding(16)
                        .background(Color.padelCard)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.padelBorder, lineWidth: 1))
                        
                        // 3. Best Partners Leaderboard
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TOP PARTNERS")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.padelMutedText)
                            
                            if partners.isEmpty {
                                Text("No partners recorded yet.")
                                    .font(.caption)
                                    .foregroundColor(.padelMutedText)
                                    .padding(.vertical, 10)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(partners.prefix(5)) { partner in
                                        partnerRow(partner: partner)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.padelCard)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.padelBorder, lineWidth: 1))
                        
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Analytics & Stats")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Helper KPI Card
    private func kpiCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(title)
                .font(.caption2.bold())
                .foregroundColor(.padelMutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.padelCard)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.padelBorder, lineWidth: 1))
    }
    
    // MARK: - Partner Row Item
    private func partnerRow(partner: Partner) -> some View {
        let partnerMatches = matches.filter { $0.partner?.id == partner.id }
        let wins = partnerMatches.filter { $0.result == .win }.count
        let total = partnerMatches.count
        let winRate = total > 0 ? Int((Double(wins) / Double(total)) * 100) : 0
        
        return HStack {
            Circle()
                .fill(Color.padelNeon.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(Text(String(partner.name.prefix(1)).uppercased()).font(.subheadline.bold()).foregroundColor(.padelNeon))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(partner.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("\(total) matches played")
                    .font(.caption2)
                    .foregroundColor(.padelMutedText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(winRate)%")
                    .font(.subheadline.bold())
                    .foregroundColor(.padelMint)
                Text("Win Rate")
                    .font(.caption2)
                    .foregroundColor(.padelMutedText)
            }
        }
        .padding(10)
        .background(Color.padelBackground)
        .cornerRadius(12)
    }
}

// MARK: - Subview Chart Grafik Tren Performa
struct ChartContainerView: View {
    let matches: [Match]
    
    var body: some View {
        Chart {
            ForEach(Array(matches.prefix(10).reversed().enumerated()), id: \.offset) { index, match in
                LineMark(
                    x: .value("Game", index + 1),
                    y: .value("Result", chartValue(for: match.result))
                )
                .foregroundStyle(Color.padelNeon)
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("Game", index + 1),
                    y: .value("Result", chartValue(for: match.result))
                )
                .foregroundStyle(chartColor(for: match.result))
            }
        }
        .frame(height: 160)
        .chartYAxis {
            AxisMarks(values: [0, 0.5, 1]) { value in
                AxisValueLabel {
                    if let doubleVal = value.as(Double.self) {
                        Text(chartLabel(for: doubleVal))
                            .font(.caption2)
                            .foregroundColor(.padelMutedText)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                    .foregroundStyle(Color.padelMutedText)
            }
        }
    }
    
    private func chartValue(for result: MatchResult) -> Double {
        switch result {
        case .win: return 1
        case .draw: return 0.5
        case .loss: return 0
        }
    }
    
    private func chartColor(for result: MatchResult) -> Color {
        switch result {
        case .win: return .padelMint
        case .draw: return .padelNeon
        case .loss: return .padelLoss
        }
    }
    
    private func chartLabel(for value: Double) -> String {
        switch value {
        case 1: return "Win"
        case 0.5: return "Draw"
        default: return "Loss"
        }
    }
}
