//
//  RegistroViewController.swift
//  Expodiseño
//
//  Created by expo on 09/03/17.
//  Copyright © 2017 Creategia360. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var usuarioNombreTextField: UITextField!
    @IBOutlet weak var usuarioApellidoTextField: UITextField!
    
    @IBOutlet weak var usuarioEmailTextField: UITextField!
    @IBOutlet weak var usuarioPassword: UITextField!
    @IBOutlet weak var usuarioRepitePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func botonRegistroTapped(sender: AnyObject){
        
        let usuarioEmail = usuarioEmailTextField.text
        let userPassword = usuarioPassword.text
        let userPasswordRepeat = usuarioRepitePassword.text
        let usuarioNombre = usuarioNombreTextField.text
        let usuarioApellido = usuarioApellidoTextField.text
        
        if(userPassword != userPasswordRepeat){
            
            //Muestra mensaje
            displayAlertMessage(userMessage: "Passwords no coinciden")
            return
        }
        if ( (usuarioEmail?.isEmpty)! || (userPassword?.isEmpty)! || (usuarioNombre?.isEmpty)! || (usuarioApellido?.isEmpty)! ){
            //Muestra una alerta
            displayAlertMessage(userMessage: "Todos los campos son requeridos")
            return
        }
        
       let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
       spinningActivity.labelText = "Cargando"
       spinningActivity.detailsLabelText = "Por favor espere"
        
        
        
        let myURL = NSURL(string: "http://expodiseno.com/ExpoApp_Server/Scripts/registerUser.php")
        let request = NSMutableURLRequest(url:myURL! as URL)
        request.httpMethod = "POST"
        
        let postString = "userEmail=\(usuarioEmail!)&userFirstName=\(usuarioNombre!)&userLastName=\(usuarioApellido!)&userPassword=\(userPassword!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                spinningActivity.hide(true)
                
                if error != nil {
                    self.displayAlertMessage(userMessage: (error?.localizedDescription)!)
                    return
                    
                }
                
                let _: NSError?
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    let userId = parseJSON? ["userId"] as? String
                    
                    if (userId != nil ){
                        
                        let myAlert = UIAlertController(title: "Atención", message: "Registro completado con éxito", preferredStyle: UIAlertControllerStyle.alert);
                        let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){(ACTION)in self.dismiss(animated: true, completion:nil)
                        }
                        myAlert.addAction(okAction);
                        self.present(myAlert, animated: true, completion:nil)
                        
                    }else{
                        
                        let errorMessage = parseJSON? ["message"] as? String
                        if (errorMessage != nil){
                            self.displayAlertMessage(userMessage: errorMessage!)
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
    func displayAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Atención", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion:nil)
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
