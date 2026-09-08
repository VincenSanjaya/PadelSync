//
//  Partner.swift
//  PadelSync
//
//  Created by Vincen Sanjaya on 05/09/26.
//

import Foundation
import SwiftData

@Model
class Partner {
    // Identitas unik biar sistem nggak bingung kalau ada 2 orang namanya sama-sama "Alex"
    var id: UUID
    var name: String
    
    // Foto profil (pakai tipe Data). Bisa nil (kosong) kalau belum di-upload fotonya
    var profileImageData: Data?
    
    // Ini magic-nya SwiftData: bikin relasi ke Match.
    // cascade = kalau partner ini kamu hapus dari app, semua riwayat match bareng dia juga ikut kehapus.
    // inverse = ngasih tau SwiftData buat nyambungin properti 'partner' yang ada di model Match.
    @Relationship(deleteRule: .cascade, inverse: \Match.partner)
    var matches: [Match]?
    
    init(id: UUID = UUID(), name: String, profileImageData: Data? = nil) {
        self.id = id
        self.name = name
        self.profileImageData = profileImageData
    }
}
