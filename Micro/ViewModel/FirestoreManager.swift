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
            "location": locationURL,
            "groupID": String(),
            
        ]
        
        db.collection("Event").addDocument(data: eventData) { error in
            completion(error)
        }
    }
    
    func saveUserData(userId: String, name: String, username: String, selectedImage: Int, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let memojiName = "memoji\(selectedImage)"
        let userDict: [String: Any] = [
            "UserID": userId,
            "groupID": [String](),
            "FullName": name,
            "Memoji": memojiName,
            "BusyDay": [Timestamp](),
            "UserName": username
        ]
        
        db.collection("User").document(userId).setData(userDict) { error in
            if let error = error {
                completion(error)
            } else {
                // If user data saved successfully, save username as a separate document
                db.collection("usernames").document(username.lowercased()).setData(["UserID": userId]) { error in
                    completion(error)
                }
            }
        }
    }
            
        
    // Function to check username uniqueness
      func checkUsernameUnique(username: String, completion: @escaping (Bool) -> Void) {
          let docRef = db.collection("usernames").document(username.lowercased())

          docRef.getDocument { document, error in
              if let document = document, document.exists {
                  completion(false)  // Username is not unique
              } else {
                  completion(true)   // Username is unique
              }
          }
      }
    
    
    
    func createUserData(userId: String, completion: @escaping (Error?) -> Void) {
        let newUserDict: [String: Any] = [
            "UserID": userId,
            "created_at": FieldValue.serverTimestamp(),
            // Initialize other fields as needed
        ]
        db.collection("User").document(userId).setData(newUserDict, completion: completion)
    }

    func updateUserData(userId: String, completion: @escaping (Error?) -> Void) {
        let updateData: [String: Any] = [
            "last_logged_in": FieldValue.serverTimestamp()
            // Update other fields as needed
        ]
        db.collection("User").document(userId).updateData(updateData, completion: completion)
    }

    
    func fetchUsernames(completion: @escaping (Result<[peopleInfo], Error>) -> Void) {
        db.collection("User").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))  // Return empty if no documents
                return
            }
            
            let peoples = documents.map { doc -> peopleInfo in
                let data = doc.data()
                let name = data["UserName"] as? String ?? "No Name"
                let emoji = data["Memoji"] as? Int ?? 1  // Default emoji if not found
                return peopleInfo(id: doc.documentID, emoji: emoji, name: name)
            }
            
            completion(.success(peoples))
        }
    }

    
    }



//db.collection("your_collection").addDocument(data: yourData) { error in
//    if let error = error {
//        print("Error adding document: \(error)")
//    } else {
//        print("Document added with ID: \(ref.documentID)")
//    }
//}
