//
//  Event.swift
//  Micro
//
//  Created by Hajar Alshehri on 11/11/1445 AH.
//

import Foundation
import Firebase

struct Event: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let date: Date
    let locationURL: String
}
