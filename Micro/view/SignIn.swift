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
    @State private var isGuest = false
    @State private var navigateToUserInfo = false  // State to control navigation to UserInfo
    @State private var navigateToCalendar = false  // State to control navigation to CalendarView
    
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
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                                handleAppleSignIn(credential: credential)
                            }
                        case .failure(let error):
                            print("Authentication error: \(error.localizedDescription)")
                        }
                    }
                    .frame(width: 280, height: 50)
                    .cornerRadius(24)
                    .signInWithAppleButtonStyle(.black)
                    
                    // Navigation link to UserInfo
                    NavigationLink(destination: UserInfo(), isActive: $navigateToUserInfo) {
                        EmptyView()
                    }
                    .hidden()
                    
                    // Button to browse as a guest
                    Button("تصفح كزائر") {
                        navigateToCalendar = true  // Set to true to navigate to CalendarView
                    }
                    .frame(width: 280, height: 50)
                    .background(Color("SecB"))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .padding()
                    
                    // Navigation link to CalendarView
                    NavigationLink(destination: calenderView(), isActive: $navigateToCalendar) {
                        EmptyView()
                    }
                    .hidden()
                }
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
                                                          rawNonce: nil)
        
        Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error: \(error.localizedDescription)")
                return
            }
            navigateToUserInfo = true  // Trigger navigation to UserInfo
        }
    }
}



struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
