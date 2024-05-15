//
//  Groups.swift
//  jadwa
//
//  Created by sarah alothman on 23/10/1445 AH.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct Groups: Identifiable, Hashable{
    let id: UUID = UUID()
    let name: String
    let busyDays = [Date()]
    let startDay = Date()

}
