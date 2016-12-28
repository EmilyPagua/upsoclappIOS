//
//  MenuController.swift
//  appupsocl
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    @IBOutlet weak var imagenUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    var servicesConnection =  ServicesConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("viewDidLoad - MenuController")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let preferences = UserDefaults.standard
        let imagenURL  = preferences.object(forKey: Customer.PropertyKey.imagenURL) as! String
        let firstName = preferences.object(forKey: Customer.PropertyKey.firstName) as! String
        let lastName = preferences.object(forKey: Customer.PropertyKey.lastName) as! String
        
        nameUser.text  = String ( lastName + "  " + firstName)
                
        loadImage(imagenURL, viewImagen: imagenUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print ("didReceiveMemoryWarning - MenuController")
    }


    func loadImage(_ urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage: urlImage as String!, completionHandler: { (moreWrapper, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                viewImagen.image = moreWrapper
                viewImagen.layer.frame = self.imagenUser!.layer.frame.insetBy(dx: 0, dy: 0)
                viewImagen.layer.borderColor = UIColor.white.cgColor
                viewImagen.layer.cornerRadius = self.imagenUser!.frame.height/2
                viewImagen.layer.masksToBounds = false
                viewImagen.clipsToBounds = true
                viewImagen.layer.borderWidth = 1
                viewImagen.contentMode = UIViewContentMode.scaleAspectFit
            })
        })
    }
    
    // MARK: - Table view data source
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
