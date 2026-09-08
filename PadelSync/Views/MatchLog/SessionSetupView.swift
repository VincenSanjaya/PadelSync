//
//  SessionSetupView.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 08/09/26.
//

import SwiftUI

struct SessionSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    // State Pengaturan Sesi
    @State private var location = ""
    @State private var scoringSystem = "Tennis"
    @State private var partnerMode = "Fixed"
    @State private var fixedPartnerName = ""
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.padelBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        setupSection(title: "WHERE ARE WE PLAYING?") {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.padelNeon)
                                TextField("e.g. Kemang Padel", text: $location)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.padelCard)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
                        }
                        
                        // 2. Scoring System Setup
                        setupSection(title: "SCORING SYSTEM") {
                            HStack(spacing: 12) {
                                selectionButton(title: "Tennis (Sets)", isSelected: scoringSystem == "Tennis") {
                                    scoringSystem = "Tennis"
                                }
                                selectionButton(title: "21 Points", isSelected: scoringSystem == "21 Points") {
                                    scoringSystem = "21 Points"
                                }
                            }
                        }
                        
                        // 3. Partner Setup Logic
                        setupSection(title: "PARTNER SETUP") {
                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    selectionButton(title: "Fixed Partner", isSelected: partnerMode == "Fixed") {
                                        partnerMode = "Fixed"
                                    }
                                    selectionButton(title: "Rotate (Mix)", isSelected: partnerMode == "Rotate") {
                                        partnerMode = "Rotate"
                                    }
                                }
                                
                                // Jika Fixed, wajib isi nama partner di sini agar terkunci terus
                                if partnerMode == "Fixed" {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.padelNeon)
                                        TextField("Partner's Name (e.g. Alex)", text: $fixedPartnerName)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.padelCard)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.padelBorder, lineWidth: 1))
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                } else {
                                    Text("You can input different partners for each match during the session.")
                                        .font(.caption)
                                        .foregroundColor(.padelMutedText)
                                        .padding(.horizontal, 4)
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                        
                        // 4. Start Button menuju ActiveSessionView
                        NavigationLink(destination: ActiveSessionView(
                            location: location,
                            scoringSystem: scoringSystem,
                            partnerMode: partnerMode,
                            fixedPartnerName: fixedPartnerName,
                            isRootPresented: $isPresented
                        )) {
                            Text("LET'S GO")
                                .font(.title3.bold())
                                .foregroundColor(Color.padelBackground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.padelNeon)
                                .cornerRadius(16)
                                .shadow(color: Color.padelNeon.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        // Validasi: Lokasi harus diisi, dan jika Fixed partner namanya tidak boleh kosong
                        .disabled(location.isEmpty || (partnerMode == "Fixed" && fixedPartnerName.isEmpty))
                        .opacity((location.isEmpty || (partnerMode == "Fixed" && fixedPartnerName.isEmpty)) ? 0.5 : 1.0)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.padelMutedText)
                }
            }
            .animation(.easeInOut, value: partnerMode)
        }
    }
    
    // MARK: - UI Helpers
    private func setupSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundColor(.padelMutedText)
            content()
        }
    }
    
    private func selectionButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(isSelected ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Color.padelNeon : Color.padelCard)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.padelNeon : Color.padelBorder, lineWidth: 1))
        }
    }
}
