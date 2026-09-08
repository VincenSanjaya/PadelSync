//
//  PartnerInsightCard.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 07/09/26.
//

import SwiftUI

struct PartnerInsightCard: View {
    let partnerName: String
    let winRate: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.padelBorder)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "figure.tennis")
                        .foregroundColor(.padelMutedText)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Best Partner")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.padelMint)
                
                Text(partnerName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(String(format: "%.0f%% Win Rate Together", winRate))
                    .font(.subheadline)
                    .foregroundColor(.padelMutedText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.padelCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.padelBorder, lineWidth: 1)
        )
    }
}
