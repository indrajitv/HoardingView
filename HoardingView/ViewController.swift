//
//  ViewController.swift
//  HoardingView
//
//  Created by Indrajit Chavda on 26/04/22.
//

import Cocoa

class ViewController: NSViewController {

    lazy var hoardingView = HoardingView(on: self.view)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hoardingView.show(attributes: .init(title: "Oops"))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

