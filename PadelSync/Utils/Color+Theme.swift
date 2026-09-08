//
//  Color+Theme.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 04/09/26.
//

import SwiftUI

// MARK: - Warna Khas PadelSync
extension Color {
    // Background utama layar (Abu-abu gelap pekat)
    static let padelBackground = Color(hex: "1E2325")
    
    // Warna dasar buat kartu & kontainer
    static let padelCard = Color(hex: "2B3235")
    
    // Buat garis pinggir kartu, pembatas, atau progress bar kosong
    static let padelBorder = Color(hex: "3A4448")
    
    // Warna highlight utama (Hijau Mint/Tosca) - panggil buat Winrate, status WIN, & tombol CTA
    static let padelMint = Color(hex: "00AA88")
    
    // Aksen pendukung kalau butuh gradasi atau efek kilau
    static let padelCyan = Color(hex: "21E2C2")
    
    // Buat teks sekunder, subtitle, tanggal, atau label kecil
    static let padelMutedText = Color(hex: "838B8C")
    
    // Badge kalau statusnya kalah (LOSS)
    static let padelLoss = Color(hex: "FF5252")
    
    static let padelNeon = Color(hex: "D4FF00") // Sesuai warna referensi
}

// MARK: - Helper biar bisa panggil kode HEX langsung
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // Format pendek (RGB 12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17), (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // Format standar (RGB 24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // Format plus transparansi (ARGB 32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
