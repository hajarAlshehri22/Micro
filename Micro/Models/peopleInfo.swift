//
//  File.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import Foundation
import SwiftUI

struct peopleInfo : Identifiable, Hashable {
    let id: UUID = UUID()
    let emoji: Int
    let name: String
}
