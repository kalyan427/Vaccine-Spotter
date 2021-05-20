//
//  ViewController.swift
//  Vaccine Spotter
//
//  Created by kalyan  on 5/6/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var appointmentAvailable: UILabel!
    @IBOutlet weak var providerBrand: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var spotTitle: UILabel!
    var stateManager = StatesManager()
    var returnData: stateModel?
    var selectedState: StateNameList?
    var selectedAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.message.text = "Kindly Click on the marker to view more about the spot"
        self.title = selectedState?.name
        let selectedVaccineURL = "https://www.vaccinespotter.org/api/v0/states/"+selectedState!.abbreviation+".json"
        loader.startAnimating()
        stateManager.performRequest(urlString: selectedVaccineURL) { isSucess, data in
            DispatchQueue.main.async {
                self.loader.stopAnimating()
            }
            self.parseJSON(states: data)
            if let feature  = self.returnData{
                print("recevied data \(feature.features.count)")
                var latitude:Double = 0
                var longitude:Double = 0
                for item in feature.features{
                    longitude = item.geometry.coordinates[0]
                    latitude = item.geometry.coordinates[1]
                    self.mapView.addAnnotation(Spotter(
                                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude:longitude), details: item))
                }
                
                DispatchQueue.main.async {
                    self.zoomToSelectedLocation(with: latitude, longitude: longitude)
                }
            } else{
                print("API call failed to get the list of slots")
            }
        }
    }
    
    private func zoomToSelectedLocation(with latitude: Double, longitude: Double){
        mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedAnnotation = view.annotation as? Spotter{
            spotTitle.text = selectedAnnotation.details.properties.name
            self.appointmentAvailable.text = selectedAnnotation.details.properties.appointments_available ?? false ? "Appointment is Available" : "Appointment is Not Available"
            providerBrand.text = "Brand Provide: \(selectedAnnotation.details.properties.provider_brand)"
            self.message.text = ""
            
        }
    }
}

extension ViewController{
    func parseJSON(states: Data)  {
        let decoder = JSONDecoder()
        do {
            returnData = try decoder.decode(stateModel.self, from: states)
        } catch {
            // returnData = ""
        }
    }
}

class Spotter: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let details: Feature
    init(
        coordinate: CLLocationCoordinate2D,
        details: Feature
    ) {
        self.coordinate = coordinate
        self.details = details
        super.init()
    }
}
