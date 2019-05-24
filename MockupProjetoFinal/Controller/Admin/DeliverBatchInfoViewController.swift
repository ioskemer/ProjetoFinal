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
import Alamofire

class DeliverBatchInfoViewController: UIViewController, CLLocationManagerDelegate {
    var batch = Batch()
    var usersArray = [String]()
    var addressArray = [String]()
    var coordArray = [String]()
    var batchInfo = [JSON]()
    let ref = Database.database().reference()
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var startRoute: UIButton!
    let locationManager = CLLocationManager()
    var userCoordinates = [Double]()
    var markerArray = [[Double]]()
    var locationEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        startRoute.isEnabled = false
        self.navigationItem.title = batch.title
        
        getBatches()
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
                self.batchInfo.append(jsonUser)
            }
            
            self.loadBatches()
        })
    }
    
    func loadBatches(){
        addressArray = []
        //addressArray.append("\(userCoordinates.first!),\(userCoordinates.last!)")
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
                //let cep = jsonUser["cep"].stringValue
                let number = jsonUser["number"].stringValue
                let city = jsonUser["city"].stringValue
                
                let fullAddress = "\(address) \(number) \(city)"

                self.addressArray.append(fullAddress)

                if count == unique.count-1 {
                    self.getAllCoordinates(0)
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let newLocation = locations.last
        userCoordinates = [locValue.latitude, locValue.longitude]
        googleMap.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 11.0)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D.init(latitude: newLocation!.coordinate.latitude, longitude: newLocation!.coordinate.longitude)
        marker.title = "Seu Local"
        marker.snippet = "Voce está aqui!"
        marker.map = googleMap
    }

    @IBAction func startRoute(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let next = mainStoryboard.instantiateViewController(withIdentifier: "RoutingViewController") as! RoutingViewController

        next.coordArray = coordArray
        next.routeUrlArray = addressArray
        next.batchInfo = batchInfo
        next.navTitle = batch.title
        next.userCoordinates = userCoordinates
        next.batch = batch
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // Transform array of address in array of coord
    func getAllCoordinates(_ index: Int){
        var i = index
        var lat = ""
        var lon = ""
        var paramEncoded = addressArray[index]
        paramEncoded = paramEncoded.replacingOccurrences(of: " ", with:"%20")
        paramEncoded = paramEncoded.folding(options: .diacriticInsensitive, locale: .current)
        let url = URL(string: "https://nominatim.openstreetmap.org/search?q=\(paramEncoded)&format=json")!
        let serialQueue = DispatchQueue(label: "serialQueue")
        serialQueue.async{
            Alamofire.request(url).responseJSON { response in
                if let json = response.result.value {
                    let result = JSON(json)
                    if result["erro"].stringValue == "1" {
                    } else {
                        var firstResult = result[0]
                        lat = firstResult["lat"].stringValue
                        lon = firstResult["lon"].stringValue
                        self.coordArray.append("\(lat),\(lon)")
                        self.markerArray.append([Double(lat)!, Double(lon)!])
                        i += 1
                        if self.addressArray.count == i{
                            self.startRoute.isEnabled = true
                            self.addMarkersToMap()
                            return
                        } else {
                            self.getAllCoordinates(i)
                        }
                    }
                }
            }
        }
    }
    
    func addMarkersToMap(){
        var index = 0
        for batch in batchInfo {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D.init(latitude: markerArray[index][0], longitude: markerArray[index][1])
            marker.title = batch["name"].stringValue
            marker.snippet = batch["quantity"].stringValue + " unidades."
            marker.map = googleMap
            index += 1
        }
    }
}
