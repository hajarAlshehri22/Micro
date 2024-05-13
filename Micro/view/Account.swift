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
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        Text("حسابي")
                    }
                    
                    NavigationLink(destination:
                                    VStack{
                        Image("memoji6").padding()
                        Divider()
                        
                        Text("الاسم:").font(.title3).padding(.trailing,274).padding(.top)
                        Rectangle() // The rectangle under "الاسم"
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 330, height: 40).cornerRadius(14)
                        
                        Text("اسم المستخدم:").font(.title3).padding(.trailing,200)
                        Rectangle() // The rectangle under "الاسم"
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 330, height: 40).cornerRadius(14)
                        
                        
                    }.padding(.bottom,450)
                    )
                    {
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
                        self.showingAlert = true
                    }
                }
            }
            
            .navigationBarTitle(Text("الإعدادات"))
           
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("تأكيد الاتصال"),
                    message: Text("هل تريد تأكيد الاتصال على: 0563830022؟"),
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
