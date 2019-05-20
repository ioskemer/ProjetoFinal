//
//  DeliverBatchInfoViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 17/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import GoogleMaps
import CoreLocation
import MapKit

class DeliverBatchInfoViewController: UIViewController, CLLocationManagerDelegate {
    var batch = Batch()
    var usersArray = [String]()
    var addressArray = [String]()
    let ref = Database.database().reference()
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var startRoute: UIButton!
    let locationManager = CLLocationManager()
    var userCoordinates = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        startRoute.isEnabled = false
        self.navigationItem.title = batch.title
        
        getBatches()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        googleMap = mapView
    }

    func getBatches(){
        ref.child("batches").child(String(batch.id)).child("reserved").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
        
            if value == nil {
                return
            }
        
            for user in JSON(value!) {
                let jsonUser = JSON(user.1)
                
                let userId = jsonUser["uid"].stringValue
                self.usersArray.append(userId)
            }
            
            self.loadBatches()
        })
    }
    
    func loadBatches(){
        addressArray = []
        addressArray.append("Rua Visconde de Guarapuava 1440, Curitiba")
        var count = 0
        let unique = Array(Set(usersArray))
        for userId in unique {
            ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                if value == nil {
                    return
                }

                let jsonUser = JSON(value!)

                let address = jsonUser["address"].stringValue
                let cep = jsonUser["cep"].stringValue
                let number = jsonUser["number"].stringValue
                let city = jsonUser["city"].stringValue
                
                let fullAddress = "\(address), \(number), \(cep), \(city)"

                self.addressArray.append(fullAddress)
                
                if count == unique.count-1 {
                    self.startRoute.isEnabled = true
                }
                
                count += 1
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userCoordinates = [locValue.latitude, locValue.longitude]
        
        print("cheguei aquii")
        
//        let address = CLGeocoder.init()
//
//        address.reverseGeocodeLocation(CLLocation.init(latitude: userCoordinates.first!, longitude:userCoordinates.last!)) { (places, error) in
//            if error == nil{
//                if let place = places{
//                    print("lugar eh")
//                    print(place)
//                }
//            }
//        }
    }

    @IBAction func startRoute(_ sender: Any) {
        print(userCoordinates)
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let next = mainStoryboard.instantiateViewController(withIdentifier: "RoutingViewController") as! RoutingViewController

        next.routeUrlArray = addressArray
        next.navTitle = batch.title
        
        self.navigationController?.pushViewController(next, animated: true)
    }
}
