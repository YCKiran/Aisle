//
//  ViewController.swift
//  Aisle
//
//  Created by Chandra Kiran Reddy Yeduguri on 09/11/24.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var countryCodeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    var apiManager = APIManager()
    @MainActor var responseStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.delegate = self
    }

    @IBAction func continueButton(_ sender: UIButton) {
        if countryCodeField.text?.count != 2 && phoneNumberField.text?.count != 10 {
            //Need to write error warning
            //print("Please enter valid mobile number")
            self.showAlert(title: "Warning", message: "Please enter valid country code or mobile number", waitTime: 2.0)
            return
        } else {
            if let countryCode = countryCodeField.text, let phoneNumber = phoneNumberField.text {
                let phoneNumber = "\(countryCode)\(phoneNumber)"
                let endPoint = "/users/phone_number_login"
                let body: [String: AnyHashable] = [
                    "number": phoneNumber
                ]
                self.apiManager.makePostRequest(endPoint: endPoint, body: body, decodableObject: LogInResponse.self)
      
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOTP" {
            let otpVC = segue.destination as! OTPViewController
            if let countryCode = countryCodeField.text, let phoneNumber = phoneNumberField.text {
                let phoneNumber = "\(countryCode)\(phoneNumber)"
                print(phoneNumber)
                otpVC.phoneNumber = phoneNumber
            }
        }
    }
    
    func showAlert(title: String, message: String, waitTime: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            self.dismiss(animated: true)
        }
    }

}

//MARK: - ApiManagerDelegateMethods

extension LogInViewController: APIManagerDelegate {
    func successAPIResponse(_ apiManager: APIManager, response: Decodable) {
        let response = response as! LogInResponse
        DispatchQueue.main.async {
            if response.status {
                self.performSegue(withIdentifier: "goToOTP", sender: self)
//                print("success")
            } else {
                self.showAlert(title: "Error", message: "Invalid Phone Number", waitTime: 2.0)
//                print("Failure")
            }
        }
    }
    func didFailWithError(error: Error) {
        print("Error making POST API call \(error)")
    }
}
