//
//  SnackbarViewController.swift
//  Simplenote
//
//  Created by Kevin LaCoste on 2020-11-09.
//  Copyright © 2020 Automattic. All rights reserved.
//

import UIKit

protocol SnackbarViewControllerDelegate: AnyObject {
    func snackbarActionWasTapped(sender: SnackbarViewController)
}

class SnackbarViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var delegate: SnackbarViewControllerDelegate?
    
    deinit {
        print("VC deinit.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 12
        view.backgroundColor = .lightGray
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionButton.isEnabled = false
        delegate?.snackbarActionWasTapped(sender: self)
    }
}
