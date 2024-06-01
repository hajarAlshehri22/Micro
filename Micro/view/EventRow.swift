//
//  EventRow.swift
//  Micro
//
//  Created by Hajar Alshehri on 20/11/1445 AH.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    
    // DateFormatter to format the date and time
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(dateFormatter.string(from: event.date)) // Display the date and time of the event
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                openMap(for: event.locationURL)
            }) {
                Image(systemName: "map")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }

    private func openMap(for location: String) {
        if let url = URL(string: location) {
            UIApplication.shared.open(url)
        }
    }
}





struct EventsListView: View {
    var events: [Event]

    var body: some View {
        VStack(alignment: .leading) {
            Text("الجَمعات")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.top)

            ScrollView {
                ForEach(events) { event in
                    EventRow(event: event)
                        .padding(.horizontal)
                        .padding(.top, 5)
                }
            }
        }
        .padding(.bottom, 50) // To give some space at the bottom
    }
}
