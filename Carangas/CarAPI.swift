//
//  CarAPI.swift
//  Carangas
//
//  Created by Usuário Convidado on 17/10/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

enum APIError: Error {
    case badURL
    case taskError
    case badResponse
    case invalidStatusCode(Int)
}

class CarAPI {
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        configuration.timeoutIntervalForRequest = 30
        configuration.allowsCellularAccess = false
        configuration.httpMaximumConnectionsPerHost = 3
        return configuration
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    static func loadCars(onComplete: @escaping (Result<[Car], APIError>) -> Void) {
        guard let url = URL(string: basePath) else {
            onComplete(.failure(.badURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                onComplete(.failure(.taskError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.badResponse))
                return
            }
            
            if response.statusCode != 200 {
                onComplete(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                print("Data inexistente")
                return
            }
            
            do {
                let cars = try JSONDecoder().decode([Car].self, from: data)
                onComplete(.success(cars))
                print("Total de carros: ", cars.count)
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    class func deleteCar(_ car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void) {
        request(.delete, car: car, onComplete: onComplete)
    }
    
    class func createCar(_ car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void) {
        request(.create, car: car, onComplete: onComplete)
    }
    
    class func updateCar(_ car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void) {
        request(.update, car: car, onComplete: onComplete)
    }
    
    private class func request(_ operation: RESTOperation, car: Car, onComplete: @escaping (Result<Bool, APIError>) -> Void) {
        
        let urlString = basePath + "/" + (car._id ?? "")
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = operation.rawValue
        urlRequest.httpBody = try? JSONEncoder().encode(car)
        
        let tast = session.dataTask(with: urlRequest) { (data, _, _) in
            if data != nil {
                onComplete(.success(true))
            } else {
                onComplete(.failure(.taskError))
            }
        }
        
        tast.resume()
        
    }
}

    enum RESTOperation: String {
    case delete = "DELETE"
    case update = "UPDATE"
    case create = "POST"
}
