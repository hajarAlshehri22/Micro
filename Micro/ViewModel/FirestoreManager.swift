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
    func saveEvent(name: String, date: Date, locationURL: String, groupID: String, completion: @escaping (Error?) -> Void) {
            let eventData: [String: Any] = [
                "name": name,
                "EvenDate": Timestamp(date: date),
                "location": locationURL,
                "groupID": groupID
            ]

            db.collection("Event").addDocument(data: eventData) { error in
                completion(error)
            }
        }

        func fetchEvents(groupID: String, completion: @escaping ([Event]) -> Void) {
            db.collection("Event").whereField("groupID", isEqualTo: groupID).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching events: \(error.localizedDescription)")
                    completion([])
                } else {
                    let events = snapshot?.documents.compactMap { doc -> Event? in
                        let data = doc.data()
                        let name = data["name"] as? String ?? ""
                        let date = (data["EvenDate"] as? Timestamp)?.dateValue() ?? Date()
                        let locationURL = data["location"] as? String ?? ""
                        return Event(id: doc.documentID, name: name, date: date, locationURL: locationURL)
                    } ?? []
                    completion(events)
                }
            }
        }
    
    
    // This function checks if it is a new user; if not, it goes to the main page (Calendar view)
    func determineUserFlow(userId: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = db.collection("User").document(userId)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Check if all required fields are filled
                let data = document.data()
                let username = data?["UserName"] as? String ?? ""
                let name = data?["FullName"] as? String ?? ""
                let memoji = data?["Memoji"] as? Int ?? 0
                
                if !username.isEmpty && !name.isEmpty && memoji > 0 {
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
                    "Memoji": selectedImage,
                    "BusyDay": [Timestamp](),
                    "UserName": username
                ]
                
                userRef.setData(userDict) { error in
                    completion(error)
                }
            }
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<(name: String, username: String, memoji: String), Error>) -> Void) {
        let userRef = db.collection("User").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["FullName"] as? String ?? ""
                let username = data?["UserName"] as? String ?? ""
                let memoji = data?["Memoji"] as? String ?? ""
                completion(.success((name, username, memoji)))
            } else {
                completion(.failure(error ?? NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
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
                let emoji = data["Memoji"] as? Int ?? 1  // Default to 1 if not found
                return peopleInfo(id: doc.documentID, emoji: emoji, name: name)
            }
            
            completion(.success(peoples))
        }
    }
    
    
    func saveGroupData(name: String, members: [peopleInfo], completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let memberIDs = members.map { $0.id } // Assuming `id` is the correct unique identifier for members.
        
        // Create a new document reference with an auto-generated ID
        let newGroupRef = db.collection("Group").document()
        
        // Prepare group data dictionary
        let groupDict: [String: Any] = [
            "groupID": newGroupRef.documentID,  // Using the auto-generated document ID as the groupID
            "name": name,
            "memberIDs": memberIDs
        ]
        
        // Set the data for the new group
        newGroupRef.setData(groupDict) { error in
            if let error = error {
                print("Error saving group: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Group has been added successfully!")
            }
        }
    }
    
    
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var memojiName: String = ""
    
    func fetchUserData(userId: String, completion: @escaping (Result<(name: String, username: String, memoji: Int), Error>) -> Void) {
        let userRef = db.collection("User").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["FullName"] as? String ?? ""
                let username = data?["UserName"] as? String ?? ""
                let memoji = data?["Memoji"] as? Int ?? 1 // Ensure this is an Int
                completion(.success((name, username, memoji)))
            } else {
                completion(.failure(error ?? NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }

    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()

    func fetchBusyMembers(date: Date, groupID: String, completion: @escaping ([peopleInfo]) -> Void) {
        let busyDayRef = db.collection("Group").document(groupID).collection("BusyDays")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        busyDayRef.whereField("date", isEqualTo: dateString).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                completion([])
                return
            }

            var members: [peopleInfo] = []
            let group = DispatchGroup()

            for document in documents {
                let data = document.data()
                if let userId = data["userID"] as? String {
                    group.enter()
                    self.fetchUserData(userId: userId) { result in
                        switch result {
                        case .success(let userData):
                            let member = peopleInfo(id: userId, emoji: userData.memoji, name: userData.name)
                            members.append(member)
                        case .failure(let error):
                            print("Error fetching user data: \(error.localizedDescription)")
                        }
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                completion(members)
            }
        }
    }



        func addBusyDay(userId: String, date: Date, groupID: String, completion: @escaping (Error?) -> Void) {
            let busyDayRef = db.collection("Group").document(groupID).collection("BusyDays").document("\(userId)_\(dateFormatter.string(from: date))")
            let data: [String: Any] = [
                "userID": userId,
                "date": dateFormatter.string(from: date)
            ]
            busyDayRef.setData(data, completion: completion)
        }

        func fetchAllBusyDays(groupID: String, completion: @escaping ([Date]) -> Void) {
            let busyDayRef = db.collection("Group").document(groupID).collection("BusyDays")
            busyDayRef.getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dates: [Date] = documents.compactMap {
                    if let dateString = $0.data()["date"] as? String {
                        return dateFormatter.date(from: dateString)
                    }
                    return nil
                }
                completion(dates)
            }
        }
    
}

