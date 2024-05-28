//
//  ViewModel.swift
//  Micro
//
//  Created by Hajar Alshehri on 07/11/1445 AH.
//

import SwiftUI
import CoreLocation
import Firebase


final class ViewModel: ObservableObject {
    @Published var jamaah: [Jamaah] = []
    @Published var peopleInfo: [peopleInfo] = []
    @Published var busyDays: [Date] = []
    @Published var currentDate: Date = Date()
    @Published var selectedEvent: Event?
    @Published var groupName: String = ""
    @Published var errorMessage: String?
    @Published var groups: [Group] = []
    @Published var shouldShowTabView: Bool = true
    @ObservedObject var firebaseManager = FirebaseManager()

    func fetchGroupData(groupID: String) {
        let db = Firestore.firestore()
        
        // Query the Group collection for the document with the given groupID
        let groupRef = db.collection("Group").whereField("groupID", isEqualTo: groupID)
        
        // Fetch the document data
        groupRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching group: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            } else if let documents = snapshot?.documents, !documents.isEmpty, let document = documents.last {
                let data = document.data()
                if let name = data["name"] as? String,
                   let memberIDs = data["memberIDs"] as? [String] {
                    // Successfully retrieved the data
                    DispatchQueue.main.async {
                        self.groupName = name
                        self.peopleInfo = memberIDs.map { Micro.peopleInfo(id: $0, emoji: 1, name: "Placeholder") } // Update as per your peopleInfo struct
                    }
                } else {
                    // Data format is incorrect
                    let dataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                    self.errorMessage = dataError.localizedDescription
                }
            } else {
                // Document does not exist
                let notFoundError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Group not found"])
                self.errorMessage = notFoundError.localizedDescription
            }
        }
    }
    
    func loadEvents(groupID: String) {
           FirestoreManager.shared.fetchEvents(groupID: groupID) { events in
               self.busyDays = events.map { $0.date }
               self.jamaah = events.map { Jamaah(gatheringName: $0.name, selectedDate: $0.date, locationURL: $0.locationURL) }
           }
       }
    }
