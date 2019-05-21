//
//  RoutingViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 20/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class RoutingViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var routeUrlArray: [String] = []
    var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var count = 0
        var destination = ""
        var origin = ""
        var waypoints = "&waypoints="
        for address in routeUrlArray {
            if count == 0 {
                    origin = address
            } else if count == routeUrlArray.count-1{
                destination = address
            } else {
                waypoints += "\(address)&"
            }
            count += 1
        }
        
        let string = "https://www.google.com/maps/dir/?api=1&destination=\(destination)&origin=\(origin)\(waypoints)travelmode=driving&dir_action=navigate";
        let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encoded)!
        
        let request = NSURLRequest(url: url as URL);
        webView.loadRequest(request as URLRequest);
        self.navigationItem.title = navTitle
        let rightBarButtonItem = UIBarButtonItem.init(title: "+ Info", style: .done, target: self, action: #selector(RoutingViewController.openPopOver))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func openPopOver() {
        self.performSegue(withIdentifier: "popover", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popover" {
            let vc : PopOverViewController = segue.destination as! PopOverViewController
            
            vc.teste = "oi"
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
