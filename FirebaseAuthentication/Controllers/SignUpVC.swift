//
//  SignUpVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 02/05/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var firstNameTextF: UITextField!
    @IBOutlet weak var secondNameTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var passTextF: UITextField!
    @IBOutlet weak var errLbl: UILabel!
    @IBOutlet weak var signUpBtn: CustomButton!
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        //        gradientLayer.startPoint = CGPoint(x: 1 , y: 0)
        //        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradient(colors: [#colorLiteral(red: 0.08147279187, green: 0.2558274707, blue: 0.3543707275, alpha: 1), #colorLiteral(red: 0.3595462222, green: 0.2391533887, blue: 0.5989160105, alpha: 1)])
        
        ifUserIsLoggedCheck()
    }
    
    func ifUserIsLoggedCheck(){
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShowUserVC") as! ShowUserVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch let err{
            print(err)
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        //VALIDATE FIELDS
        let error = validateFields()
        if error != nil{
            showErr(msg: error!)
            
        }else{
            
            //CREATE CLEANED VERSION OF DATA
            let firstName = firstNameTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = secondNameTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //CREATE THE USER
            Auth.auth().createUser(withEmail: email, password: password) { (result , err) in
                // check for error
                if err != nil {
                    
                    self.showErr(msg: "Error Creating User")
                }
                else{
                    
                    //User was created, store the first name and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname" : firstName, "lastname" : lastName, "uid" : result!.user.uid ]) { (error) in
                        if error != nil {
                            self.showErr(msg: "Failed to save data")
                            
                        }
                    }
                    
                    //TRANSITION TO THE Login SCREEN
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func showErr(msg: String){
        
        errLbl.text = msg
        errLbl.alpha = 1
    }
    
    
    //MARK:- Field Validation
    func validateFields() -> String? {
        
        if firstNameTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || secondNameTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passTextF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
            
        }
        
        //Check if the email is correct
        let cleanEmail = emailTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(cleanEmail) == false{
            
            return "Make sure you've entered email in correct format"
            
        }
        
        //Check if the password is secure
        let cleanPass = passTextF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPass) == false{
            
            return "Password should be at least 8 characters, contains a special character and a number"
        }
        return nil
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

