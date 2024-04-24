//
//  File 2.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import Foundation
import SwiftUI

struct Groups: Identifiable{
    let id: UUID = UUID()
    let name: String
    let busyDays = [Date()]
    let startDay = Date()

}
