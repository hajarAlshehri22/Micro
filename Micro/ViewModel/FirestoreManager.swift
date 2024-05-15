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
    
    //this function save Event sheet for gathering
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
    
    //this function check if it is new user go to people Info page if it not go to main page for now it is calender view
    func determineUserFlow(userId: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = db.collection("User").document(userId)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Check if all required fields are filled
                let data = document.data()
                let username = data?["UserName"] as? String ?? ""
                let name = data?["FullName"] as? String ?? ""
                let memoji = data?["Memoji"] as? String ?? ""
                
                if !username.isEmpty && !name.isEmpty && !memoji.isEmpty {
                    completion(false) // All fields are filled, navigate to Calendar
                } else {
                    completion(true) // Some fields are missing, navigate to UserInfo
                }
            } else {
                // No document found, considered new user
                completion(true) // Navigate to UserInfo to fill in profile
            }
        }
    }



    //this function save user data , name memoji username and check if it is unique
    func saveUserData(userId: String, name: String, username: String, selectedImage: Int, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let memojiName = "memoji\(selectedImage)"
        let userRef = db.collection("User").document(userId)

        // First, check if the username is unique
        db.collection("User").whereField("UserName", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking username uniqueness: \(error.localizedDescription)")
                completion(error)
                return
            }

            // Ensure the username is not taken by someone else
            if let docs = snapshot?.documents, !docs.isEmpty, docs.filter({ $0.documentID != userId }).count > 0 {
                // Username is taken by another user
                completion(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Username is already taken by another user."]))
            } else {
                // Username is either new or belongs to the current user, safe to proceed
                let userDict: [String: Any] = [
                    "UserID": userId,
                    "groupID": [String](),
                    "FullName": name,
                    "Memoji": memojiName,
                    "BusyDay": [Timestamp](),
                    "UserName": username
                ]

                userRef.setData(userDict) { error in
                    completion(error)
                }
            }
        }
    }

            
        
    // Function to check username uniqueness only
    func checkUsernameUnique(username: String, completion: @escaping (Bool) -> Void) {
        let usersRef = db.collection("User")

        usersRef.whereField("UserName", isEqualTo: username).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error checking username: \(error)")
                completion(false)
            } else if let snapshot = snapshot, snapshot.documents.isEmpty {
                completion(true)  // Username is unique
            } else {
                completion(false)  // Username is not unique
            }
        }
    }

    
    
    //this function fetch username 
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
    
    func saveGroupData(name: String, members: [String], completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let groupDict: [String: Any] = [
            "name": name,
            "Memoji": members
        ]
        
        db.collection("Group").document().setData(groupDict) { error in
            if let error = error {
                completion(error)
            } else {
                print("Group has been added successfuly !")
                // If user data saved successfully, save username as a separate document
            }
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
