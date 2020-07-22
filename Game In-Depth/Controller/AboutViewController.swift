//
//  AboutViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 22/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit
import SwiftUI

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBSegueAction func showAboutView(_ coder: NSCoder) -> UIViewController? {
        let hostingController = UIHostingController(coder: coder, rootView: AboutView())
        hostingController!.view.backgroundColor = UIColor.clear;
        return hostingController
    }
    
}
