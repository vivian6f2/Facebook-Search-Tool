//
//  AlbumViewController.swift
//  Homework9
//
//  Created by Vivian on 2017/4/16.
//  Copyright © 2017年 Vivian. All rights reserved.
//

import UIKit
import EasyToast
import Alamofire
import SwiftSpinner
import SwiftyJSON

class AlbumTableViewCell: UITableViewCell{
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage1: UIImageView!
    @IBOutlet weak var cellImage2: UIImageView!
    var numberOfImage:Int = 0
    
//    class var expandedHeight: CGFloat { get {
//        if (self.numberOfImage == 0){
//            return 50.0
//        }else if self.numberOfImage ==
//        return 479.0
//        
//    } }
    class var defaultHeight: CGFloat  { get { return 50.0  } }
    
//    func checkHeight(){
//        cellImage1.isHidden = false
//        cellImage2.isHidden = false
//    }
//    
//    func watchFrameChanges(){
//        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
//        checkHeight()
//    }
//    func ignoreFrameChanges(){
//        removeObserver(self, forKeyPath: "frame")
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "frame"{
//            checkHeight()
//        }
//    }
}

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var detailID:String = ""
    var detailType:String = ""
    var searchResult:[[String]] = []
    var name:String = ""
    var picture:String = ""
    var phpURL:String = ""
    var albumData:[[String]] = []
    var selectedIndexPath: IndexPath?
    var numOfImageForCell:[Int] = [0,0,0,0,0]
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var albumTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTable.tableFooterView = UIView()
//        albumTable.estimatedRowHeight = 30.0
//        albumTable.rowHeight = UITableViewAutomaticDimension
        startSearching()
        

        // Do any additional setup after loading the view.
    }
    
    func startSearching(){
        searchResult = []
        SwiftSpinner.show("Loading data...")
        
        phpURL = "http://sample-env-1.nwnpppmvdn.us-west-2.elasticbeanstalk.com/index.php/search.php?detail_id=\(detailID)&version=hw9&detail_type=\(detailType)"
        callAlamo(url: phpURL)
        
    }
    func callAlamo(url: String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            //print(response)
            
            //self.parseData(JsonString: response.result.value as! String)
            var json = JSON(response.result.value!)
            //print(json["detailData"]["albums"])
            for(_,subJson):(String,JSON) in json["detailData"]["albums"]{
                var oneResult:[String] = [subJson["name"].string!]
                for(_,picJson):(String,JSON) in subJson["photos"]{
                    oneResult.append(picJson["picture"].string!)
                }
                self.albumData.append(oneResult)
            }
            
            //print(self.albumData)
            
            //print(self.albumData.count)
            self.noDataLabel.isHidden = (self.albumData.count != 0)
            self.albumTable.isHidden = (self.albumData.count == 0)
            self.name = json["detailData"]["name"].string!
            self.picture = json["detailData"]["picture"]["url"].string!
            
            //print(json["detailData"])
            
            self.albumTable.reloadData()
            
            self.shareData()
            SwiftSpinner.hide()
        })
    }
    
    func shareData(){
        let tabController = self.tabBarController! as! DetailTabBarController
        tabController.detailName = self.name
        tabController.detailPicture = self.picture
        tabController.detailID = self.detailID
        tabController.detailType = self.detailType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AlbumTableViewCell
        cell.cellLabel?.text = albumData[indexPath.row][0]
        if(albumData[indexPath.row].count == 2){
            cell.cellImage1.isHidden = false
            cell.cellImage2.isHidden = true
            if let imageURL1 = URL(string:albumData[indexPath.row][1]){
                if let imageData1 = NSData(contentsOf: imageURL1){
                    cell.cellImage1?.image = UIImage(data: imageData1 as Data)
                }
            }
            numOfImageForCell[indexPath.row] = 1
        }else if(albumData[indexPath.row].count == 3){
            cell.cellImage1.isHidden = false
            cell.cellImage2.isHidden = false
            if let imageURL1 = URL(string:albumData[indexPath.row][1]){
                if let imageData1 = NSData(contentsOf: imageURL1){
                    cell.cellImage1?.image = UIImage(data: imageData1 as Data)
                }
            }
            if let imageURL2 = URL(string:albumData[indexPath.row][2]){
                if let imageData2 = NSData(contentsOf: imageURL2){
                    cell.cellImage2?.image = UIImage(data:imageData2 as Data)
                }
            }
            numOfImageForCell[indexPath.row] = 2
        }else{
            cell.cellImage1.isHidden = true
            cell.cellImage2.isHidden = true
            numOfImageForCell[indexPath.row] = 0
        }
        //cell.cellImage1.isHidden = true
        //cell.cellImage2.isHidden = true
        //print(cell.numberOfImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath{
            selectedIndexPath = nil
        }else{
            selectedIndexPath = indexPath
        }
        
        var indexPaths:[IndexPath] = []
        if let previous = previousIndexPath{
            indexPaths.append(previous)
        }
        if let current = selectedIndexPath{
            indexPaths.append(current)
        }
        if indexPaths.count>0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! AlbumTableViewCell).watchFrameChanges()
//    }
//    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! AlbumTableViewCell).ignoreFrameChanges()
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            if(numOfImageForCell[indexPath.row] == 0){
                return 50.0
            }else if(numOfImageForCell[indexPath.row] == 1){
                return 280.0
            }else{
                return 479.0
            }

        }else{
            return AlbumTableViewCell.defaultHeight
        }
        
    }

    @IBAction func clickOption(_ sender: Any) {
        
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
