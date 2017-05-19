//
//  ViewController.swift
//  Expodiseño
//
//  Created by expo on 02/03/17.
//  Copyright © 2017 Creategia360. All rights reserved.
//

import UIKit

func delay(_ seconds: Double, completion: @escaping ()->Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(seconds * 1000.00))){
        completion()
    }
}

class ViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }

    @IBOutlet var user_expo: UITextField!
    @IBOutlet var header_expo: UILabel!
    @IBOutlet var passwd_expo: UITextField!
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    
    var statusPosition = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        spinner.frame = CGRect(x: -20.0, y:6.0, width:20.0, height:20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        
        status.isHidden = true
        view.addSubview(status)
        
        
        status.addSubview(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        header_expo.center.x -= view.bounds.width
        user_expo.center.x -= view.bounds.width
        passwd_expo.center.x -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.8){
        self.header_expo.center.x += self.view.bounds.width
        }
       
        UIView.animate(withDuration: 1.5, delay: 0.8, options: [], animations: {
        self.user_expo.center.x += self.view.bounds.width
        
        },
                       completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [],
                       animations: {
                       
        self.passwd_expo.center.x += self.view.bounds.width
        },
        completion:nil)
        
        
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        let nextField = (textField == user_expo) ? passwd_expo : user_expo
        nextField?.becomeFirstResponder()
        return true
    }
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
    
        let UserEmail = user_expo.text
        let UserPassword = passwd_expo.text
        
        if ((UserEmail?.isEmpty)! || (UserPassword?.isEmpty)!){
        
            let myAlert = UIAlertController(title: "Atención", message: "Todos los campos son requeridos", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
            return
        }
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Cargando"
        spinningActivity.detailsLabel.text = "Por favor espere"
        
        let myURL = NSURL(string: "http://localhost:8888/ExpoApp_Server/Scripts/userSignin.php")
        let request = NSMutableURLRequest(url:myURL! as URL)
        request.httpMethod = "POST"
        let postString = "userEmail=\(UserEmail!)&userPassword=\(UserPassword!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        //URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler:{ (data, response, error) in
        DispatchQueue.main.async{
        
        spinningActivity.hide(true)
            
            if (error != nil)
            {
                
                let myAlert = UIAlertController(title: "Atención", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated:true, completion:nil)
                return
            }
        
            let _: NSError?
            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            if let parseJSON = json
            {
            let userId = parseJSON? ["userId"] as? String
            if (userId != nil)
            {
                
            UserDefaults.standard.set(parseJSON?["userFirstName"], forKey: "userFirstName")
            UserDefaults.standard.set(parseJSON?["userLastName"], forKey: "userLastName")
            UserDefaults.standard.set(parseJSON?["userId"], forKey: "userId")
            UserDefaults.standard.synchronize()
            //take user
                /*
                let Principal = self.storyboard?.instantiateViewController(withIdentifier: "PrincipalViewController") as! PrincipalViewController
                
                let mainPageNav = UINavigationController(rootViewController: Principal)
                
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = mainPageNav
                */
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.buildNavigationDrawer()
                
            }else{
                let userMessage = parseJSON? ["message"] as? String
                let myAlert = UIAlertController(title: "Atención", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated:true, completion:nil)
                return
    
            }
            
            }
            
        }
            
    }).resume()
        
    }
}

