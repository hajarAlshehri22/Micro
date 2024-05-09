//
//  SplashScreen.swift
//  Micro
//
//  Created by Shahad Alzowaid on 15/10/1445 AH.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
                    SignIn()
                } else {
                    ZStack {
                        Image("Splash")
                        VStack {
                            Image("LogoCard")
                                .resizable()
                                .frame(width: 370, height: 330)
                                .padding()

                            Image("Jammah")
                                .resizable()
                                .frame(width: 270, height: 115)
                                .padding()
                        }
                    }
                    // Trigger the transition after 4 seconds
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
                }
            }
        }

#Preview {
    SplashScreen()
}

