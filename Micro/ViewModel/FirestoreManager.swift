//
//  FirestoreManager.swift
//  Micro
//
//  Created by Hajar Alshehri on 01/11/1445 AH.
//

import Foundation
import Firebase
import FirebaseFirestore


class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    func saveEvent(name: String, date: Date, locationURL: String, completion: @escaping (Error?) -> Void) {
        let eventData: [String: Any] = [
            "name": name,
            "EvenDate": Timestamp(date: date),
            "location": locationURL
        ]
        
        db.collection("Event").addDocument(data: eventData) { error in
            completion(error)
        }
    }

}
