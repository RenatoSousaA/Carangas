//
//  CarsTableViewController.swift
//  Carangas
//
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(loadCars), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCars()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CarViewController {
            let car = cars[tableView.indexPathForSelectedRow!.row]
            vc.car = car
        }
    }
    
    @objc
    func loadCars() {
        CarAPI.loadCars { [weak self] (result) in
            
            switch result {
            case .success(let cars):
                self?.cars = cars
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let apiError):
                switch apiError {
                case .badResponse:
                    print("Response inválido")
                default:
                    print("Outro erro!")
                }
            }
            
        }
    }
    
    //    func updateCars(cars: [Car]) {
    //        self.cars = cars
    //        tableView.reloadData()
    //    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            CarAPI.deleteCar(car) { [weak self] (result) in
                switch result {
                case .success:
                    self?.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self?.refreshControl?.endRefreshing()
                    }
                case .failure:
                    print("Falhou")
                }
            }
        }
    }
}

