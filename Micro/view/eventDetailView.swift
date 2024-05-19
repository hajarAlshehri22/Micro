//
//  eventDetailView.swift
//  Micro
//
//  Created by Hajar Alshehri on 11/11/1445 AH.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CoreLocation


func fetchEvents(completion: @escaping ([Event]?, Error?) -> Void) {
    let db = Firestore.firestore()
    
    db.collection("Event").getDocuments { (querySnapshot, error) in
        if let error = error {
            completion(nil, error)
        } else {
            var events: [Event] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                if let name = data["name"] as? String,
                   let timestamp = data["EvenDate"] as? Timestamp,
                   let locationURL = data["location"] as? String {
                    
    let event = Event(id: document.documentID, name: name, date: timestamp.dateValue(), locationURL: locationURL)
        events.append(event)
                }
            }
            completion(events, nil)
        }
    }
}

struct eventDetailView: View {
    @State private var events: [Event] = []
    @State private var errorMessage: String?
    var event: Event

    var body: some View {
        VStack(spacing: 30) {
//                Rectangle()
//                    .frame(width: 340, height: 100)
//                    .foregroundColor(.textField)
//                    .cornerRadius(18)
            Text("أسم الطلعة:")
                .bold()
                .font(.title3)
                .padding(.leading, 100)
                .padding(.horizontal,90)
            
        ZStack{
            Rectangle()
                .frame(width: 330, height: 50)
                .foregroundColor(.lightPurble)
                .cornerRadius(18)
                .opacity(0.2)
//            Text("اسم الطلعه")
                    if let firstEvent = events.first {
            Text(" \(firstEvent.name)")
                            .bold()
                            .font(.title3)
                            .padding(.leading, 100)
                        
                    } else {
                        Text("أسم الطلعة")
                        .font(.title3)
                    .padding(.leading, 100)
                    .opacity(0.5)
                    .foregroundColor(.lightPurble)
                    }
                }
        Divider()
                .frame(width: 340)
            ZStack {
//                Rectangle()
//            .frame(width: 340, height: 200)
//            .foregroundColor(.textField)
//            .cornerRadius(18)

                VStack {
                    Text("مكان الجمعة:")
                        .bold()
                        .font(.title3)
                        .padding(.leading, 140)

            ZStack{
            Rectangle()
            .frame(width: 330, height: 130)
            .foregroundColor(.lightPurble)
            .cornerRadius(18)
            .opacity(0.2)
        if let firstEvent = events.first {
            Text(firstEvent.locationURL)
            .frame(width: 260, height: 100)
            .foregroundColor(.lightPurble)
            .cornerRadius(18)
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadEvents)
    }

    private func loadEvents() {
        fetchEvents { (events, error) in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let events = events {
                self.events = events
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        eventDetailView(event: Event(id: "1", name: "Sample Event", date: Date(), locationURL: "Sample Location"))
    }
}
