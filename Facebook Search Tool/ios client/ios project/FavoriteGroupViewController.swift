//
//  FavoriteGroupViewController.swift
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

class FavoriteGroupTableViewCell:UITableViewCell{
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellFavorite: UIImageView!
}

class FavoriteGroupViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate{
    @IBOutlet weak var clickMenu: UIBarButtonItem!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var searchData:[String] = ["row1", "row2", "row3", "row4", "row5", "row6", "row7"]
    var favoriteResult:[[Any]] = []
    var selectedID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
        resultTable.tableFooterView = UIView()
        
        clickMenu.target = self.revealViewController()
        clickMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        // Do any additional setup after loading the view.
    }
    func shareData(){
        let tabController = self.tabBarController! as UITabBarController
        let userNavController = tabController.viewControllers![0] as! UINavigationController
        let userView = userNavController.topViewController as! FavoriteUserViewController
        userView.searchData[0] = searchData[0]
        userView.searchData[1] = "user"
        userView.searchData[2] = searchData[2]
        userView.searchData[3] = searchData[3]
        userView.searchData[4] = searchData[4]
        userView.searchData[5] = searchData[5]
        userView.searchData[6] = searchData[6]
        
        let pageNavController = tabController.viewControllers![1] as! UINavigationController
        let pageView = pageNavController.topViewController as! FavoritePageViewController
        pageView.searchData[0] = searchData[0]
        pageView.searchData[1] = "page"
        pageView.searchData[2] = searchData[2]
        pageView.searchData[3] = searchData[3]
        pageView.searchData[4] = searchData[4]
        pageView.searchData[5] = searchData[5]
        pageView.searchData[6] = searchData[6]
        
        let eventNavController = tabController.viewControllers![2] as! UINavigationController
        let eventView = eventNavController.topViewController as! FavoriteEventViewController
        eventView.searchData[0] = searchData[0]
        eventView.searchData[1] = "event"
        eventView.searchData[2] = searchData[2]
        eventView.searchData[3] = searchData[3]
        eventView.searchData[4] = searchData[4]
        eventView.searchData[5] = searchData[5]
        eventView.searchData[6] = searchData[6]
        
        let placeNavController = tabController.viewControllers![3] as! UINavigationController
        let placeView = placeNavController.topViewController as! FavoritePlaceViewController
        placeView.searchData[0] = searchData[0]
        placeView.searchData[1] = "place"
        placeView.searchData[2] = searchData[2]
        placeView.searchData[3] = searchData[3]
        placeView.searchData[4] = searchData[4]
        placeView.searchData[5] = searchData[5]
        placeView.searchData[6] = searchData[6]
        
        let groupNavController = tabController.viewControllers![4] as! UINavigationController
        let groupView = groupNavController.topViewController as! FavoriteGroupViewController
        groupView.searchData[0] = searchData[0]
        groupView.searchData[1] = "group"
        groupView.searchData[2] = searchData[2]
        groupView.searchData[3] = searchData[3]
        groupView.searchData[4] = searchData[4]
        groupView.searchData[5] = searchData[5]
        groupView.searchData[6] = searchData[6]
        
    }
    func load(){
        if let loadedData = UserDefaults.standard.value(forKey: searchData[1]) as? [String:[Any]]{
            favoriteResult = Array(loadedData.values)
            print(favoriteResult)
            favoriteResult = favoriteResult.sorted(by: { ($0[3] as! Date).compare($1[3] as! Date) == ComparisonResult.orderedAscending })
            print(favoriteResult)
        }
    }
    
    func update(){
        shareData()
        load()
        let offset:Int = Int(searchData[6])!
        previousButton.isEnabled = false
        nextButton.isEnabled = false
        if(offset>0){
            previousButton.isEnabled = true
        }
        if(favoriteResult.count-offset>10){
            nextButton.isEnabled = true
        }
        resultTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let offset:Int = Int(searchData[6])!
        if(favoriteResult.count-offset>10){
            return 10
        }else if(favoriteResult.count-offset<0){
            return 0
        }else{
            return favoriteResult.count-offset
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let offset:Int = Int(searchData[6])!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoriteGroupTableViewCell
        
        //set Image
        let imageURL = URL(string:favoriteResult[indexPath.row+offset][2] as! String)!
        if let imageData = NSData(contentsOf: imageURL){
            cell.cellImage?.image = UIImage(data:imageData as Data)
        }
        
        cell.cellLabel?.text = favoriteResult[indexPath.row+offset][1] as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offset:Int = Int(searchData[6])!
        selectedID = favoriteResult[indexPath.row+offset][0] as! String
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
        navigationItem.title = "Favorites"
        update()
    }

    @IBAction func clickPrevious(_ sender: Any) {
        var offset:Int = Int(searchData[6])!
        offset -= 10
        searchData[6] = "\(offset)"
        update()
    }
    @IBAction func clickNext(_ sender: Any) {
        var offset:Int = Int(searchData[6])!
        offset += 10
        searchData[6] = "\(offset)"
        update()
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
