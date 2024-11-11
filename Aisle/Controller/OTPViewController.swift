//
//  OTPViewController.swift
//  Aisle
//
//  Created by Chandra Kiran Reddy Yeduguri on 09/11/24.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var otpNumberField: UITextField?
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
    var remainingTime: Int = 0
    var apiManager = APIManager()
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberLabel.text = phoneNumber
//        print(phoneNumberLabel)
        
        apiManager.delegate = self
        startTimer(minutes: 1)
    }
    

    @IBAction func continueTapped(_ sender: UIButton) {
        if otpNumberField?.text?.count != 4 {
            //Need to write error warning
            //print("Please enter 4 digit OTP number")
            self.showAlert(title: "Warning", message: "Please enter 4 digit OTP number", waitTime: 2.0)
            return
        } else {
            if let phoneNumber = phoneNumberLabel.text, let otpNumber = otpNumberField?.text {
                let endPoint = "/users/verify_otp"
                let body: [String: AnyHashable] = [
                    "number": phoneNumber,
                    "otp": otpNumber
                ]
                self.apiManager.makePostRequest(endPoint: endPoint, body: body, decodableObject: OTPResponse.self)
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
    
    func startTimer(minutes: Int) {
        remainingTime = minutes * 60
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerLabel() {
        if remainingTime > 0 {
            remainingTime -= 1
            
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            
            timerLabel.text = String(format: "%02d:%02d", minutes,seconds)
        } else {
            timer?.invalidate()
            timer = nil
            timerLabel.text = "00:00"
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
}

//MARK: - ApiManagerDelegateMethods

extension OTPViewController: APIManagerDelegate {
    func successAPIResponse(_ apiManager: APIManager, response: Decodable) {
        let otpResponse = response as! OTPResponse
        DispatchQueue.main.async {
            if otpResponse.token != nil {
                UserDefaults.standard.set(otpResponse.token, forKey: "token")
                //print(UserDefaults.standard.string(forKey: "token")!)
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                self.showAlert(title: "Error", message: "Something went wrong. Plese try again!", waitTime: 2.0)
            }
        }

    }
    func didFailWithError(error: Error) {
        print("Error making POST API call \(error)")
    }
}
