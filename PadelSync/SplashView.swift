//
//  SplashView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 08/09/26.
//

import SwiftUI

struct SplashView: View {
    @Binding var isFinished: Bool
    
    // State untuk kontrol animasi
    @State private var scaleEffect: CGFloat = 0.8
    @State private var opacityVal: Double = 0.0
    @State private var glowRadius: CGFloat = 5.0
    
    var body: some View {
        ZStack {
            // Background gelap khas PadelSync
            Color.padelBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo Ikon Animasi
                ZStack {
                    // Efek Glow Belakang
                    Circle()
                        .fill(Color.padelNeon.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .blur(radius: glowRadius)
                    
                    // Lingkaran Icon Utama
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.padelCard)
                        .frame(width: 110, height: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.padelNeon, lineWidth: 2)
                        )
                        .shadow(color: Color.padelNeon.opacity(0.4), radius: 10, x: 0, y: 0)
                    
                    // Simbol Tenis / Padel di dalam logo
                    Image(systemName: "figure.tennis")
                        .font(.system(size: 50))
                        .foregroundColor(.padelNeon)
                }
                .scaleEffect(scaleEffect)
                
                // Teks Nama Aplikasi dengan Efek Elegan
                VStack(spacing: 6) {
                    Text("PADELSYNC")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .tracking(4) // Jarak antar huruf biar kelihatan futuristik
                        .foregroundColor(.white)
                    
                    Text("SMART TRACKING & ANALYTICS")
                        .font(.caption2.bold())
                        .tracking(2)
                        .foregroundColor(.padelMutedText)
                }
                .opacity(opacityVal)
            }
        }
        .onAppear {
            // Jalankan animasi masuk yang mulus
            withAnimation(.easeOut(duration: 0.8)) {
                scaleEffect = 1.0
                opacityVal = 1.0
            }
            
            // Efek detak/glow neon melambat
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                glowRadius = 20.0
            }
            
            // Durasi Splash Screen muncul sebelum otomatis masuk ke Dashboard (1.8 detik)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                isFinished = false // Ubah ke false agar beralih ke Dashboard
                            }
                        }
        }
    }
}
