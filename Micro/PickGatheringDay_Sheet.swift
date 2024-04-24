//
//  test.swift
//  Micro
//
//  Created by Hajar Alshehri on 15/10/1445 AH.
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
    @State private var locationName: String = "Drag the pin to select location"
    @State private var draggableLocation = DraggableLocation(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name of the Gathering:")) {
                    TextField("Enter name of the gathering", text: $gatheringName)
                }
                
                Section(header: Text("Time of the Gathering:")) {
                    DatePicker(
                        "Select Time: ",
                        selection: $selectedDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                Section {
                    Map(coordinateRegion: $region, annotationItems: [draggableLocation]) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    updateLocationName(coordinate: location.coordinate)
                                }
                        }
                    }
                    .gesture(DragGesture().onChanged({ (value) in
                        let newCoordinate = region.center
                        draggableLocation.coordinate = newCoordinate
                        updateLocationName(coordinate: newCoordinate)
                    }))
                    .frame(height: 300)
                    
                    Text(locationName)
                        .padding()
                }
                
                Button("Confirm!") {
                    print("Gathering confirmed with name: \(gatheringName) at \(selectedDate)")
                }
            }
            .navigationBarTitle("Add Gathering", displayMode: .inline)
        }
    }
    
    func updateLocationName(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                self.locationName = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
            } else {
                self.locationName = "Error finding location: \(error?.localizedDescription ?? "Unknown Error")"
            }
        }
    }

    struct DraggableLocation: Identifiable {
        let id = UUID()
        var coordinate: CLLocationCoordinate2D
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

    // Data Model
    var gatheringName: String?
    var gatheringDate: Date?
    var gatheringLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNameTextField()
        setupDatePicker()
        setupMapView()
        setupConfirmButton()
        setupSearchBar()
        setupLocationLabel()
    }

    func setupNameTextField() {
        nameTextField.placeholder = "Enter gathering name"
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(annotation)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        mapView.addGestureRecognizer(panGesture)
    }

    func setupConfirmButton() {
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = .blue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupSearchBar() {
        searchBar.placeholder = "Search for a place"
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupLocationLabel() {
        locationLabel.text = "Selected Location:"
        view.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func confirmButtonTapped() {
        gatheringName = nameTextField.text
        gatheringDate = datePicker.date
        gatheringLocation = mapView.centerCoordinate

        print("Gathering Name: \(gatheringName ?? "")")
        print("Gathering Date: \(gatheringDate ?? Date())")
        print("Gathering Location: \(gatheringLocation?.latitude ?? 0), \(gatheringLocation?.longitude ?? 0)")
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        if gesture.state == .changed || gesture.state == .ended {
            if let annotation = mapView.annotations.first {
                mapView.removeAnnotation(annotation)
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = locationOnMap
                mapView.addAnnotation(newAnnotation)
            }
        }

        if gesture.state == .ended {
            updateLocationName(coordinate: locationOnMap)
        }
    }


    func updateLocationName(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in
            if let placemark = placemarks?.first, error == nil {
                self?.locationLabel.text = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
            } else {
                self?.locationLabel.text = "Error finding location: \(error?.localizedDescription ?? "Unknown error")"
            }
        }
    }
}


