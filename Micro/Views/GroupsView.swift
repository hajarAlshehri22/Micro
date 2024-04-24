//
//  File 2.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import SwiftUI

struct GroupsView: View {
    
    @State private var isShowingProfileSheet = false
    
    let groupName:[String]=["Family", "Friends", "University"]
    let peoples:[ peopleInfo] = [
        peopleInfo(emoji: 1, name: "Fahad"),
        peopleInfo(emoji: 2, name: "Shahad"),
        peopleInfo(emoji: 3, name: "Sarah"),
        peopleInfo(emoji: 5, name: "Mohammed"),
        peopleInfo(emoji: 6, name: "Others")
    ]
    
    var body: some View {
        NavigationStack{
            
            VStack {
                           HStack {
                               Text("Dawriyah Groups")
                                   //.font(.largeTitle)
                                   .foregroundColor(Color.black).fontWeight(.regular).font(.system(size: 34))
                                   .offset(y: 6)
                                   .offset(x: 20)
                            
                                  

                               Spacer()

                             
                           }
                           .padding()
                           .background(Color("backg"))
                       }
                       .navigationBarHidden(true)
            
            Rectangle()
                .frame(height: 1) // Adjust the height to make it thicker
                .foregroundColor(Color.gray) // Set the color
                .padding(.horizontal, 40)
                .opacity(0.5)
            
            VStack{
                
                /* Button(action:{
                 isShowingProfileSheet.toggle()
                 }) {
                 Image(systemName: "person.circle").font(.largeTitle).foregroundColor(Color("Color2")).padding(.top, -76.0).padding(.leading, 290.0)}
                 
                 .sheet(isPresented: $isShowingProfileSheet) {
                 ProfileSheet()
                 }*/
                
                ScrollView{
                    
                    HStack{Spacer()}
                    
                    ForEach(groupName, id: \.self) { group in
                        
                        NavigationLink {
                            CalendarPage()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).frame(width: 322, height: 101).foregroundColor(Color("LightGray")).opacity(0.40)
                                VStack(alignment: .leading, spacing: 20){
                                    Text(group).padding(.leading, 60.0) .foregroundColor(Color.black).fontWeight(.regular).font(.system(size: 20)).offset(y: 25)
                                    
                                        Divider()
                                        .padding(.horizontal, 50)
                                        .padding(.top, 12)
                                
                                    HStack(spacing:-25){
                                        ForEach(peoples) { person in
                                            Image("memoji\(person.emoji)")}
                                        .offset(y: -25) // Adjust the value to move the images up
                                        .scaleEffect(0.7) // Adjust the value to make the images smaller
                                        .offset(x: 41)
                                        Image(systemName: "chevron.right").padding(.leading,175)  .offset(y:-19).foregroundColor(Color("LightPurple"))
                                    }
                                    .padding(.leading, 4.0)
                                 
                                    
                                }
                            }
                        }


                    }
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).frame(width: 322, height: 101).foregroundColor(Color("LightGray")).opacity(0.40)
                        NavigationLink(destination: CalendarView()){
                            Image(systemName: "plus.circle").font(.system(size: 40)).foregroundColor(Color("LightPurple")).opacity(0.40)}
                        
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }.padding(.top, 10.0)
                
            }
//            .navigationTitle("Dawriyah Groups")
//                .toolbar {
//                Button(action:{
//                    isShowingProfileSheet.toggle()
//                }) {
//                    Image(systemName: "person.circle")
//                        .font(.largeTitle)
//                        .foregroundColor(Color("Color2"))
//                }
//                .sheet(isPresented: $isShowingProfileSheet) {
//                    ProfileSheet()}
//            }
            
            
            .background{Color("backg").ignoresSafeArea()
            }
            
        }
        .accentColor(Color("LightPurple"))
        
    }
}
#Preview {
    GroupsView()
}
