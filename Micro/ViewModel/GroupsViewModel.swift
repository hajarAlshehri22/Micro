//
//  GroupsViewModel.swift
//  Micro
//
//  Created by Hajar Alshehri on 08/11/1445 AH.
//

import SwiftUI
import Combine

class GroupsViewModel: ObservableObject {
    @Published var groups: [GroupInfo] = []
    @Published var isGroupViewPresented = false
    
    init() {
        fetchGroups()
    }
    
    func fetchGroups() {
        FirestoreManager.shared.fetchGroupData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let groups):
                    self.groups = groups
                case .failure(let error):
                    print("Error fetching groups: \(error)")
                }
            }
        }
    }
    
    func saveGroup(name: String, members: [peopleInfo], completion: @escaping () -> Void) {
        FirestoreManager.shared.saveGroupData(name: name, members: members) { error in
            if let error = error {
                print("Error saving group: \(error)")
            } else {
                self.fetchGroups()  // Refresh groups after saving
                DispatchQueue.main.async {
                    completion()  // Call completion handler on the main thread
                }
            }
        }
    }
}
