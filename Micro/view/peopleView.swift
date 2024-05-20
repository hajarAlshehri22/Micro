import SwiftUI


struct peopleView: View {
    
    let groupName: String
    @State private var isAddingPeople = true
    @State private var peoples: [peopleInfo] = []
    @State var peopleDic: [peopleInfo: Bool] = [:]
    @State private var isLoading = true
    let people: [peopleInfo] = []
    @EnvironmentObject var vm: ViewModel
    
    @State private var searchText = ""
    @State private var showGroupsView = false // State to control navigation
    
    var filteredPeople: [peopleInfo] {
        if searchText.isEmpty {
            return peoples
        } else {
            return peoples.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        @EnvironmentObject var vm: ViewModel
        NavigationStack {
            VStack {
                NavigationLink(destination: GroupsView(), isActive: $showGroupsView) {
                    EmptyView()
                }
                
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color("AccentColor"))
                        .frame(width: 165, height: 2)
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("AccentColor"))
                        .frame(width: 165, height: 2)
                }
                .padding(.bottom, 15)

                Spacer()
                SearchBar(text: $searchText)
                Spacer()

                List(filteredPeople, id: \.id) { peopleInfo in
                    HStack {
                        Image("memoji\(peopleInfo.emoji)")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(peopleInfo.name)
                        Spacer()
                        
                        Button(action: {
                            peopleDic[peopleInfo, default: false].toggle()
                        }) {
                            Image(systemName: !(peopleDic[peopleInfo] ?? false) ? "plus.circle.fill" : "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(!(peopleDic[peopleInfo] ?? false) ? Color("Plus") : .yellow)
                                .opacity(!(peopleDic[peopleInfo] ?? false) ? 1.0 : 0.8)
                                .font(.title)
                                .cornerRadius(15)
                        }
                        .padding(.trailing, 10)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.white)

                Button {
                    let selectedMembers = peopleDic.filter { $0.value }.map { $0.key }
                    FirestoreManager.shared.saveGroupData(name: groupName, members: selectedMembers) { error in
                        DispatchQueue.main.async {
                            if error == nil {
                                self.showGroupsView = true
                            } else {
                                print("Error saving group data: \(error!.localizedDescription)")
                            }
                        }
                    }
                } label: {
                    Text("تم!")
                        .padding()
                        .frame(width: 229, height: 53)
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .bold()
                        .font(.headline)
                }
            }
            
            .padding(.horizontal, 20)
            .onAppear {
                fetchPeople()
                
            }
            .navigationBarTitle("جمّعهم", displayMode: .large)
            
        }
    }

    private func fetchPeople() {
        FirestoreManager.shared.fetchUsernames { result in
            switch result {
            case .success(let people):
                self.peoples = people
            case .failure(let error):
                print("Error fetching people: \(error.localizedDescription)")
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
        }
        .padding(.horizontal, 15)
    }
}



struct peopleView_Previews: PreviewProvider {
    static var previews: some View {
        peopleView(groupName: " ")
    }
}
