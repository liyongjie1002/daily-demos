//
//  WishDemoViewController.swift
//  SwiftDemo1
//
//  Created by xdf on 2024/8/27.
//

import UIKit

class WishDemoViewController: UIViewController {

    let viewModel = LAGlobalViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(wishView)
        wishView.frame = CGRectMake(0, 100, self.view.frame.size.width, 300)
        
        viewModel.requestPersonas { personas in
            self.wishView.configData(personas: personas)
        }
    }
    
    lazy var wishView: LAWishWellView = {
        let view = LAWishWellView()
        return view
    }()

}
