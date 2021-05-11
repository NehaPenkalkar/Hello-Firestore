//
//  LoginVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 02/05/21.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    @IBOutlet weak var enterEmailTextF: UITextField!
    @IBOutlet weak var enterPassTextF: UITextField!
    @IBOutlet weak var errLbl: UILabel!
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        applyGradient(colors: [#colorLiteral(red: 0.08147279187, green: 0.2558274707, blue: 0.3543707275, alpha: 1), #colorLiteral(red: 0.3595462222, green: 0.2391533887, blue: 0.5989160105, alpha: 1)])
    }
    
    
    func validateFields() -> String? {
        
        if enterEmailTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            enterPassTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        //Check if the email is correct
        let cleanEmail = enterEmailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(cleanEmail) == false{
            
            return "Make sure you've entered email in correct format"
        }
        
        //Check if the password is secure
        let cleanPass = enterPassTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPass) == false{
            
            return "Password should be at least 8 characters, contains a special character and a number"
        }
        return nil
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        //validate fields
        let error = validateFields()
        if error != nil{
            showErr(msg: error!)
            
        }
        else{
            let email = enterEmailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = enterPassTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //SignIn user
            Auth.auth().signIn(withEmail: email, password: password) { (result , error) in
                if error != nil{
                    
                    self.errLbl.text = error!.localizedDescription
                    self.errLbl.alpha = 1
                }
                else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowUserVC") as! ShowUserVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    func showErr(msg: String){
        
        errLbl.text = msg
        errLbl.alpha = 1
    }
    
    
    func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
