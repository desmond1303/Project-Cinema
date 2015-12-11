//
//  PCTabBarViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 11.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if tabBar.items?.indexOf(item) != 0 {
            self.viewControllers?.first?.viewWillDisappear(false)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
