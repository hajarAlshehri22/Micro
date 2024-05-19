    //
    //  UserInfo.swift
    //  Micro
    //
    //  Created by Hajar Alshehri on 26/10/1445 AH.
    //

import SwiftUI
import Firebase

struct UserInfo: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var selectedImage: Int?
    @State private var NavigateToGroup = false
    @State private var usernameError: String? // For displaying username errors if it is taken
    @State private var isCheckingUsername = false // To handle enabling/disabling the submit button
    
    var body: some View {
         ZStack {
             Image("Splash")
                 .resizable()
                 .scaledToFill()
                 .edgesIgnoringSafeArea(.all) // Make sure the background fills the entire screen

             ScrollView { // Encapsulate all content in a ScrollView
                 VStack {
                     Image("Jammah").resizable().frame(width: 270, height: 115).padding(.top, 20)
                     userForm()
                     if let usernameError = usernameError {
                         Text(usernameError) // Show error message if username is taken
                             .foregroundColor(.red)
                             .padding()
                     }
                     submitButton()
                     Spacer(minLength: 20) // Provide some space at the bottom
                 }
                 }

                 // Navigation Link for navigation
             NavigationLink(destination: GroupsView().navigationBarBackButtonHidden(true), isActive: $NavigateToGroup) {
                     EmptyView()
                 }
             }
         }

     private func userForm() -> some View {
         ZStack {
             Rectangle().fill(Color.white)
                 .frame(width: 325, height: 580)
                 .shadow(radius: 10)
                 .cornerRadius(20)
             VStack {
                 Text("معلوماتي")
                     .bold()
                     .foregroundColor(Color("AccentColor"))
                     .padding()

                 Divider().frame(width: 280).padding(.bottom, 25)

                 userInfoField(label: "الإسم:", placeholder: "أدخل اسمك هنا", text: $name)
                 userInfoField(label: "اسم المستخدم:", placeholder: "أدخل اسم المستخدم هنا", text: $username)

                 Text("اختر شخصيتك:")
                     .padding(.trailing, 160)
                     .foregroundColor(Color("AccentColor"))
                     .font(.system(size: 15))
                     .bold()

                 avatarSelectionGrid()
             }
         }
     }

    private func submitButton() -> some View {
        Button("التالي") {
            isCheckingUsername = true
            FirestoreManager.shared.checkUsernameUnique(username: username) { isUnique in
                if isUnique {
                    FirestoreManager.shared.saveUserData(userId: Auth.auth().currentUser?.uid ?? "", name: name, username: username, selectedImage: selectedImage ?? 1) { error in
                        if let error = error {
                            print("Error saving user data: \(error.localizedDescription)")
                            usernameError = "Failed to save user data. Please try again."
                            isCheckingUsername = false
                        } else {
                            print("Data saved successfully, navigating to Calendar.")
                            NavigateToGroup = true  // Ensure this line is executed
                            isCheckingUsername = false
                        }

                    }
                } else {
                    usernameError = "This username is already taken. Please choose another."
                    isCheckingUsername = false
                }
            }
        }
        .frame(width: 189, height: 48)
        .background(Color("SecB"))
        .foregroundColor(.white)
        .cornerRadius(24)
        .disabled(name.isEmpty || username.isEmpty || selectedImage == nil || isCheckingUsername)
    }

    
        
        private func userInfoField(label: String, placeholder: String, text: Binding<String>) -> some View {
            VStack(alignment: .trailing) {
                Text(label)
                    .foregroundColor(Color("AccentColor"))
                    .font(.system(size: 18))
                    .padding(.horizontal, 20)
                    .frame(width: 280, alignment: .leading)
                
                TextField(placeholder, text: text)
                    .font(.system(size: 14))
                    .padding(.horizontal, 20)
                    .frame(width: 280, height: 41)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
            }
            .frame(width: 325, alignment: .leading)
        }
        
        private func avatarSelectionGrid() -> some View {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 280, height: 180)
                    .shadow(radius: 10)
                    .cornerRadius(20)
                
                VStack {
                    ForEach([[1, 2, 3], [4, 5, 6]], id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { id in
                                imageButton(id: id, imageName: "memoji\(id)")
                            }
                        }
                    }
                }
            }
        }
        
        private func imageButton(id: Int, imageName: String) -> some View {
            Button(action: {
                self.selectedImage = id
            }) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color("AccentColor"), lineWidth: selectedImage == id ? 4 : 0)
                    )
            }
        }
   
    }
    



    #Preview {
        UserInfo()
    }
