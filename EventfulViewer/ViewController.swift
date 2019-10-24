//
//  ViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 24/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapKitView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configButton()
    }
    
    func configButton() {
//        searchButton.backgroundColor = .clear
//        searchButton.layer.cornerRadius = 5
//        searchButton.layer.borderWidth = 0.5
//        searchButton.layer.borderColor = UIColor.black.cgColor
        searchButton.imageView?.contentMode = .scaleAspectFit
    }


}

