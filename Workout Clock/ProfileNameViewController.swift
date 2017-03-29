//
//  ProfileNameViewController.swift
//  Workout Clock
//
//  Created by Lucas Bressan on 2/24/17.
//  Copyright © 2017 Lucas Bressan. All rights reserved.
//

import UIKit

class ProfileNameViewController: UIViewController {

    @IBOutlet weak var profileNameInput: UITextField!
    @IBOutlet weak var noNameProvidedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmName(_ sender: UIButton) {
    }
    
    
}
