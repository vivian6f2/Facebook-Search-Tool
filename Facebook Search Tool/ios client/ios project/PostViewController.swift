//
//  PostViewController.swift
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

class PostTableViewCell: UITableViewCell{
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellMessage: UILabel!
}

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var postTable: UITableView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var detailID:String = ""
    var detailType:String = ""
    var searchResult:[[String]] = []
    var name:String = ""
    var picture:String = ""
    var phpURL:String = ""
    var postData:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        postTable.estimatedRowHeight = 80.0
        postTable.rowHeight = UITableViewAutomaticDimension
        postTable.tableFooterView = UIView()
        
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
            //print(json["detailData"]["posts"])
            for(_,subJson):(String,JSON) in json["detailData"]["posts"]{
                var oneResult:[String] = []
                if let message:String = subJson["story"].string {
                    oneResult.append(message)
                }else if let message:String = subJson["message"].string{
                    oneResult.append(message)
                }
                oneResult.append(subJson["created_time"]["date"].string!)
                self.postData.append(oneResult)
            }
            //print(self.postData)
            self.noDataLabel.isHidden = (self.postData.count != 0)
            self.postTable.isHidden = (self.postData.count == 0)
            self.picture = json["detailData"]["picture"]["url"].string!
            self.postTable.reloadData()
            SwiftSpinner.hide()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PostTableViewCell
        
        //set Image
        let imageURL = URL(string:picture)!
        if let imageData = NSData(contentsOf: imageURL){
            cell.cellImage?.image = UIImage(data: imageData as Data)
        }
        
        if(postData[indexPath.row].count >= 2){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateOrg = dateFormatter.date(from: postData[indexPath.row][1].components(separatedBy: ".")[0])
            dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
            cell.cellMessage?.text = "\(postData[indexPath.row][0])\n\n\(dateFormatter.string(from: dateOrg!))"
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateOrg = dateFormatter.date(from: postData[indexPath.row][0].components(separatedBy: ".")[0])
            dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
            cell.cellMessage?.text = "\n\n\(dateFormatter.string(from: dateOrg!))"
        }
        
        
        return cell
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
