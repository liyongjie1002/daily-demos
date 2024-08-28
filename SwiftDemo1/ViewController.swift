//
//  ViewController.swift
//  SwiftDemo1
//
//  Created by xdf on 2024/7/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func operateGif() {
        let vc = OCViewController()
        self.navigationController?.pushViewController(vc, animated:    true)
    }
    
    @IBAction func operateSlider() {
        let vc = KooTfParaseTextViewController()
        self.navigationController?.pushViewController(vc, animated:    true)
    }

    @IBAction func operateInherit() {
        let vc = ChildViewController()
        self.navigationController?.pushViewController(vc, animated:    true)
    }
    
    @IBAction func operateWish() {
        let vc = WishDemoViewController()
        self.navigationController?.pushViewController(vc, animated:    true)
    }
    
    @IBAction func operateKeyboard() {
        let vc = KeyboardDemoViewController()
        self.navigationController?.pushViewController(vc, animated:    true)
    }
    
    
}


