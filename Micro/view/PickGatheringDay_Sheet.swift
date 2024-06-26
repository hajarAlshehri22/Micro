//
//  gathering_Sheet.swift
//  Micro
//
//  Created by Hajar Alshehri on 19/10/1445 AH.
//

import SwiftUI
import MapKit
import Firebase
import CoreLocation

struct PickGatheringDay_Sheet: View {
    @EnvironmentObject var vm: ViewModel
    @State private var gatheringName: String = ""
    @State private var selectedDate: Date = Date()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var locationCoordinates: CLLocationCoordinate2D?
    @State private var searchText: String = ""
    @StateObject private var locationManager = LocationManager()
    let groupID: String

    @Environment(\.dismiss) var dismiss

    init(selectedDate: Date = Date(), groupID: String) {
        self._selectedDate = State(initialValue: selectedDate)
        self.groupID = groupID
    }

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
                            .offset(y: -6)
                    }
                    Button("تأكيد المكان") {
                        locationCoordinates = region.center
                        saveDate()
                    }
                    .frame(width: 189, height: 48)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(24)
                    .padding(.horizontal)
                    .padding(.leading, 50)
                }
                if let coordinates = locationCoordinates {
                    Section {
                        Text("الموقع: \(coordinates.latitude), \(coordinates.longitude)")
                    }
                }
            }
            .navigationBarTitle("إضافة جمعة", displayMode: .inline)
            .environment(\.layoutDirection, .rightToLeft)
            .onAppear {
                if let userLocation = locationManager.userLocation {
                    region.center = userLocation
                }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation {
                    region.center = newLocation
                }
            }
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
    
    private func saveDate() {
        let jamaah = Jamaah(gatheringName: gatheringName, selectedDate: selectedDate, locationURL: "hhh")
        vm.jamaah.append(jamaah)
        if let coordinates = locationCoordinates {
            let locationURL = "https://www.google.com/maps/search/?api=1&query=\(coordinates.latitude),\(coordinates.longitude)"
            FirestoreManager.shared.saveEvent(name: gatheringName, date: selectedDate, locationURL: locationURL, groupID: groupID) { error in
                if let error = error {
                    print("Error saving event: \(error.localizedDescription)")
                } else {
                    print("Event saved successfully")
                    dismiss() // Dismiss the sheet after saving
                }
            }
        }
    }
}

struct PickGatheringDay_Sheet_Previews: PreviewProvider {
    static var previews: some View {
        PickGatheringDay_Sheet(groupID: "sampleGroupID")
            .environmentObject(ViewModel())
    }
}



extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
