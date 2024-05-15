//
//  GroupsView.swift
//  Micro
//
//  Created by Hajar Alshehri on 04/11/1445 AH.
//

import SwiftUI

struct GroupsView: View {
    
    @State private var isShowingProfileSheet = false
    
    let groupName:[String]=[]
    let peoples:[ peopleInfo] = []
//    let memoji:[Memoji]
    
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
            calendarView()
            } label: {
        ZStack{
          RoundedRectangle(cornerRadius: 25.0).frame(width: 322, height: 101).foregroundColor(Color.gray.opacity(0.2)).opacity(0.40)
            
            
    VStack(alignment: .leading, spacing: 20){
                Text(group).padding(.leading, 60.0) .foregroundColor(Color.black).fontWeight(.regular).font(.system(size: 20)).offset(y: 25)
                                    
            Divider()
                .padding(.horizontal, 50)
                .padding(.top, 12)
                                
                HStack(spacing:-25){
                    ForEach(peoples) { person in
        Image("memoji\(person.emoji)")}
                    
            .frame(width: 38, height: 38)
            .offset(y: -25) // Adjust the value to move the images up
            .scaleEffect(0.3) // Adjust the value to make the images smaller
            .offset(x: 41)
      Image(systemName: "chevron.right").padding(.leading,175)  .offset(y:-19).foregroundColor(Color("LightPurble"))
                                    }
                .padding(.leading, 4.0)
                                    
                                }
                            }
                        }


                    }
                    
                    ZStack{
                        
            RoundedRectangle(cornerRadius: 25.0).frame(width: 322, height: 101).foregroundColor(Color.gray.opacity(0.2))
            NavigationLink(destination: CreateView()){
                Image(systemName: "plus.circle").font(.system(size: 40)).foregroundColor(Color("LightPurble")).opacity(0.40)}
                        
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
        .accentColor(Color("LightPurble"))
        
    }
}



#Preview {
    GroupsView()
}
