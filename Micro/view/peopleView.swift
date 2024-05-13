
import SwiftUI
import Firebase

struct peopleView: View {
    @State private var isLoading = true
    @State private var peoples: [peopleInfo] = []
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color("AccentColor"))
                    .frame(width: 165, height: 2)
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("AccentColor"))
                    .frame(width: 165, height: 2)
            }.padding(.bottom, 15)

            SearchBar(text: $searchText)
                .padding(.bottom, 25)

            if isLoading {
                ProgressView("Loading...")
            } else {
                peopleList
            }

            Divider().frame(width: 330, height: 2)

            NavigationLink(destination: calenderView()) {
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
        .navigationBarTitle(Text("جمّعهم"), displayMode: .large)
    }
    
    var peopleList: some View {
        List(filteredPeople) { person in
            HStack {
                Image("memoji\(person.emoji)")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text(person.name)
                Spacer()
                Button(action: {
                    // Handle button action here
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.blue)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var filteredPeople: [peopleInfo] {
        if searchText.isEmpty {
            return peoples
        } else {
            return peoples.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func fetchPeople() {
        FirestoreManager.shared.fetchUsernames { result in
            switch result {
            case .success(let people):
                self.peoples = people
                self.isLoading = false
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
        peopleView()
    }
}
