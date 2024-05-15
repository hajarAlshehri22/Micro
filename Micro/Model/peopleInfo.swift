//
//  peopleInfo.swift
//  jadwa
//
//  Created by sarah alothman on 23/10/1445 AH.
//

import Foundation
import SwiftUI
import Firebase
struct peopleInfo: Identifiable, Hashable {
    var id: String  // Firebase document ID
    var emoji: Int  // Emoji representing the user (you'll need to define how this is assigned)
    var name: String
}

