//
//  File.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import Foundation
import SwiftUI

struct Dawriyah: Identifiable{
    let id: UUID = UUID()
    let address:String
    let startTime: Date
    let endTime:Date
    let dawriyahDay:Date
    let notes: String
}
