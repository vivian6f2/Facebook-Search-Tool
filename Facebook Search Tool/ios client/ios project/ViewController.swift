//
//  ViewController.swift
//  Homework9
//
//  Created by Vivian on 2017/4/13.
//  Copyright © 2017年 Vivian. All rights reserved.
//

import UIKit
import EasyToast
import Alamofire
import SwiftSpinner
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var clickMenu: UIBarButtonItem!
    let locationManager = CLLocationManager()
    var lat:String = ""
    var lon:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //get location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        clickMenu.target = self.revealViewController()
        clickMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        keyword.text = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.lat = "\(location.coordinate.latitude)"
        self.lon = "\(location.coordinate.longitude)"
        //print("latitude: \(lat), longitude: \(lon)")
    }
    
    @IBAction func clearButton(_ sender: Any) {
        keyword.text = ""
        keyword.resignFirstResponder()
    }
    @IBAction func searchButton(_ sender: Any) {
        if(keyword.text != "" && keyword.text != nil){
            performSegue(withIdentifier: "searchSegue", sender: self)
        }else{
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        keyword.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchSegue"){
            let tabController = segue.destination as! UITabBarController
            let navController = tabController.viewControllers![0] as! UINavigationController
            
            let newView = navController.topViewController as! SearchResultUserViewController
            newView.searchData[0] = ((keyword.text!).replacingOccurrences(of: " ", with: "+")).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            newView.searchData[1] = "user"
            newView.searchData[2] = "0" //user offset
            newView.searchData[3] = "0" //page offset
            newView.searchData[4] = "0" //event offset
            newView.searchData[5] = "0" //place offset
            newView.searchData[6] = "0" //group offset
            
            let placeNavController = tabController.viewControllers![3] as! UINavigationController
            let placeView = placeNavController.topViewController as! SearchResultPlaceViewController
            placeView.lat = self.lat
            placeView.lon = self.lon
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "searchSegue"){
            if(keyword.text == "" || keyword.text == nil){
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

