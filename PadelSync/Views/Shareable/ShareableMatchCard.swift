//
//  ShareableMatchCard.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 08/09/26.
//

import SwiftUI

struct ShareableMatchCard: View {
    let courtName: String
    let dateString: String
    let opponents: String
    let scoreDetails: String
    let partnerName: String?
    let result: MatchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header Brand
            HStack {
                Image(systemName: "figure.tennis")
                    .foregroundColor(.padelNeon)
                Text("PADELSYNC SESSION")
                    .font(.caption.bold())
                    .tracking(2)
                    .foregroundColor(.padelNeon)
                Spacer()
                Text(dateString)
                    .font(.caption2)
                    .foregroundColor(.padelMutedText)
            }
            
            // Result Banner
            VStack(alignment: .leading, spacing: 4) {
                Text(resultTitle)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(resultColor)
                
                Text(courtName)
                    .font(.subheadline)
                    .foregroundColor(.padelMutedText)
            }
            
            Divider().background(Color.padelBorder)
            
            // Score & Match Details
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("VS OPPONENTS")
                        .font(.caption2.bold())
                        .foregroundColor(.padelMutedText)
                    Text(opponents)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SCORE")
                            .font(.caption2.bold())
                            .foregroundColor(.padelMutedText)
                        Text(scoreDetails)
                            .font(.headline.bold())
                            .foregroundColor(.padelNeon)
                    }
                    
                    Spacer()
                    
                    if let partner = partnerName {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("PARTNER")
                                .font(.caption2.bold())
                                .foregroundColor(.padelMutedText)
                            Text(partner)
                                .font(.headline.bold())
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.padelBackground.opacity(0.6))
            .cornerRadius(16)
            
            // Footer branding
            HStack {
                Spacer()
                Text("Tracked with PadelSync iOS")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundColor(.padelMutedText)
                Spacer()
            }
        }
        .padding(24)
        .frame(width: 320, height: 420) // Ukuran proporsional untuk Story/Share
        .background(Color.padelCard)
        .cornerRadius(28)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(result == .loss ? Color.padelBorder : resultColor.opacity(0.5), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 10)
    }
    
    private var resultTitle: String {
        switch result {
        case .win: return "VICTORY"
        case .draw: return "DRAW"
        case .loss: return "MATCH RECORD"
        }
    }
    
    private var resultColor: Color {
        switch result {
        case .win: return .padelMint
        case .draw: return .padelNeon
        case .loss: return .white
        }
    }
}
