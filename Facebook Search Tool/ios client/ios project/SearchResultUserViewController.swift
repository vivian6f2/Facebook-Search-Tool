//
//  SearchResultUserViewController.swift
//  Homework9
//
//  Created by Vivian on 2017/4/15.
//  Copyright © 2017年 Vivian. All rights reserved.
//

import UIKit
import EasyToast
import Alamofire
import SwiftSpinner
import SwiftyJSON

class SearchResultUserTableViewCell: UITableViewCell{
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellFavorite: UIImageView!
    
}

class SearchResultUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var clickMenu: UIBarButtonItem!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var searchData:[String] = ["row1", "row2", "row3", "row4", "row5", "row6", "row7"]
    var phpURL:String = ""
    var previousPage:String?
    var nextPage:String?
    var searchResult:[[String]] = []
    var selectedID:String = ""
    var favoriteResult:[String:[Any]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSearching()
        resultTable.tableFooterView = UIView()

        clickMenu.target = self.revealViewController()
        clickMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Do any additional setup after loading the view.
    }
    func startSearching(){
        searchResult = []
        SwiftSpinner.show("Loading data...")
        
        shareData()
        phpURL = "http://sample-env-1.nwnpppmvdn.us-west-2.elasticbeanstalk.com/index.php/search.php?keyword=\(searchData[0])&offset=\(searchData[2])&version=hw9&type=\(searchData[1])"
        callAlamo(url: phpURL)
    }
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            //print(response)
            
            //self.parseData(JsonString: response.result.value as! String)
            var json = JSON(response.result.value!)
            //print(json)
            self.nextPage = json["searchData"]["paging"]["next"].string
            self.previousPage = json["searchData"]["paging"]["previous"].string
            if((self.nextPage) != nil){
                self.nextButton.isEnabled = true
            }else{
                self.nextButton.isEnabled = false
            }
            if((self.previousPage) != nil){
                self.previousButton.isEnabled = true
            }else{
                self.previousButton.isEnabled = false
            }
            
            for(_,subJson):(String,JSON) in json["searchData"]["data"]{
                let oneResult:[String] = [subJson["id"].string!,subJson["name"].string!,subJson["picture"]["data"]["url"].string!]
                self.searchResult.append(oneResult)
            }
            self.load()
            self.resultTable.reloadData()
            SwiftSpinner.hide()
        })
    }
    
    func load(){
        if let loadedData = UserDefaults.standard.value(forKey: searchData[1]) as? [String:[Any]]{
            favoriteResult = loadedData
            //print("load: ")
            //print(favoriteResult)
        }
    }
    
    
    func shareData(){
        let tabController = self.tabBarController! as UITabBarController
        let userNavController = tabController.viewControllers![0] as! UINavigationController
        let userView = userNavController.topViewController as! SearchResultUserViewController
        userView.searchData[0] = searchData[0]
        userView.searchData[1] = "user"
        userView.searchData[2] = searchData[2]
        userView.searchData[3] = searchData[3]
        userView.searchData[4] = searchData[4]
        userView.searchData[5] = searchData[5]
        userView.searchData[6] = searchData[6]
        
        let pageNavController = tabController.viewControllers![1] as! UINavigationController
        let pageView = pageNavController.topViewController as! SearchResultPageViewController
        pageView.searchData[0] = searchData[0]
        pageView.searchData[1] = "page"
        pageView.searchData[2] = searchData[2]
        pageView.searchData[3] = searchData[3]
        pageView.searchData[4] = searchData[4]
        pageView.searchData[5] = searchData[5]
        pageView.searchData[6] = searchData[6]
        
        let eventNavController = tabController.viewControllers![2] as! UINavigationController
        let eventView = eventNavController.topViewController as! SearchResultEventViewController
        eventView.searchData[0] = searchData[0]
        eventView.searchData[1] = "event"
        eventView.searchData[2] = searchData[2]
        eventView.searchData[3] = searchData[3]
        eventView.searchData[4] = searchData[4]
        eventView.searchData[5] = searchData[5]
        eventView.searchData[6] = searchData[6]
        
        let placeNavController = tabController.viewControllers![3] as! UINavigationController
        let placeView = placeNavController.topViewController as! SearchResultPlaceViewController
        placeView.searchData[0] = searchData[0]
        placeView.searchData[1] = "place"
        placeView.searchData[2] = searchData[2]
        placeView.searchData[3] = searchData[3]
        placeView.searchData[4] = searchData[4]
        placeView.searchData[5] = searchData[5]
        placeView.searchData[6] = searchData[6]
        
        let groupNavController = tabController.viewControllers![4] as! UINavigationController
        let groupView = groupNavController.topViewController as! SearchResultGroupViewController
        groupView.searchData[0] = searchData[0]
        groupView.searchData[1] = "group"
        groupView.searchData[2] = searchData[2]
        groupView.searchData[3] = searchData[3]
        groupView.searchData[4] = searchData[4]
        groupView.searchData[5] = searchData[5]
        groupView.searchData[6] = searchData[6]

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchResultUserTableViewCell
        
        //set Image
        let imageURL = URL(string:searchResult[indexPath.row][2])!
        if let imageData = NSData(contentsOf: imageURL){
            cell.cellImage?.image = UIImage(data:imageData as Data)
        }
        
        
        cell.cellLabel?.text = searchResult[indexPath.row][1]
        
        //set favorite
        if favoriteResult[searchResult[indexPath.row][0]] != nil{
            cell.cellFavorite?.image = UIImage(named:"filled")
        }else{
            cell.cellFavorite?.image = UIImage(named:"empty")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = searchResult[indexPath.row][0]
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="showDetail"){
            navigationItem.title = "Results"
            let tabController = segue.destination as! DetailTabBarController
            tabController.detailID = selectedID
            //let albumNavController = tabController.viewControllers![0] as! UINavigationController
            let albumView = tabController.viewControllers![0] as! AlbumViewController
            albumView.detailID = selectedID
            albumView.detailType = searchData[1]
            //let postNavController = tabController.viewControllers![1] as! UINavigationController
            let postView = tabController.viewControllers![1] as! PostViewController
            postView.detailID = selectedID
            postView.detailType = searchData[1]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Search Results"
        load()
        resultTable.reloadData()
    }
    
    @IBAction func clickPrevious(_ sender: Any) {
        var offset:Int = Int(searchData[2])!
        offset -= 10
        searchData[2] = "\(offset)"
        startSearching()
        
    }
    @IBAction func clickNext(_ sender: Any) {
        var offset:Int = Int(searchData[2])!
        offset += 10
        searchData[2] = "\(offset)"
        startSearching()

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
