//
//  ForgetPassVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 04/05/21.
//

import UIKit
import Firebase

class ForgetPassVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        applyGradient(colors: [#colorLiteral(red: 0.08147279187, green: 0.2558274707, blue: 0.3543707275, alpha: 1), #colorLiteral(red: 0.3595462222, green: 0.2391533887, blue: 0.5989160105, alpha: 1)])
    }
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func forgotPress(_ sender: UIButton) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailTF.text!) { (error) in
            if let error = error {
                
                self.showErr(msg: "\(error.localizedDescription)")
                return
            }
            
            let alert = UIAlertController(title: "Reset Password Link Sent to Registered Email", message: "Change your password on given link and try again", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .default) { alert in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErr(msg: String){
        
        let alert = UIAlertController(title: "\(msg)", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
