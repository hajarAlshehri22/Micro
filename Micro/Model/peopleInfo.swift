//
//  peopleInfo.swift
//  jadwa
//
//  Created by sarah alothman on 23/10/1445 AH.
//

import Foundation
import SwiftUI

struct peopleInfo : Identifiable, Hashable {
    let id: UUID = UUID()
    let emoji: Int
    let name: String
}
