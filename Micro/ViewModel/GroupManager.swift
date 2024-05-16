//
//  GroupManager.swift
//  Micro
//
//  Created by Hajar Alshehri on 08/11/1445 AH.
//

import Combine
import FirebaseFirestore // If you're using Firestore
class GroupManager: ObservableObject {
    @Published var groups: [Group] = []

    func fetchGroups(userID: String) {
        FirestoreManager.shared.fetchGroups(userID: userID) { [weak self] result in
            switch result {
            case .success(let groups):
                self?.groups = groups
            case .failure(let error):
                print("Error fetching groups: \(error.localizedDescription)")
            }
        }
    }

    func addGroup(newGroup: Group) {
        groups.append(newGroup)
    }
}
