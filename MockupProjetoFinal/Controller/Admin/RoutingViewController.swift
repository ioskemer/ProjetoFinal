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

class RoutingViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var routeUrlArray: [String] = []
    var navTitle = ""
    var batchInfo: [JSON] = []
    var coordArray = [String]()
    var urlArray = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordArray = []
        coordArray.append(routeUrlArray.remove(at: 0))
        getAllCoordinates(0)
    }
    
    @objc func openPopOver() {
        self.performSegue(withIdentifier: "popover", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popover" {
            let vc : PopOverViewController = segue.destination as! PopOverViewController
            
            vc.info = batchInfo
        }
    }
    
    func showMap(){
        var count = 0
        var destination = ""
        var origin = ""
        var waypoints = "&waypoints="
        
        for coordinates in coordArray {
            print(coordinates)
            if count == 0 {
                origin = coordinates
            } else if count == routeUrlArray.count-1{
                destination = coordinates
            } else {
                waypoints += "\(coordinates)&"
            }
            count += 1
        }
        
        
        let string = "https://www.google.com/maps/dir/?api=1&destination=\(destination)&saddr=\(origin)\(waypoints)&travelmode=driving&dir_action=navigate";
        print(string)
        let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoded)!
        
        let request = NSURLRequest(url: url as URL);
        webView.loadRequest(request as URLRequest);
        self.navigationItem.title = navTitle
        let rightBarButtonItem = UIBarButtonItem.init(title: "+ Info", style: .done, target: self, action: #selector(RoutingViewController.openPopOver))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func getAllCoordinates(_ index: Int){
        var i = index
        var lat = ""
        var lon = ""
        var paramEncoded = routeUrlArray[index]
        paramEncoded = paramEncoded.replacingOccurrences(of: " ", with:"%20")
        var url = URL(string: "https://nominatim.openstreetmap.org/search?q=\(paramEncoded)&format=json")!
        urlArray.append(url)
        let serialQueue = DispatchQueue(label: "serialQueue")
        for url in urlArray {
            serialQueue.async{
                Alamofire.request(url).responseJSON { response in
                    print("comecando request de \(url)")
                    if let json = response.result.value {
                        let result = JSON(json)
                        if result["erro"].stringValue == "1" {
                        } else {
                            var firstResult = result[0]
                            lat = firstResult["lat"].stringValue
                            lon = firstResult["lon"].stringValue
                            self.coordArray.append("\(lat),\(lon)")
                            print(self.coordArray)
                            i += 1
                            print(i)
                            print(self.routeUrlArray.count)
                            if self.routeUrlArray.count >= i{
                                self.showMap()
                                return
                            } else {
                                self.getAllCoordinates(i)
                            }
                        }
                    } else {
                        
                    }
                }
               
            }
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

}
