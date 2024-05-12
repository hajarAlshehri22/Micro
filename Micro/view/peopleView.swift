import SwiftUI

struct peopleView: View {
    
    @State private var isAddingPeople = true
    @State private var peoples:[peopleInfo] = []
    @State var peopleDic: [peopleInfo:Bool] = [:]
    
    let people:[peopleInfo] = [
        peopleInfo(emoji: 1, name: "Renad"),
        peopleInfo(emoji: 4, name: "Basemah"),
        peopleInfo(emoji: 2, name: "Hamad"),
        peopleInfo(emoji: 3, name: "Taif"),
        peopleInfo(emoji: 1, name: "Sarah"),
        peopleInfo(emoji: 5, name: "Khalid"),
        peopleInfo(emoji: 3, name: "Danah"),
    ]
    
    @State private var searchText = ""
    
    
    var body: some View {
//        NavigationView {
            
            VStack() { // Add spacing between elements
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color("AccentColor"))
                        .frame(width: 165, height: 2)
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("AccentColor"))
                        .frame(width: 165, height: 2)
                }.padding(.bottom,15)
                
                Spacer()
                SearchBar(text: $searchText)
                    .padding(.bottom,25)
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Action when the text is clicked
                    }) {
                        VStack(alignment: .trailing, spacing: 0) {
                            Text(LocalizedStringKey("اضافة عن طريق رقم الجوال"))
                                .font(.system(size: 14))
                                .foregroundColor(Color("AccentColor"))
                            
                            Rectangle()
                                .frame(width: 127,height: 1)
                                .foregroundColor(Color("AccentColor")) // Line color
                        }.padding(.horizontal, 20) // Add horizontal padding
                    }
                }
                
                Spacer()
                
                Divider().frame(width:330,height: 2)
                
                Spacer()
                
                // List of People
                List(filteredPeople) { peopleInfo in
                    HStack {
                        Image("memoji\(peopleInfo.emoji)")
                            .resizable().frame(width: 40,height: 40)
                        Text(peopleInfo.name)
                        Spacer()
                        
                        Button(action: {
                            // Toggle the boolean value for the selected person
                            peopleDic[peopleInfo, default: false].toggle()
                        }) {
                            if !(peopleDic[peopleInfo] ?? false) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width: 20,height: 20)
                                    .foregroundColor(Color("Plus"))
                                    .font(.title)
                                    .cornerRadius(15)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable().frame(width: 20,height: 20)
                                    .foregroundColor(.yellow)
                                    .opacity(0.8)
                                    .font(.title)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.trailing, 10) // Add trailing padding
                    }
                }
                .listStyle(PlainListStyle()) // Set list style to plain
                .background(Color.white) // Set background color of the List to white
                
                
                Spacer()
                
                NavigationLink(destination: calenderView()) {
                    Text(LocalizedStringKey("تم!"))
                        .padding()
                        .frame(width: 229, height: 53)
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .bold()
                        .font(.headline)
                }
            }
            .padding(.horizontal, 20)// Add horizontal padding to the VStack
            .navigationBarTitle(Text(LocalizedStringKey("جمّعهم")), displayMode: .large)
           
//        }
//        Spacer()
    }
    
    var filteredPeople: [peopleInfo] {
        if searchText.isEmpty {
            return people
        } else {
            return people.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
