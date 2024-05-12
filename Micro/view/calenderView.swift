//
//  calenderView.swift
//  Micro
//
//  Created by Hajar Alshehri on 29/10/1445 AH.
//

import SwiftUI

struct calenderView: View {
    @State private var showingMapView = false

       var body: some View {
           NavigationView {
               VStack {
                   Button(action: {
                       self.showingMapView.toggle()
                   }) {
                       Image(systemName: "plus")
                           .font(.largeTitle)
                           .padding()
                           .background(Color.blue)
                           .foregroundColor(.white)
                           .clipShape(Circle())
                   }
               }
               .sheet(isPresented: $showingMapView) {
                   PickGatheringDay_Sheet()
               }
               .navigationBarTitle("Calendar", displayMode: .inline)
           }
       }
   }

#Preview {
    calenderView()
}
