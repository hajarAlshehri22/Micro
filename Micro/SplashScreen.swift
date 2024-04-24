//
//  SplashScreen.swift
//  Micro
//
//  Created by Shahad Alzowaid on 15/10/1445 AH.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack{
            Image("Splash")
            VStack{
                Image("LogoCard").resizable().frame(width: 370, height: 330).padding()
                
                Image("Jammah").resizable().frame(width: 270, height: 115).padding()
            }
        }
    }
}

#Preview {
    SplashScreen()
}

