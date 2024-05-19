import SwiftUI
import UIKit
import FirebaseAuth

struct ContentView: View {
    @State private var showingAlert = false
    @State private var showingEmailAlert = false
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var memoji: String = "memoji1" // Default image
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("الإعدادات")) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        Text("حسابي")
                    }
                    
                    NavigationLink(destination: AccountInfoView(name: $name, username: $username, memoji: $memoji)) {
                        Text("معلومات الحساب")
                    }
                }
                
                Section(header: Text("المزيد")) {
                    NavigationLink(destination:
                        ScrollView {
                            Text("سياسة الخصوصية:").font(.title).padding(.trailing,170)
                            Divider()
                            Text("عندما تستخدم جَمعة ، فأنت تثق بنا في بياناتك الشخصية. نحن ملتزمون بالحفاظ على هذه الثقة. توضح سياسة الخصوصية بموجبها قواعد جَمعة فيما يتعلق بجمع البيانات الشخصية واستخدامها والإفصاح عنها عند استخدام تطبيقنا.").padding()
                        }) {
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
            .onAppear{
                vm.shouldShowTabView = true
    //            print( vm.shouldShowTabView)
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
            fetchUserData()
            
        }
    }
    
    private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        FirestoreManager.shared.fetchUserData(userId: userId) { result in
            switch result {
            case .success(let userData):
                name = userData.name
                username = userData.username
                memoji = userData.memoji
            case .failure(let error):
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }
}

struct AccountInfoView: View {
    @Binding var name: String
    @Binding var username: String
    @Binding var memoji: String
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Image(memoji).padding(.top, 70)
                .padding()
            Divider()
            
            Text("الاسم: \(name)").font(.title3).padding(.trailing, 274).padding(.top)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 330, height: 40).cornerRadius(14)
            
            Text("اسم المستخدم: \(username)").font(.title3).padding(.trailing, 200)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 330, height: 40).cornerRadius(14)
        }
        .padding(.bottom, 450)
        .onAppear{
            vm.shouldShowTabView = false
//            print( vm.shouldShowTabView)
        }
    }
}

#Preview {
    ContentView()
}
