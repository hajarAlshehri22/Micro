//
//  Account.swift
//  Micro
//
//  Created by Shahad Alzowaid on 03/11/1445 AH.
//
import SwiftUI
import UIKit

struct ContentView: View {
    @State private var showingAlert = false
    @State private var showingEmailAlert = false
    @ObservedObject var userModel = UserModel()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("الإعدادات")) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        Text("حسابي")
                    }
                    
                    NavigationLink(destination: accountInfoView)
                    {
                        Text("معلومات الحساب")
                    }
                }
                
                Section(header: Text("المزيد")) {
                    NavigationLink(destination: privacyPolicyView) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            Text("سياسة الخصوصية")
                        }
                    }
                    
                    Button("تواصل معنا") {
                        self.showingEmailAlert = true
                    }
                }
            }
            .navigationBarTitle(Text("الإعدادات"))
            .alert(isPresented: $showingEmailAlert) {
                Alert(title: Text("تواصل معنا"),
                      message: Text("JammahApp@gmail.com"),
                      primaryButton: .default(Text("نسخ")) {
                    UIPasteboard.general.string = "JammahApp@gmail.com"
                },
                      secondaryButton: .cancel(Text("إلغاء")))
            }
        }
        .onAppear {
            // Fetch user data when the view appears
            userModel.fetchUserData(userId: "your_user_id") // Replace with actual user ID
        }
    }

    var accountInfoView: some View {
        VStack {
            Image(userModel.memojiName)
                .padding(.top, 70)
                .padding()
            Divider()
            
            Text("الاسم: \(userModel.name)")
                .font(.title3)
                .padding(.trailing, 274)
                .padding(.top)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 330, height: 40)
                .cornerRadius(14)
            
            Text("اسم المستخدم: \(userModel.username)")
                .font(.title3)
                .padding(.trailing, 200)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 330, height: 40)
                .cornerRadius(14)
        }
        .padding(.bottom, 450)
    }

    var privacyPolicyView: some View {
        ScrollView {
            Text("سياسة الخصوصية:")
                .font(.title)
                .padding(.trailing, 170)
            Divider()
            Text("عندما تستخدم جَمعة ، فأنت تثق بنا في بياناتك الشخصية. نحن ملتزمون بالحفاظ على هذه الثقة. توضح سياسة الخصوصية بموجبها قواعد جَمعة فيما يتعلق بجمع البيانات الشخصية واستخدامها والإفصاح عنها عند استخدام تطبيقنا.")
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
