//
//  DetailTabBarController.swift
//  Homework9
//
//  Created by Vivian on 2017/4/18.
//  Copyright © 2017年 Vivian. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKCoreKit

class DetailTabBarController: UITabBarController, FBSDKSharingDelegate{
    var detailID:String = ""
    var detailName:String = ""
    var detailPicture:String = ""
    var detailType:String = ""
    var favoriteResult:[String:[Any]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setGraphAPIVersion("v2.8")
        //overrideVersionPartWith(version: "v2.8")
        load()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickOption(_ sender: Any) {
        load()
//        print(detailID)
//        print(detailName)
//        print(detailPicture)
//        print(detailType)
        let optionSheet:UIAlertController = UIAlertController(title:"Menu", message:nil, preferredStyle: .actionSheet)
        
        if favoriteResult[detailID] != nil{
            let rmFavoriteAction:UIAlertAction = UIAlertAction(title:"Remove from favorites", style: .default){
                (_: UIAlertAction) in
                //print("Remove from favorites!")
                self.favoriteResult.removeValue(forKey: self.detailID)
                self.save()
                self.view.showToast("Removed from favorites!", position: .bottom, popTime: 3, dismissOnTap: true)
            }
            optionSheet.addAction(rmFavoriteAction)
        }else{
            let adfavoriteAction:UIAlertAction = UIAlertAction(title:"Add to favorites", style: .default){
                (_: UIAlertAction) in
                //print("Add favorites!")
                let date = NSDate()
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +zzzz"
                self.favoriteResult[self.detailID] = [self.detailID,self.detailName,self.detailPicture, date]
                self.save()
                self.view.showToast("Added to favorites!", position: .bottom, popTime: 3, dismissOnTap: true)
            }
            optionSheet.addAction(adfavoriteAction)
        }
        
        
        
        
        let shareAction:UIAlertAction = UIAlertAction(title:"Share", style: .default){
            (_: UIAlertAction) in
            //print("Click Share")
            //self.view.addSubview(content)
            let myContent : FBSDKShareLinkContent = FBSDKShareLinkContent()
            myContent.contentURL = URL(string: self.detailPicture)
            myContent.contentTitle = self.detailName
            myContent.contentDescription = "FB Share for CSCI 571"
            myContent.imageURL = URL(string: self.detailPicture)
            
            
            let shareDialog = FBSDKShareDialog()
            shareDialog.mode = .feedBrowser
            shareDialog.shareContent = myContent
            shareDialog.fromViewController = self
            shareDialog.delegate = self
            shareDialog.show()
            

            
            
            //FBSDKShareDialog.show(from: self, with: myContent, delegate: nil)
            
            
            //self.view.showToast("Shared!", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        optionSheet.addAction(shareAction)
        let cancelAction:UIAlertAction = UIAlertAction(title:"Cancel", style: .destructive){
            (_: UIAlertAction) in
            //print("Click Cancel")
        }
        optionSheet.addAction(cancelAction)
        self.present(optionSheet, animated:true){
            //print("click option")
        }

    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        view.showToast("Shared!", position: .bottom, popTime: 3, dismissOnTap: true)
    }
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        view.showToast("Failed!", position: .bottom, popTime: 3, dismissOnTap: true)
    }
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        view.showToast("Canceled!", position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    
    func save(){
        //print("save: ")
        //print(favoriteResult)
        UserDefaults.standard.set(favoriteResult,forKey: detailType)
        UserDefaults.standard.synchronize()
    }
    func load(){
        if let loadedData = UserDefaults.standard.value(forKey: detailType) as? [String:[Any]]{
            favoriteResult = loadedData
            //print("load: ")
            //print(favoriteResult)
        }
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
