//
//  Match.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 05/09/26.
//

import Foundation
import SwiftData

// Bikin opsi pasti buat hasil pertandingan biar datanya rapi, nggak ada yang ngetik typo
enum MatchResult: String, Codable {
    case win = "WIN"
    case draw = "DRAW"
    case loss = "LOSS"
}

@Model
class Match {
    var id: UUID
    var date: Date
    var courtName: String // Tempat main, misal: "Kemang Padel"
    
    // Nyimpen menang atau kalah pakai enum yang udah kita buat di atas
    var result: MatchResult
    
    // Rincian skor, disimpen dalam teks aja biar gampang. Contoh: "6-4, 5-7, 10-8"
    var scoreDetails: String
    
    // Nama lawan main, contoh: "Marcus & David"
    var opponents: String
    
    // Relasi balik ke Partner. Siapa sih temen main kamu di match ini?
    var partner: Partner?
    
    init(id: UUID = UUID(), date: Date = Date(), courtName: String, result: MatchResult, scoreDetails: String, opponents: String, partner: Partner? = nil) {
        self.id = id
        self.date = date
        self.courtName = courtName
        self.result = result
        self.scoreDetails = scoreDetails
        self.opponents = opponents
        self.partner = partner
    }
}
