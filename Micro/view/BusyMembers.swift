//
//  BusyMembers.swift
//  Micro
//
//  Created by Hajar Alshehri on 04/11/1445 AH.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct BusyMembers: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var selectedDate: Date
    let groupID: String
    @State private var isAddingBusyDay = false

    var body: some View {
        VStack {
            Text("المشغولين في هذا اليوم:")
                .font(.headline)
                .padding()

            if viewModel.busyMembers.isEmpty {
                Text("مافيه احد مشغول\nاستغل اليوم وخله يوم جمعتكم!")
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(viewModel.busyMembers, id: \.id) { member in
                    HStack {
                        Image("memoji\(member.emoji)")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(member.name)
                    }
                }
            }

            Spacer()

            Button(action: {
                addBusyDay()
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("مشغول؟ .. اضغط علامة + لاضافة انشغالك")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            fetchBusyMembers()
        }
    }

    private func addBusyDay() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let currentUser = viewModel.currentUser else { return }

        FirestoreManager.shared.addBusyDay(userId: userId, date: selectedDate, groupID: groupID) { error in
            if let error = error {
                print("Error adding busy day: \(error.localizedDescription)")
            } else {
                // Directly update the state without re-fetching if you trust local state
                viewModel.busyDays.append(selectedDate)
                viewModel.busyMembers.append(currentUser)
                
                // Fetch the latest busy members from Firestore to ensure consistency
                fetchBusyMembers()
            }
        }
    }

    private func fetchBusyMembers() {
        viewModel.fetchBusyMembers(date: selectedDate, groupID: groupID)
    }
}
