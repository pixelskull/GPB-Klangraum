//
//  PlayerViewController.swift
//  GPB-Klangraum
//
//  Created by Alex on 05.10.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    var minFrequency: Float?
    var maxFrequency: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(minFrequency)
        print(maxFrequency)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
