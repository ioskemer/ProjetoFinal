//
//  RoutingViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 20/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation

class RoutingViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var routeUrlArray: [String] = []
    var navTitle = ""
    var batchInfo: [JSON] = []
    var coordArray = [String]()
    var urlArray = [URL]()
    var doubleCoordArray = [[Double]]()
    var userCoordinates = [Double]()
    var batch = Batch()
    public static var infoArray: [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        RoutingViewController.infoArray = batchInfo
        showMap()
    }
    
    @objc func openPopOver() {
        self.performSegue(withIdentifier: "popover", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popover" {
            let vc : PopOverViewController = segue.destination as! PopOverViewController
            
            vc.info = batchInfo
            vc.batch = batch
        }
    }
    
    func showMap(){
        var origin = ""
        var destination = ""
        
        for coordinates in coordArray {
            var splittedOriginCoord = coordinates.split(separator: ",")
            doubleCoordArray.append([Double(splittedOriginCoord[0])!, Double(splittedOriginCoord[1])!])
        }
        
        let originCoord = CLLocation(latitude: userCoordinates[0], longitude: userCoordinates[1])
        origin = "\(originCoord.coordinate.latitude),\(originCoord.coordinate.longitude)"
        var jsonArray = [JSON]()
        
        for coord in doubleCoordArray {
            let otherCoord = CLLocation(latitude: coord[0], longitude: coord[1])
            let dist = originCoord.distance(from: otherCoord)
            let json = JSON([
                "dist": String(dist),
                "lat": String(coord[0]),
                "lon": String(coord[1])
            ])
            jsonArray.append(json)
            //print("distancia entre inicio e \(otherCoord) é \(dist)")
        }
        
        var sortedResults = jsonArray.sorted { $0["dist"].doubleValue < $1["dist"].doubleValue }
        
        destination = "\(sortedResults.last!["lat"]),\(sortedResults.last!["lon"])"
        sortedResults.removeLast()
        var waypoints = ""
        if (sortedResults.count > 0){
            waypoints = "waypoints="
            for json in sortedResults {
                waypoints += "\(json["lat"]),\(json["lon"])|"
            }
        }
        
        let string = "https://www.google.com/maps/dir/?api=1&destination=\(destination)&origin=\(origin)&\(waypoints)&travelmode=driving&dir_action=navigate";
        print(string)
        let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoded)!
        
        let request = NSURLRequest(url: url as URL);
        webView.loadRequest(request as URLRequest);
        self.navigationItem.title = navTitle
        let rightBarButtonItem = UIBarButtonItem.init(title: "+ Info", style: .done, target: self, action: #selector(RoutingViewController.openPopOver))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
