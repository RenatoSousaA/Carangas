//
//  ViewController.swift
//  Carangas
//
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {
    
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbBrand.text = car.brand
        lbPrice.text = "R$ \(car.price)"
        lbGasType.text = "Combustível: \(car.gas)"
        title = car.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddEditViewController {
            vc.car = car
        }
    }
}
