//
//  GroupInfo.swift
//  Micro
//
//  Created by Hajar Alshehri on 08/11/1445 AH.
//

import Foundation

struct GroupInfo: Identifiable {
    var id: String  // Unique identifier for the group, typically the Firestore document ID
    var name: String  // The name of the group
    var members: [peopleInfo]  // A list of members in the group
}
