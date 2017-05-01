//
//  PrincipalViewController.swift
//  Expodiseño
//
//  Created by Rockyto Sánchez on 15/04/17.
//  Copyright © 2017 Creategia360. All rights reserved.
//

import UIKit

class PrincipalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var imagenDePerfil: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let userFirstName = UserDefaults.standard.string(forKey: "userFirstName")
        let userLastName = UserDefaults.standard.string(forKey: "userLastName")
        var userFullName = userFirstName! + " " + userLastName!
        userFullNameLabel.text = userFullName
        
        if (imagenDePerfil.image == nil)
        {
        let userId = UserDefaults.standard.string(forKey: "userId")
        
        let imageURL = NSURL(string:"http://localhost:8888/ExpoApp_Server/profile-pictures/\(userId!)/user-profile.jpg")
            
           // DispatchQueue.main.async (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            
           
           DispatchQueue.global().async {
                // Do background work
            let imageData = NSData(contentsOf: imageURL! as URL)
        
            if (imageData != nil){
            DispatchQueue.main.async(execute: {
                    // UI Updates
            self.imagenDePerfil.image = UIImage(data: imageData! as Data)
            })
            }
            
            
            
            }
            
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func botonSeleccionarFoto(_ sender: Any) {
    
        var myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myImagePicker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.labelText = "Cargando"
        spinningActivity.detailsLabelText = "Por favor espere"
        
    imagenDePerfil.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    
    self.dismiss(animated: true, completion: nil)
    
   myImageUploadRequest()
        
    }
    
    func myImageUploadRequest(){
    
        let myURL = NSURL (string: "http://expodiseno.com/ExpoApp_Server/Scripts/imageUpload.php")
        let request = NSMutableURLRequest(url:myURL! as URL)
        request.httpMethod = "POST"
        let userId:String? = UserDefaults.standard.string(forKey: "userId")
        let param = [
            "userId" : userId!
        ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary =\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(imagenDePerfil.image!, 1)
        if (imageData == nil){ return }
      
    
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            if error != nil{
        
                return
            }
            
            let _: NSError?
            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            DispatchQueue.main.async {
                if let parseJSON = json{
                    
                _ = parseJSON?["userId"] as? String
                    
                let userMessage = parseJSON?["message"] as? String
                    
                //self.displayAlertMessage(userMessage: userMessage!)
                self.displayAlertMessage(userMessage: userMessage!)
                    
                }else{
                    
                let userMessage = "No se pudo subir imagen"
                self.displayAlertMessage(userMessage: userMessage)
                    
                }
            }
            
            }.resume()

    }
    
   
    @IBAction func botonSalir(_ sender: Any) {
        
    
    UserDefaults.standard.removeObject(forKey: "userFirstName")
    UserDefaults.standard.removeObject(forKey: "userLastName")
    UserDefaults.standard.removeObject(forKey: "userId")
    UserDefaults.standard.synchronize()
        
    let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as! ViewController
        
    let signInNav = UINavigationController(rootViewController: signInPage)
        
    let appDelegate = UIApplication.shared.delegate
    appDelegate?.window??.rootViewController = signInNav
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func displayAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Atención", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion:nil)
        
    }
    
    
}
extension NSMutableData {
    
    func appendString(string: String) {
    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    append(data!)
        
        
    }
}
