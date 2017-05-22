//
//  LeftSideViewController.swift
//  Expodiseño
//
//  Created by Rockyto Sánchez on 01/05/17.
//  Copyright © 2017 Creategia360. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDataSource {
    
    var menuItems:[String] = ["Main", "About", "Sign Out" ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
    return menuItems.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
    //var myCell = tableView.dequeueReusableCell(withIdentifier: "", forIndexPath: indexPath)
    let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! UITableViewCell
    
    
    myCell.textLabel?.text = menuItems[indexPath.row]
        
        
    return myCell
    
    }

}
