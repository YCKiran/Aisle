//
//  APIManager.swift
//  Aisle
//
//  Created by Chandra Kiran Reddy Yeduguri on 09/11/24.
//

import Foundation

protocol APIManagerDelegate {
    func successAPIResponse(_ apiManager: APIManager , response: Decodable)
    func didFailWithError(error: Error)
}

struct APIManager {
    var delegate: APIManagerDelegate?
    
    func makePostRequest(endPoint: String, body: [String: AnyHashable], decodableObject: Decodable.Type){
        let url = "\(Constants.BASE_URL)\(endPoint)"
        
        guard let url = URL(string: url) else{
            print("Invalid url")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error setting request body")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            if let responseData = data {
                do {
                    let decodedData = try JSONDecoder().decode(decodableObject.self, from: responseData)
                    self.delegate?.successAPIResponse(self, response: decodedData)
                } catch {
                    self.delegate?.didFailWithError(error: error)
                }
            }
            
        }
        
        task.resume()
    }
    
    
    func makeGETRequest(endPoint: String, decodableObject: Decodable.Type){
        let url = "\(Constants.BASE_URL)\(endPoint)"
        
        guard let url = URL(string: url) else{
            print("Invalid url")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "token") {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            if let responseData = data {
                do {
                    let decodedData = try JSONDecoder().decode(decodableObject.self, from: responseData)
                    self.delegate?.successAPIResponse(self, response: decodedData)
                } catch {
                    self.delegate?.didFailWithError(error: error)
                }
            }
            
        }
        
        task.resume()
    }
    
}
