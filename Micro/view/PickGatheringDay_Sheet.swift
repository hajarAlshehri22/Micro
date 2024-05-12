//
//  gathering_Sheet.swift
//  Micro
//
//  Created by Hajar Alshehri on 19/10/1445 AH.
//

import SwiftUI
import MapKit


struct PickGatheringDay_Sheet: View {
    @State private var gatheringName: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showingConfirmationAlert = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var locationURL: String?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("اسم الجَمعة : ")) {
                    TextField("ادخل اسم الجَمعة ", text: $gatheringName)
                }
                Section(header: Text("وقت الجَمعة")) {
                    DatePicker("اختر وقت : ", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                }
                Section(header: Text("مكان الجَمعة :")) {
                    TextField("ابحث عن مكان لجمعتكم ..", text: $searchText, onCommit: performSearch)
                    
                    
                    ZStack(alignment: .center) {
                        Map(coordinateRegion: $region, interactionModes: .all)
                            .frame(height: 300)
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                            .offset(y: -6) // You may need to adjust this value to better align the pin
                        
                        
                    }
                    
                    
                    
                    Button("تأكيد المكان") {
                        generateLocationURL()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Ensure URL generation completes.
                            if let url = locationURL {
                                print("Attempting to save: Name: \(gatheringName), Date: \(selectedDate), URL: \(url)")
                                FirestoreManager.shared.saveEvent(name: gatheringName, date: selectedDate, locationURL: url) { error in
                                    if let error = error {
                                        print("Error saving event: \(error.localizedDescription)")
                                    } else {
                                        showingConfirmationAlert = true
                                        print("Event saved successfully.")
                                    }
                                }
                            } else {
                                print("Location URL is nil, cannot save event.")
                            }
                        }
                    }
                    .frame(width: 189, height: 48)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .padding(.horizontal) // Centers the button horizontally within the section
                    .padding(.leading,50)
                    .alert(isPresented: $showingConfirmationAlert) {
                        Alert(title: Text("Success"), message: Text("Your event has been saved."), dismissButton: .default(Text("OK")))
                    }

                    
                    
                    
                    
                }
                
                if let url = locationURL {
                    Section {
                        Text("الموقع : ")
                        Link(url, destination: URL(string: url)!)
                        
                    }
                    
                }
            }
            
            .navigationBarTitle("إضافة جمعة", displayMode: .inline)
        }
    }
    
    func performSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            
            region.center = coordinate
            
        }
    }
    
    func generateLocationURL() {
        let coordinate = region.center
        locationURL = "https://www.google.com/maps/search/?api=1&query=\(coordinate.latitude),\(coordinate.longitude)"
        
        
    }
}

struct PickGatheringDay_Sheet_Previews: PreviewProvider {
    static var previews: some View {
        PickGatheringDay_Sheet()
    }
}


