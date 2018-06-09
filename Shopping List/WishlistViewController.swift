//
//  WishlistViewController.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 08/04/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import UIKit
import CoreData

class CustomWishListCell: UITableViewCell {
    
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listBrand: UILabel!
    @IBOutlet weak var listRating: UILabel!
    @IBOutlet weak var listGenre: UILabel!
}

class WishlistViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // coredata elements: context, entity, managedObject, frc
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var wishlistManagedObject : Wishlist! = nil
    
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>
    {
        // create a request for People table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Wishlist")
        
        // give a sorter
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Wishlist"
        
        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (frc.sections?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistCell", for: indexPath) as! CustomWishListCell

        // get the managed object at indexPath from frc
        wishlistManagedObject = frc.object(at: indexPath) as! Wishlist
        
        // use the attributes to fill the cell
        cell.listName.text = wishlistManagedObject.name
        cell.listBrand.text = wishlistManagedObject.brand
        cell.listGenre.text = wishlistManagedObject.genre
        cell.listRating.text = String(format: "%.2f", wishlistManagedObject.rating) + "/5"
        cell.listImage.image = UIImage(named: "images/" + wishlistManagedObject.image!.lowercased() + ".png")
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            wishlistManagedObject = frc.object(at: indexPath) as! Wishlist
            context.delete(wishlistManagedObject)
            do{try context.save()}
            catch{}        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSegue"
        {
            // get the index path
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            // get the object at the index path from frc
            wishlistManagedObject = frc.object(at: indexPath!) as! Wishlist
            
            // get the destination controller
            let destination = segue.destination as! AddToWishlistViewController
            
            // push the data to it
            destination.wishlistManagedObject = wishlistManagedObject
        }

    }
    

}
