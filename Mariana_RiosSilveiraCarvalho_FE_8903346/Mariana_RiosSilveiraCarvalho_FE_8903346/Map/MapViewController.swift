//
//  MapViewController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-11.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Private Variables
    private let locationManager: CLLocationManager
    private var currentLocation: CLLocationCoordinate2D?
    private var destinationLocation: CLLocationCoordinate2D?
    private var transportType: MKDirectionsTransportType = .automobile

    // MARK: - Public Variables
    var directionsData: DirectionsData?

    // MARK: - Initializer
    required init?(coder: NSCoder) {
        self.locationManager = CLLocationManager()
        super.init(coder: coder)
    }

    // MARK: - UIViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
    }

    // MARK: - Private Functions
    private func setup() {
        self.checkLocationServices()
    }

    private func setupLocationManager() {
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func update() {
        guard let location = self.locationManager.location else { return }
        self.currentLocation = .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.addOverlay()
    }

    private func addOverlay() {
        guard let source = self.currentLocation, let destination = self.destinationLocation else { return }
        self.mapView.removeOverlays(self.mapView.overlays)

        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let sourceAnnotation = MKPointAnnotation()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.addAnnotations([sourceAnnotation, destinationAnnotation])

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = self.transportType

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else { return }
            let route = response.routes[0]
            let rect = route.polyline.boundingMapRect
            self.mapView.addOverlay((route.polyline), level: .aboveRoads)
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

    private func createNewSearchAlert(cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Where would you like to go?", message: "Enter your destination", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].placeholder = "Destination"

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))

        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { [unowned alert] _ in
            guard let text = alert.textFields![0].text, text != "" else {
                self.showErrorAlert()
                return
            }

            let newSearchData = SearchData(city: text, source: "Map", type: "Directions")
            self.create(searchData: newSearchData) { response in
                if response {
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(text) { placemarks, error in
                        guard let placemarks = placemarks, let first = placemarks.first, let location = first.location else { return }
                        self.destinationLocation = .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        self.update()
                    }
                } else {
                    self.showErrorAlert("Error", "Something wrong. Please try again.")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions Functions
    @IBAction func didTapChangeCity(_ sender: UIBarButtonItem) {
        self.createNewSearchAlert()
    }
    
    @IBAction func didChangeZoom(_ sender: UISlider) {
        if let location = self.locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: Double(sender.value), longitudeDelta: Double(sender.value))
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }

    @IBAction func didTapAutoTravel(_ sender: UIButton) {
        self.transportType = .automobile
        self.update()
    }
    
    @IBAction func didTapBikeTravel(_ sender: UIButton) {
        self.transportType = .any
        self.update()
    }
    
    @IBAction func didTapWalkTravel(_ sender: UIButton) {
        self.transportType = .walking
        self.update()
    }
}

// MARK: - MKMapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4
        return renderer
    }
}

// MARK: - CLLocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkLocationManagerAuthorizationStatus()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location === \(location)")

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
    }
}

// MARK: - Private Extension Functions Related to Permissions
private extension MapViewController {
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupLocationManager()
            } else {
                self.showAuthorizationStatusAlertError()
            }
        }
    }

    func checkLocationManagerAuthorizationStatus() {
        let authorizationStatus: CLAuthorizationStatus

        if #available(iOS 14, *) {
            authorizationStatus = self.locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .denied:
            self.showAuthorizationStatusAlertError()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }

    func showAuthorizationStatusAlertError() {
        let alert = UIAlertController(
            title: "MR Final needs to access your location while using the app",
            message: "To use this app, you will need to allow MR Final to access your location.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
