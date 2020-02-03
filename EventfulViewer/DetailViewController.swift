//
//  DetailViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 30/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var eventTitle: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //eventTitle.text = "Test"
        // Do any additional setup after loading the view.
    }

}
