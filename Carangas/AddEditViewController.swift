//
//  AddEditViewController.swift
//  Carangas
//
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    var car: Car!

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if car != nil {
            title = "Edição"
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Editar carro", for: .normal)
        }
        
    }
    
    @IBAction func addEdit(_ sender: UIButton) {
        if car == nil {
            car = Car()
        }
        
        car.name = tfName.text!
        car.brand = tfBrand.text!
        car.gasType = scGasType.selectedSegmentIndex
        car.price = Int(tfPrice.text!) ?? 0
        
        if car._id == nil {
            CarAPI.createCar(car) { (_) in
                self.goBack()
            }
        } else {
            CarAPI.updateCar(car) { (_) in
                self.goBack()
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
