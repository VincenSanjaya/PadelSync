//
//  DashboardViewModel.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 05/09/26.
//

import Foundation
import SwiftData

@Observable
class DashboardViewModel {
    // Kita siapin wadah kosong buat nampung data pertandingan dari database (View nanti yang bakal ngisi ini)
    var matches: [Match] = []
    
    // MARK: - Kalkulasi Statistik Utama
    
    var totalMatches: Int {
        matches.count
    }
    
    var totalWins: Int {
        // Filter semua match yang hasilnya win, lalu hitung jumlahnya
        matches.filter { $0.result == .win }.count
    }
    
    var totalLosses: Int {
        matches.filter { $0.result == .loss }.count
    }
    
    var winRate: Double {
        // Cegah error pembagian dengan nol kalau aplikasinya baru di-install dan belum ada data
        guard totalMatches > 0 else { return 0.0 }
        
        // Hitung persentase: (Total Menang / Total Main) * 100
        return (Double(totalWins) / Double(totalMatches)) * 100
    }
    
    // MARK: - Kalkulasi Synergy (Best Partner)
    
    var bestPartner: Partner? {
        // Ambil match yang ada partner-nya aja (bermain ganda)
        let matchesWithPartner = matches.filter { $0.partner != nil }
        
        // Kelompokkan match berdasarkan partner-nya.
        // Hasilnya jadi semacam kamus: [Partner A: [Match 1, Match 2], Partner B: [Match 3]]
        let groupedByPartner = Dictionary(grouping: matchesWithPartner, by: { $0.partner! })
        
        var topPartner: Partner? = nil
        var maxWins = 0
        
        // Cek satu-satu, siapa sih partner yang paling sering ngasih kemenangan?
        for (partner, partnerMatchList) in groupedByPartner {
            let winsTogether = partnerMatchList.filter { $0.result == .win }.count
            
            if winsTogether > maxWins {
                maxWins = winsTogether
                topPartner = partner
            }
        }
        
        return topPartner
    }
    
    // Fungsi pembantu buat nampilin persentase kemenangan sama si Best Partner (kalau butuh ditampilin di kartu profil)
    func winRate(with partner: Partner) -> Double {
        let matchesTogether = matches.filter { $0.partner == partner }
        let wins = matchesTogether.filter { $0.result == .win }.count
        let total = matchesTogether.count
        
        guard total > 0 else { return 0.0 }
        return (Double(wins) / Double(total)) * 100
    }
}
