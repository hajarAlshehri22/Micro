//
//  EventDetails.swift
//  Micro
//
//  Created by Mayasem Muner on 5/1/24.
//

import Foundation
import Firebase

struct EventDetails: Identifiable, Codable{
    var id: String
    var name: String
    var Location: String
}
