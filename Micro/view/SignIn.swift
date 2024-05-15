//
//  SignIn.swift
//  Micro
//
//  Created by Shahad Alzowaid on 15/10/1445 AH.
//

//
//  SignIn.swift
//  Micro
//
//  Created by Shahad Alzowaid on 15/10/1445 AH.
//

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
                    
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    }, onCompletion: handleAppleSignIn)
                    .frame(width: 280, height: 50)
                    .cornerRadius(24)
                    .signInWithAppleButtonStyle(.black)
                    
                    NavigationLink(destination: UserInfo(), isActive: $navigateToUserInfo) {
                        EmptyView()
                    }
                    .hidden()
                    
                    Button("تصفح كزائر") {
                        navigateToCalendar = true  // Set to true to navigate to CalendarView
                    }
                    .frame(width: 280, height: 50)
                    .background(Color("SecB"))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .padding()
                    
                    NavigationLink(destination: calenderView(), isActive: $navigateToCalendar) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        }
    }
    
    private func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                handleAppleIDCredential(credential)
            }
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
        }
    }
    
    private func handleAppleIDCredential(_ credential: ASAuthorizationAppleIDCredential) {
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to fetch identity token")
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
            guard let userId = authResult?.user.uid else { return }
            
            FirestoreManager.shared.determineUserFlow(userId: userId) { isNewUser in
                if isNewUser {
                    self.navigateToUserInfo = true  // Navigate to UserInfo to complete profile
                } else {
                    self.navigateToCalendar = true  // Profile is complete, navigate to Calendar
                }
            }
        }
    }
    
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
