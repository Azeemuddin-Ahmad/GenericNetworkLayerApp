//
//  ViewController.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel?.makeRequestWithCombine()
//        viewModel?.makeRequestWithAsyncAwait()
//        viewModel?.makeRequestWithCompletion()
    }


}

