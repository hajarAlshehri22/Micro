//
//  Groups.swift
//  jadwa
//
//  Created by sarah alothman on 23/10/1445 AH.
//

import Foundation
import SwiftUI

struct Groups: Identifiable{
    let id: UUID = UUID()
    let name: String
    let busyDays = [Date()]
    let startDay = Date()

}
