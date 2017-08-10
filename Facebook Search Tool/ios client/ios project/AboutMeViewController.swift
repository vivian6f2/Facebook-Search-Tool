//
//  AboutMeViewController.swift
//  Homework9
//
//  Created by Vivian on 2017/4/13.
//  Copyright © 2017年 Vivian. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {
    @IBOutlet weak var clickMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clickMenu.target = self.revealViewController()
        clickMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        // Do any additional setup after loading the view.
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
