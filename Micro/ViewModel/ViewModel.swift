//
//  ViewModel.swift
//  Micro
//
//  Created by Hajar Alshehri on 07/11/1445 AH.
//

import SwiftUI
import CoreLocation
import Firebase

class ViewModel: ObservableObject {
    @Published var jamaah: [Jamaah] = []
    @Published var peopleInfo: [peopleInfo] = []
    @Published var busyDays: [Date] = []
    @Published var gatheringDays: [Date] = []
    @Published var currentDate: Date = Date()
    @Published var selectedEvent: Event?
    @Published var groupName: String = ""
    @Published var errorMessage: String?
    @Published var groups: [Group] = []
    @Published var shouldShowTabView: Bool = true
    @Published var busyMembers: [peopleInfo] = []
    @Published var currentUser: peopleInfo? // Store current user's data

    func fetchGroupData(groupID: String) {
        let db = Firestore.firestore()
        let groupRef = db.collection("Group").whereField("groupID", isEqualTo: groupID)
        groupRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching group: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            } else if let documents = snapshot?.documents, !documents.isEmpty, let document = documents.last {
                let data = document.data()
                if let name = data["name"] as? String,
                   let memberIDs = data["memberIDs"] as? [String] {
                    DispatchQueue.main.async {
                        self.groupName = name
                        self.peopleInfo = memberIDs.map { Micro.peopleInfo(id: $0, emoji: 1, name: "Placeholder") }
                    }
                } else {
                    let dataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                    self.errorMessage = dataError.localizedDescription
                }
            } else {
                let notFoundError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Group not found"])
                self.errorMessage = notFoundError.localizedDescription
            }
        }
    }
    
    func loadEvents(groupID: String) {
        FirestoreManager.shared.fetchEvents(groupID: groupID) { events in
            self.gatheringDays = events.map { $0.date }
            self.jamaah = events.map { Jamaah(gatheringName: $0.name, selectedDate: $0.date, locationURL: $0.locationURL) }
        }
    }

    func fetchBusyMembers(date: Date, groupID: String) {
        FirestoreManager.shared.fetchBusyMembers(date: date, groupID: groupID) { members in
            DispatchQueue.main.async {
                self.busyMembers = members
            }
        }
    }
    
    func fetchBusyDays(groupID: String) {
        FirestoreManager.shared.fetchAllBusyDays(groupID: groupID) { dates in
            self.busyDays = dates
        }
    }

    func fetchCurrentUser(userID: String) {
        FirestoreManager.shared.fetchUserData(userId: userID) { result in
            switch result {
            case .success(let userData):
                self.currentUser = Micro.peopleInfo(id: userID, emoji: userData.memoji, name: userData.name)
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}
