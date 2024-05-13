//
//  BusyMembers.swift
//  Micro
//
//  Created by Hajar Alshehri on 04/11/1445 AH.
//

import Foundation
import SwiftUI

struct BusyMembers: View {
    @Binding var busyMembers: [peopleInfo]
    @State private var isButtonClicked = false
    @State private var currentUserImage: Image = Image("memoji1")

    var body: some View {
        NavigationView{
            
    VStack{
        Rectangle()
        .foregroundColor(.purple)
                    .frame(width:350,height: 1)
                    .padding()
                
        if !isButtonClicked {
            Text("مافيه احد مشغول استغل اليوم وخله يوم جمعتكم ")
                
                .foregroundColor(.gray)
                .font(.title2)
            .padding(.top,250)
            .multilineTextAlignment(.center) 

                               }
                
                Spacer()

            // Display busy members
        ForEach(busyMembers, id: \.name) { person in
                    HStack(alignment: .top) {
                         
        Image("memoji\(person.emoji)")
            .resizable()
            .frame(width: 40, height: 40)
            .padding(.leading, -10)
                        
                        Text("\(person.name)")
                            .font(.title)
                            .padding(.top,5)
                     
                    }
                }

                Spacer()
                
                Button(action:{
                    // Remove the current user from the busy members list
                    if let index = busyMembers.firstIndex(where: { $0.name == "You" }) {
                        busyMembers.remove(at: index)
                    }
                    isButtonClicked = false
                }) {
    Text("Remove")
            .foregroundColor(Color("AccentColor"))
            .padding(.top,85)
                }
    }.navigationTitle("المشغولين ").toolbar {
                Button(action:{
//                    let currentUser = peopleInfo(id: String, emoji: 2, name: "You") // Replace with the actual user data
//                     busyMembers.append(currentUser)
//                    isButtonClicked = true
                }) {
            Image(systemName: "plus.circle")
            .font(.largeTitle)
            .foregroundColor(Color("LightPurble"))
            .padding(.top,90)
                }

                
            }
             }
 
    }
}

struct BusyMembers_Previews_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMembers: [peopleInfo] = []

        return BusyMembers(busyMembers: .constant(dummyMembers))
            .previewLayout(.sizeThatFits)
    }
}
