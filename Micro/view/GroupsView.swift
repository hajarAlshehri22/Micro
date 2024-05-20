//  GroupsView.swift
//  Micro
//
//  Created by Hajar Alshehri on 04/11/1445 AH.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class GroupViewModel: ObservableObject {
    @Published var groups: [Group] = []

    init() {
        fetchGroups()
    }

    func fetchGroups() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }

        Firestore.firestore().collection("Group")
            .whereField("memberIDs", arrayContains: userID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching groups: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No groups found")
                    return
                }

                self.groups = documents.compactMap { document -> Group? in
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? ""
                    let membersData = data["members"] as? [[String: Any]] ?? []
                    let members = membersData.map { peopleInfo(id: $0["id"] as? String ?? "", emoji: $0["emoji"] as? Int ?? 0, name: name) }
                    return Group(id: id, name: name, members: members)
                }

                print("Groups fetched: \(self.groups.count)")
            }
    }

    func fetchGroupData(groupID: String) {
        Firestore.firestore().collection("Group").document(groupID).getDocument { document, error in
            if let error = error {
                print("Error fetching group data: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists, let data = document.data() else {
                print("Group not found")
                return
            }

            let id = document.documentID
            let name = data["name"] as? String ?? ""
            let membersData = data["members"] as? [[String: Any]] ?? []
            let members = membersData.map { peopleInfo(id: $0["id"] as? String ?? "", emoji: $0["emoji"] as? Int ?? 0, name: name) }

            if let index = self.groups.firstIndex(where: { $0.id == id }) {
                self.groups[index] = Group(id: id, name: name, members: members)
            } else {
                self.groups.append(Group(id: id, name: name, members: members))
            }
        }
    }
}


// SwiftUI View that displays groups
struct GroupsView: View {
    @StateObject private var viewModel = GroupViewModel() // Using StateObject for view model initialization
    @EnvironmentObject var vm: ViewModel


    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("مجموعاتي")
                        .foregroundColor(Color.black)
                        .bold()
                        .fontWeight(.regular)
                        .font(.system(size: 34))
                        .offset(y: 6)
                        .offset(x: 20)
                    Spacer()
                }
                .padding()
//                .background(Color("backg"))
                .navigationBarHidden(true)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 40)
                    .opacity(0.5)
                
                ScrollView {
                    HStack { Spacer() }
                    
                    ForEach(viewModel.groups, id: \.id) { group in
                                            NavigationLink(destination: CalendarPage(group: group).environmentObject(vm)) {
                                                GroupRow(group: group)
                        }
                    }


                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0).frame(width: 322, height: 101).foregroundColor(Color.gray.opacity(0.2))
                        NavigationLink(destination: CreateView()) {
                            Image(systemName: "plus.circle").font(.system(size: 40)).foregroundColor(Color("LightPurble")).opacity(0.40)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.top, 10.0)
//                .background(Color("backg").ignoresSafeArea())
            }
            .onAppear{
                            vm.shouldShowTabView = true
                //            print( vm.shouldShowTabView)
                        }
            .accentColor(Color("LightPurble"))
        }.navigationBarBackButtonHidden()
    }
}

// Component for displaying each group as a row
struct GroupRow: View {
    var group: Group
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(Color.white)
                .shadow(radius: 2, x: 0, y: 2)
                .frame(height: 60)
            
            HStack {
                ForEach(group.members.prefix(4), id: \.id) { person in // Showing up to 4 emojis
                    Image("memoji\(person.emoji)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
                
                Spacer()
                
                Text(group.name)
                    .font(.headline)
                    .padding(.trailing, 20)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray)
            }
            .padding(.horizontal)
        }
    }
}



#Preview {
    GroupsView()
}
