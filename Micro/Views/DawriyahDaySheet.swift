//
//  File.swift
//  Micro
//
//  Created by Renad Alqarni on 24/04/2024.
//

import SwiftUI
import CloudKit

struct DawriyahDaySheet: View {
    @EnvironmentObject var vm: ViewModel
    @State var addressD: String = ""
    @State var dawriyahDay: Date
    @State var startD = Date()
    @State var endD = Date()
    @State var notes: String = ""
    //@Binding private var isDawriyahAdded: Bool
    
    @Environment(\.dismiss) var dismiss

    init(dawriyahDay: Date = Date() ) {
           self._dawriyahDay = State(initialValue: dawriyahDay)
      //  self.isDawriyahAdded = isDawriyahAdded
       }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select Dawriyah Day").bold().offset(y: -40)
                
                Text("address")
                    .font(.title2)
                    
                    .foregroundColor(Color("LightPurple"))
                    .padding(.trailing, 250.0)
                
                TextField("", text: $addressD)
                    .padding()
                    .frame(width: 302, height: 58)
                    .background(Color("TextField"))
                    .cornerRadius(15)
                    .foregroundColor(Color("TitleC"))
                    .bold()
                    .padding(.bottom, 30.0)
                
                Divider()
                
                HStack(spacing: 20) {
                    Text("Choose day")
                        .font(.title2)
                        .foregroundColor(Color("LightPurple"))
                        .padding(.leading, -70.0)
                    
                    DatePicker("", selection: $dawriyahDay, displayedComponents: [.date])
                        .frame(width: 105.0)
                        .background(Color("SplashColor"))
                        .cornerRadius(15)
                    
                }
                Divider()
                
                HStack {
                    Text("Start Time")
                        .font(.title2)
                        .foregroundColor(Color("LightPurple"))
                        .padding(.leading, -120.0)
                    
                    DatePicker("", selection: $startD, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .background(Color("SplashColor"))
                        .cornerRadius(15)
                }
                
                HStack {
                    Text("End Time")
                        .font(.title2)
                        .foregroundColor(Color("LightPurple"))
                        .padding(.leading, -120.0)
                    
                    DatePicker("", selection: $endD, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .background(Color("SplashColor"))
                        .cornerRadius(15)
                }
                
                Divider()
                
                Text("notes :")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("LightPurple"))
                    .padding(.trailing, 250.0)
                
                TextField("", text: $notes)
                    .frame(width: 302, height: 150)
                    .background(Color("TextField"))
                    .cornerRadius(15)
                    .foregroundColor(Color("TitleC"))
                    .bold()
                    .padding(.bottom, 30.0)
                
                Divider()
                
                Button(action: {
                    saveToCloudKit()
                    dismiss()
                   // isDawriyahAdded.toggle()
                }, label: {
                    Text("Add Dawriyah")
                        .padding()
                        .frame(width: 229, height: 53)
                        .background(Color("LightPurple"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .bold()
                        .font(.headline)
                })
            }
        }
    }

    private func saveToCloudKit() {
        let dawriyah = Dawriyah(address: addressD, startTime: startD, endTime: endD, dawriyahDay: dawriyahDay, notes: notes)
        vm.dawriyah.append(dawriyah)
        let record = CKRecord(recordType: "Dawriyah")

        record.setValue(addressD, forKey: "address")
        record.setValue(dawriyahDay, forKey: "dawriyahDay")
        record.setValue(startD, forKey: "startTime")
        record.setValue(endD, forKey: "endTime")
        record.setValue(notes, forKey: "notes")

        let privateDatabase = CKContainer(identifier: "iCloud.Dawriyah").publicCloudDatabase

        privateDatabase.save(record) { (savedRecord, error) in
            if error == nil {
                print("Record saved")
            } else {
                print("Record not saved.. \(error?.localizedDescription ?? "")")
            }
        }
    }
}

struct DawriyahDaySheet_Previews: PreviewProvider {
    static var previews: some View {
        DawriyahDaySheet()
    }
}
