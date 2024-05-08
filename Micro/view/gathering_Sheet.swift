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
                
                Section {
                    ZStack(alignment: .center) {
                        Map(coordinateRegion: $region, interactionModes: .all)
                            .frame(height: 300)
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                            .offset(y: -10) // You may need to adjust this value to better align the pin
                    }
                    }
                    
                    Section {
                        Button("تأكيد المكان") {
                            generateLocationURL()
                        }
                        .frame(width: 189, height: 48)
                        .background(Color("AccentColor")) // Using custom accent color
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .padding(.horizontal) // Centers the button horizontally within the section
                        .padding(.leading)
                        .padding(.leading)
                        .padding(.leading)


                    }
                }
                if let url = locationURL {
                    Section {
                        Text("Google Maps URL:")
                        Link(url, destination: URL(string: url)!)
                        Button("Clear URL") {
                            locationURL = nil
                        }
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


import UIKit
import MapKit

class GatheringViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    // UI Components
    let nameTextField = UITextField()
    let datePicker = UIDatePicker()
    let mapView = MKMapView()
    let confirmButton = UIButton()
    let searchBar = UISearchBar()
    let locationLabel = UILabel()
    let urlLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupDatePicker()
        setupSearchBar()
        setupMapView()
        setupURLLabel()
    }

  

    func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        let centerPoint = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        centerPoint.tintColor = .red
        mapView.addSubview(centerPoint)
        centerPoint.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerPoint.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            centerPoint.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -15) // Adjust for the pin point to appear at the center of the map
        ])
    }


    func setupURLLabel() {
        urlLabel.numberOfLines = 0
        urlLabel.isHidden = true
        view.addSubview(urlLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urlLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func confirmButtonTapped() {
        let coordinate = mapView.centerCoordinate
        let url = "https://www.google.com/maps/search/?api=1&query=\(coordinate.latitude),\(coordinate.longitude)"
        urlLabel.text = url
        urlLabel.isHidden = false
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = mapView.centerCoordinate
        updateLocationName(coordinate: coordinate)
    }

    

    func performSearch(query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let strongSelf = self, let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            strongSelf.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        }
    }

    func updateLocationName(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in
            guard let self = self, let placemark = placemarks?.first else { return }
            let locationInfo = [
                placemark.thoroughfare,
                placemark.subThoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")
            self.locationLabel.text = "Selected Location: \(locationInfo)"
        }
    }
    
    
}
