//
//  File 4.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import SwiftUI
import CloudKit

struct CreateView: View {
    
    @State var dawriyahName: String = ""
    @State var startDate = Date()
   
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                    Color("backg").ignoresSafeArea()
                VStack(spacing: 20){
                    HStack(spacing:30){
                        RoundedRectangle(cornerRadius: 100).fill(Color("LightPurple")).frame(width: 145, height: 8)
                        
                        RoundedRectangle(cornerRadius: 25).fill(Color("LightPurple")).frame(width: 145, height: 8).opacity(0.37).padding()
                    }
                    
                    .padding(.bottom, 30.0)
                    
                    VStack(spacing:10){ Text("Dawriyah Name").fontWeight(.regular).padding(.leading, -170.0).font(.title2)
                        TextField("", text: $dawriyahName).padding().frame(width:340,height: 45).background(Color("TextField")).cornerRadius(18).foregroundColor(Color("TitleC")).bold()}.padding(.bottom, 10.0)
                    
                    Divider()
                .padding(.bottom, 20.0)
                   
                 
                   
                        .padding(.bottom, 240.0)
                    
                    NavigationLink(destination: peopleView()) {
                        Text("Add People").padding().frame(width: 229, height: 53).background(Color("LightPurple")).foregroundColor(.white).cornerRadius(20).bold().font(.headline)
                    }.padding(.top, 1.0)
                    Spacer()
                        
                }.padding()
                .navigationTitle("Create Dawriyah").foregroundColor(Color("TitleC"))
              
             .padding(.bottom,-50.0)
                
            }
        }.accentColor(Color("LightPurple"))
    }


    
}
#Preview {
    CreateView()
}
