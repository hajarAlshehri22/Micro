//
//  SignIn.swift
//  Micro
//
//  Created by Shahad Alzowaid on 15/10/1445 AH.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseAuth

struct SignIn: View {
    @State private var isAuthenticated = false

    var body: some View {
        NavigationView {
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
                        // Configure the request
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            // Handle authorization success
                            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                                handleAppleSignIn(credential: credential)
                            }
                        case .failure(let error):
                            // Handle error
                            print("Authentication error: \(error.localizedDescription)")
                        }
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
                // Navigation upon successful login
                .fullScreenCover(isPresented: $isAuthenticated, content: Entertainment.init)
            }
        }
    }
    
    private func handleAppleSignIn(credential: ASAuthorizationAppleIDCredential) {
        guard let appleIDToken = credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nil) // Specify the rawNonce if you are using it
        
        Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error: \(error.localizedDescription)")
                return
            }
            // User is signed in
            isAuthenticated = true  // Trigger navigation to TestView
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
