//
//  MainMenuViewController.swift
//  todo
//
//  Created by Placoderm on 7/6/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //unwind segue
    @IBAction func unwindToToDoListView(sender: UIStoryboardSegue)
    {
        print ("Main Menu")
    }
}

