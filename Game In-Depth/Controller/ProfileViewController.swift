//
//  AboutViewController.swift
//  Game In-Depth
//
//  Created by Indra Permana on 22/07/20.
//  Copyright © 2020 IndraPP. All rights reserved.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .dark
    }
    
    @IBSegueAction func showAboutView(_ coder: NSCoder) -> UIViewController? {
        if let hostingController = UIHostingController(coder: coder, rootView: ProfileView()) {
            hostingController.view.backgroundColor = UIColor.clear
            return hostingController
        } else {
            return UIViewController()
        }
    }
}
