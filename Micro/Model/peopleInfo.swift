//
//  peopleInfo.swift
//  jadwa
//
//  Created by sarah alothman on 23/10/1445 AH.
//

import Foundation
import SwiftUI
import Firebase

struct peopleInfo: Identifiable,Hashable, Codable {
    var id: String
    var emoji: Int
    var name: String
}

