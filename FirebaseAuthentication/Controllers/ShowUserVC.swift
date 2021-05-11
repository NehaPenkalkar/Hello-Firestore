//
//  ShowUserVC.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 03/05/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ShowUserVC: UIViewController{
    
    @IBOutlet weak var userNameTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTV.delegate = self
        userNameTV.dataSource = self
        loadData()
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        logout()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            print("Signed Out")
        }catch let err{
            print(err)
        }
    }
    
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    private var service: userData?
    private var allusers = [appUser]() {
        didSet {
            DispatchQueue.main.async {
                self.users = self.allusers
            }
        }
    }
    
    
    var users = [appUser]() {
        didSet {
            DispatchQueue.main.async { [self] in
                self.userNameTV.reloadData()
            }
        }
    }
    
    
    func loadData() {
        service = userData()
        service?.get(collectionID: "users") { users in
            self.allusers = users
        }
    }
}


struct appUser {
    let firstname: String?
    let lastname: String?
}


class userData {
    let database = Firestore.firestore()
    
    func get(collectionID: String, handler: @escaping ([appUser]) -> Void) {
        database.collection("users")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(appUser.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}


extension appUser {
    static func build(from documents: [QueryDocumentSnapshot]) -> [appUser] {
        var users = [appUser]()
        for document in documents {
            users.append(appUser(firstname: document["firstname"] as? String ?? "", lastname: document["lastname"] as? String ?? ""))
        }
        return users
    }
}


extension ShowUserVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTVC") as! userTVC
        let name = users[indexPath.row]
        cell.userLbl.text = "\(name.firstname!) \(name.lastname!)"
        return cell
    }
}
