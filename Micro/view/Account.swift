//
//  Account.swift
//  Micro
//
//  Created by Shahad Alzowaid on 03/11/1445 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("الإعدادات")) {
                    NavigationLink(destination: Text("Settings Detail View")) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            Text("حسابي")
                        }
                    }

                    NavigationLink(destination: Text("Messages Detail View")) {
                        
                            
                            Text("معلومات الحساب")
                        
                    }
                }

                Section(header: Text("المزيد")) {
                    NavigationLink(destination: Text("Locked Feature View")) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            Text("سياسة الخصوصية")
                        }
                    }

                    Button("تواصل معنا") {
                        self.showingAlert = true
                    }
                }
            }
            .navigationBarTitle(Text("الإعدادات"))
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("تأكيد الاتصال"),
                    message: Text("هل تريد تأكيد الاتصال على: 0505050505؟"),
                    primaryButton: .default(Text("اتصل")) {
                        // Code to initiate the call
                    },
                    secondaryButton: .cancel(Text("الغاء"))
                )
            }
        }
    }
}


#Preview {
    ContentView()
}
