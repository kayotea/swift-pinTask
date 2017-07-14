//
//  AddErrandViewController.swift
//  PinTask
//
//  Created by Placoderm on 7/13/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit

class AddErrandViewController: UIViewController {

    
    @IBOutlet weak var errandTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func errandCancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated:true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errandTextField.placeholder = "Errand"
        addressTextField.placeholder = "Address"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
