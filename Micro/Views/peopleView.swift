//
//  File 3.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import SwiftUI

struct peopleView: View {
    
    @State private var isAddingPeople = true
    @State private var peoples:[ peopleInfo] = []
    @State var peopleDic: [peopleInfo:Bool] = [:]
   
    let people:[ peopleInfo] = [
        peopleInfo(emoji: 1, name: "Renad"),
        peopleInfo(emoji: 2, name: "Basemah"),
        peopleInfo(emoji: 3, name: "Reema"),
        peopleInfo(emoji: 1, name: "Taif"),
        peopleInfo(emoji: 1, name: "Sara"),
        peopleInfo(emoji: 2, name: "Basemah"),
        peopleInfo(emoji: 3, name: "Reema"),
        peopleInfo(emoji: 1, name: "Taif"),
        peopleInfo(emoji: 3, name: "Saraa")
    ]
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("backg").ignoresSafeArea()
                    VStack{
                    HStack(spacing: 30){
                        RoundedRectangle(cornerRadius: 100).fill(Color("LightPurple")).frame(width: 145, height: 8)
                        
                        RoundedRectangle(cornerRadius: 25).fill(Color("LightPurple")).frame(width: 145, height: 8).padding()
                    }
    //                   ScrollView(.horizontal){
    //                        HStack(spacing: 10){
    //                            ForEach(people) { person in
    //                                Image("memoji\(person.emoji)")}
    //                        }
    //                    }.padding()
                                List(people){peopleInfo in
                                    HStack{
                                    Image("memoji\(peopleInfo.emoji)")
                                     
                                    Text(peopleInfo.name)
                                        Spacer()
                                        
                                        Button(action: {
                                            
                                            
                                            peopleDic[peopleInfo]?.toggle()
                                            
                                           // if isAddingPeople {
                         // Simulating CloudKit record addition
                        // let newPerson = peopleInfo(emoji: 4, name: "New Person")
                              //   peoples.append(newPerson)
                                                
                           // Call CloudKit function to add newPerson to  CloudKit database
                         // Example: cloudKitManager.addPersonToCloudKit(newPerson)
                                          //  }
    //                                        isAddingPeople.toggle()
                                            
                                        }, label: {
                                            if !(peopleDic[peopleInfo] ?? false){
                                                Image(systemName: "plus.circle.fill").foregroundColor(.gray).opacity(0.5).font(.title).background(Color.white).cornerRadius(15)
                                                         } else {
                                                             Image(systemName: "checkmark.circle.fill")
                                                                 .foregroundColor(.green).opacity(0.8).font(.title).background(Color.white).cornerRadius(15)}})}.background(Color("backg"))}
                        
                        NavigationLink(destination: GroupsView()) {
                         Text("Create!").padding().frame(width: 229, height: 53).background(Color("LightPurple")).foregroundColor(.white).cornerRadius(20).bold().font(.headline)
                     }.padding(.top, 30.0)
                            }
              
            }.navigationTitle("Add people").foregroundColor(Color("LightPurple")).bold()
                .padding()
                    
        }.accentColor(Color("LightPurple"))
            .onAppear{
                self.people.forEach { person in
                    self.peopleDic[person] = false
                }
                
            }
            
            }
    
        }
              
  


#Preview {
    peopleView()
}
