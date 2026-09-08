//
//  MainTabView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 08/09/26.
//
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Dashboard Utama
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            // Tab 2: Analytics & Stats (Halaman baru kita)
            ProfileStatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            // Tab 3: History (Riwayat Sesi)
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(2)
        }
        .accentColor(.padelNeon)
        .preferredColorScheme(.dark)
    }
}
