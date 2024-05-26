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

// fetch busy User and add them from the firebase //

class FirebaseManager: ObservableObject {
    @Published var busyMembers: [peopleInfo] = []

    private var db = Firestore.firestore()

    func fetchBusyMembers() {
        db.collection("busyMembers").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }

            self.busyMembers = documents.map { docSnapshot -> peopleInfo in
                let data = docSnapshot.data()
                let id = docSnapshot.documentID
                let emoji = data["emoji"] as? Int ?? 1
                let name = data["name"] as? String ?? "Unknown"
                return peopleInfo(id: id, emoji: emoji, name: name)
            }
        }
    }
}


struct BusyMembers: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @State private var isButtonClicked = false
    @State private var currentUserImage: Image = Image("memoji1")
    @Binding var busyMembers: [peopleInfo]


    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .foregroundColor(.purple)
                    .frame(width: 350, height: 1)
                    .padding()

                if !isButtonClicked {
                    Text("مافيه احد مشغول استغل اليوم وخله يوم جمعتكم ")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .padding(.top, 250)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Display busy members
                ForEach(firebaseManager.busyMembers, id: \.id) { person in
                    HStack(alignment: .top) {
                        Image("memoji\(person.emoji)")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, -10)

                        Text("\(person.name)")
                            .font(.title)
                            .padding(.top, 5)
                    }
                }

                Spacer()

                Button(action: {
                    // Remove the current user from the busy members list
                    if let index = firebaseManager.busyMembers.firstIndex(where: { $0.name == "You" }) {
                        firebaseManager.busyMembers.remove(at: index)
                    }
                    isButtonClicked = false
                }) {
                    Text("Remove")
                        .foregroundColor(Color("AccentColor"))
                        .padding(.top, 85)
                }
            }
            .navigationTitle("المشغولين")
            .toolbar {
                Button(action: {
                    // Add current user data here
                    let currentUser = peopleInfo(id: UUID().uuidString, emoji: 2, name: "You") // Replace with actual user data
                    firebaseManager.busyMembers.append(currentUser)
                    isButtonClicked = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(Color("LightPurble"))
                        .padding(.top, 90)
                }
            }
            .onAppear {
                firebaseManager.fetchBusyMembers()
            }
        }
    }
}

struct BusyMembers_Previews: PreviewProvider {
    static var previews: some View {
        // Use a State variable to create a binding
        StatefulPreviewWrapper([peopleInfo(id: "1", emoji: 1, name: "John Doe")]) { busyMembers in
            BusyMembers(busyMembers: busyMembers)
                .previewLayout(.sizeThatFits)
        }
    }
}
struct StatefulPreviewWrapper<T: View>: View {
    @State private var value: [peopleInfo]
    let content: (Binding<[peopleInfo]>) -> T

    init(_ value: [peopleInfo], @ViewBuilder content: @escaping (Binding<[peopleInfo]>) -> T) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
