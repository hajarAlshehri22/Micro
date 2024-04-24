//
//  ContentView.swift
//  Micro
//
//  Created by Hajar Alshehri on 09/10/1445 AH.
//

import SwiftUI
import AuthenticationServices

struct SignIn: View {
    var body: some View {
        ZStack {
            Image("Splash") // Background image
            
            VStack {
                Image("Jammah")
                    .resizable()
                    .frame(width: 270, height: 100).padding(.top, 200)
                    
                
                Image("Slogan")
                    .resizable()
                    .frame(width: 350, height: 80).padding(.bottom, 40)
                Text("خطط لجمعاتك وخلها أمتع .. مع جَمعة ").padding(.bottom, 190)
                
                
                
                    // Sign In with Apple Button
                    SignInWithAppleButton(.signIn) { request in
                        // Handle authorization request here
                    } onCompletion: { result in
                        // Handle authorization result here
                    }
                    .frame(width: 280, height: 50)
                    .cornerRadius(24)
                    .signInWithAppleButtonStyle(.black)
                   
                
                Button("تصفح كزائر") {
                    // Action for the button can be handled here
                }
                .frame(width: 280, height: 50)
                .background(Color("SecB"))
                .foregroundColor(.white)
                .cornerRadius(24)
                .padding()
                
                
            }
        }
    }
}

#Preview {
    SignIn()
}
