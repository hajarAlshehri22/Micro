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
        @State private var NavigateToCalendar = false

        var body: some View {
            ZStack {
                Image("Splash")
                VStack {
                    Image("Jammah").resizable().frame(width: 270, height: 115).padding()
                    userForm()
                    submitButton()
                }
            }
        }

        // User form input fields and selection grid
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

        // Submit button with action to save user data
        private func submitButton() -> some View {
            Button("التالي") {
                guard let userId = Auth.auth().currentUser?.uid, let imageId = selectedImage, !username.isEmpty else {
                    print("Ensure all fields are filled and a user is logged in.")
                    return
                }
                FirestoreManager.shared.checkUsernameUnique(username: username) { isUnique in
                    if isUnique {
                        FirestoreManager.shared.saveUserData(userId: userId, name: name, username: username, selectedImage: imageId) { error in
                            if error == nil {
                                NavigateToCalendar = true
                            } else {
                                print("Error saving user data: \(error!.localizedDescription)")
                            }
                        }
                    } else {
                        print("Username is already taken. Please choose another.")
                    }
                }
            }
            .frame(width: 189, height: 48)
            .background(Color("SecB"))
            .foregroundColor(.white)
            .cornerRadius(24)
            .disabled(name.isEmpty || username.isEmpty || selectedImage == nil)
        }





        // User input field component with improved alignment
        private func userInfoField(label: String, placeholder: String, text: Binding<String>) -> some View {
            VStack(alignment: .trailing) {
                Text(label)
                    .foregroundColor(Color("AccentColor"))
                    .font(.system(size: 18))
                    .padding(.horizontal, 20) // Adjust horizontal padding to align text
                    .frame(width: 280, alignment: .leading) // Ensures the label is left-aligned

                TextField(placeholder, text: text)
                    .font(.system(size: 14))
                    .padding(.horizontal, 20)
                    .frame(width: 280, height: 41)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
            }
            .frame(width: 325, alignment: .leading) // Ensures everything in the VStack is left-aligned
        }
        // Grid for selecting an avatar image
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

        // Button for image selection
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
