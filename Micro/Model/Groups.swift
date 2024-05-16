//
//  Groups.swift
//  jadwa
//
//  Created by sarah alothman on 23/10/1445 AH.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Group: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var members: [peopleInfo]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case members
    }
}
