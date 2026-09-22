//
//  AddGameInSessionView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 08/09/26.
//

import SwiftUI
import SwiftData

struct AddGameInSessionView: View {
    let location: String
    let scoringSystem: String
    let partnerMode: String
    let fixedPartnerName: String
    let existingPartners: [Partner]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // State Input Game
    @State private var opponents = ""
    @State private var dynamicPartnerName = ""
    
    // 1. Ubah jadi array set dinamis (Default 1 set)
    @State private var matchSets: [(us: Int, them: Int)] = [(us: 6, them: 4)]
    
    // State Quick Match Points
    @State private var quickMyScore = 0
    @State private var quickOpponentScore = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.padelBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Jika mode Rotate, tampilkan input partner untuk game ini
                        if partnerMode == "Rotate" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("PARTNER FOR THIS GAME")
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.padelMutedText)
                                
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.padelNeon)
                                    TextField("Enter Partner's Name", text: $dynamicPartnerName)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.padelCard)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
                            }
                        }
                        
                        // Input Opponents
                        VStack(alignment: .leading, spacing: 8) {
                            Text("OPPONENTS")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.padelMutedText)
                            
                            HStack {
                                Image(systemName: "person.2.crop.square.stack")
                                    .foregroundColor(.padelNeon)
                                TextField("e.g. Budi & Jojo", text: $opponents)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.padelCard)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
                        }
                        
                        // Score Section Dinamis
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SCORE FORMAT (\(scoringSystem.uppercased()))")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.padelMutedText)
                            
                            if scoringSystem == "Tennis" {
                                VStack(spacing: 12) {
                                    // Render set secara dinamis dari array matchSets
                                    ForEach(Array(matchSets.enumerated()), id: \.offset) { index, set in
                                        setRow(setNumber: "SET \(index + 1)", us: bindingForUs(at: index), them: bindingForThem(at: index))
                                    }
                                    
                                    // Tombol "Add Set" (Maksimal 3 set standar tenis)
                                    if matchSets.count < 3 {
                                        Button(action: {
                                            matchSets.append((us: 0, them: 0))
                                        }) {
                                            HStack {
                                                Image(systemName: "plus.circle.fill")
                                                Text("Add Set")
                                            }
                                            .font(.subheadline.bold())
                                            .foregroundColor(.padelNeon)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(Color.padelCard)
                                            .cornerRadius(12)
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelNeon.opacity(0.4), lineWidth: 1))
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                            } else {
                                quickMatchPointsInput
                            }
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Save Button
                        Button(action: saveGame) {
                            Text("SAVE GAME")
                                .font(.title3.bold())
                                .foregroundColor(Color.padelBackground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.padelNeon)
                                .cornerRadius(16)
                        }
                        .disabled(opponents.isEmpty || (partnerMode == "Rotate" && dynamicPartnerName.isEmpty))
                        .opacity((opponents.isEmpty || (partnerMode == "Rotate" && dynamicPartnerName.isEmpty)) ? 0.5 : 1.0)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Log Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.padelMutedText)
                }
            }
        }
    }
    
    // MARK: - Binding Helper untuk Array Tuple Dinamis
    private func bindingForUs(at index: Int) -> Binding<Int> {
        Binding(
            get: { matchSets[index].us },
            set: { matchSets[index].us = $0 }
        )
    }
    
    private func bindingForThem(at index: Int) -> Binding<Int> {
        Binding(
            get: { matchSets[index].them },
            set: { matchSets[index].them = $0 }
        )
    }
    
    // MARK: - Traditional Sets Input UI
    private func setRow(setNumber: String, us: Binding<Int>, them: Binding<Int>) -> some View {
        HStack {
            Text(setNumber)
                .font(.headline.bold())
                .foregroundColor(.padelNeon)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            TextField("0", value: us, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.padelBackground)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
            
            Text("—")
                .foregroundColor(.padelMutedText)
                .padding(.horizontal, 12)
            
            TextField("0", value: them, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.padelBackground)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
        }
        .padding(16)
        .background(Color.padelCard)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.padelBorder, lineWidth: 1))
    }
    
    // MARK: - Quick Match Points Input UI
    private var quickMatchPointsInput: some View {
        HStack(spacing: 16) {
            VStack(spacing: 12) {
                Text("MY SCORE").font(.caption2.bold()).foregroundColor(.padelNeon)
                Text("\(quickMyScore)").font(.system(size: 50, weight: .bold, design: .rounded)).foregroundColor(.white)
                HStack(spacing: 12) {
                    Button(action: { if quickMyScore > 0 { quickMyScore -= 1 } }) {
                        Image(systemName: "minus").foregroundColor(.padelMutedText).frame(width: 36, height: 36).background(Color.padelBackground).clipShape(Circle())
                    }
                    Button(action: { quickMyScore += 1 }) {
                        Image(systemName: "plus").foregroundColor(.padelNeon).frame(width: 36, height: 36).background(Color.padelBackground).clipShape(Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity).padding(.vertical, 20).background(Color.padelCard).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.padelNeon.opacity(0.4), lineWidth: 1))
            
            Text("VS").font(.headline.bold()).foregroundColor(.padelMutedText)
            
            VStack(spacing: 12) {
                Text("OPPONENT").font(.caption2.bold()).foregroundColor(.padelMutedText)
                Text("\(quickOpponentScore)").font(.system(size: 50, weight: .bold, design: .rounded)).foregroundColor(.white)
                HStack(spacing: 12) {
                    Button(action: { if quickOpponentScore > 0 { quickOpponentScore -= 1 } }) {
                        Image(systemName: "minus").foregroundColor(.padelMutedText).frame(width: 36, height: 36).background(Color.padelBackground).clipShape(Circle())
                    }
                    Button(action: { quickOpponentScore += 1 }) {
                        Image(systemName: "plus").foregroundColor(.padelNeon).frame(width: 36, height: 36).background(Color.padelBackground).clipShape(Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity).padding(.vertical, 20).background(Color.padelCard).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.padelBorder, lineWidth: 1))
        }
    }
    
    // MARK: - Save Logic
    private func saveGame() {
        let result: MatchResult
        let scoreString: String
        
        if scoringSystem == "Tennis" {
            // Hitung set yang dimenangkan berdasarkan data dinamis
            var usSets = 0
            var themSets = 0
            
            for set in matchSets {
                if set.us > set.them { usSets += 1 }
                else if set.them > set.us { themSets += 1 }
            }
            
            if usSets > themSets {
                result = .win
            } else if usSets == themSets {
                result = .draw
            } else {
                result = .loss
            }
            
            // Gabungkan string skor secara otomatis (misal: "6-4" atau "6-4, 4-6, 7-5")
            scoreString = matchSets.map { "\($0.us)-\($0.them)" }.joined(separator: ", ")
        } else {
            if quickMyScore > quickOpponentScore {
                result = .win
            } else if quickMyScore == quickOpponentScore {
                result = .draw
            } else {
                result = .loss
            }
            scoreString = "\(quickMyScore) - \(quickOpponentScore) pts"
        }
        
        // Tentukan partner berdasarkan mode session
        let activePartnerName = partnerMode == "Fixed" ? fixedPartnerName : dynamicPartnerName
        var finalPartner: Partner? = nil
        
        if !activePartnerName.isEmpty {
            let matched = existingPartners.first(where: { $0.name.lowercased() == activePartnerName.lowercased() })
            finalPartner = matched ?? Partner(name: activePartnerName)
            if matched == nil { modelContext.insert(finalPartner!) }
        }
        
        let newMatch = Match(
            date: Date(),
            courtName: location,
            result: result,
            scoreDetails: scoreString,
            opponents: opponents,
            partner: finalPartner
        )
        
        modelContext.insert(newMatch)
        dismiss()
    }
}       
