//
//  CartViewController.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 30/03/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import UIKit
import CoreData

class CustomCartCell: UITableViewCell {
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
}

class CartViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var cartManagedObject : Cart! = nil
    var storeManagedObject : Store! = nil
    var historyManagedObject : History! = nil
    
    var productPrices : Double = 0
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBAction func checkoutButton(_ sender: UIButton)
    {
        productPrices = 0
        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
        
        if (frc.fetchedObjects?.count)! > 0
        {
            for i in 0 ... ((frc.fetchedObjects?.count)! - 1)
            {
                checkout(forRowAt: [0,i])
            }
            let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchedRequest)
        
            do{try context.execute(batchDeleteRequest)}
            catch{}
            tableView.reloadData()
        }

    }
    
    func checkout(forRowAt indexPath: IndexPath)
    {
        // get the table/entity
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        
        // make a new History object
        historyManagedObject = History(entity: entity!, insertInto: context)
        
        
        cartManagedObject = frc.object(at: indexPath) as! Cart
        
        historyManagedObject.brand = cartManagedObject.brand
        historyManagedObject.genre = cartManagedObject.genre
        historyManagedObject.groupName = cartManagedObject.groupName
        historyManagedObject.image = cartManagedObject.image
        historyManagedObject.name = cartManagedObject.name
        historyManagedObject.price = cartManagedObject.price
        historyManagedObject.rating = cartManagedObject.rating
        
        // save it
        do{try context.save()}
        catch{print("CoreData Error: Context Doesn't Save")}
    }
    
    func calulateTotal()
    {
        let price = cartManagedObject.price
        productPrices += price
        
        totalPrice.text = "Total Price: €" + String(format: "%.2f", productPrices)
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>
    {
        // create a request for Cart table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        // give a sorter
        let sorter = NSSortDescriptor(key: "groupName", ascending: true)
        
        request.sortDescriptors = [sorter]
        
        // give a predicate for query
        //let predicate = NSPredicate(format: "%K >= %@", "name", "conor")
        
        //request.predicate = predicate
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.reloadData()
        if frc.fetchedObjects?.count == 0
        {
            totalPrice.text = "Total Price: €0.00"
        }
        productPrices = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"

        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to Store", style: .plain, target: self, action: #selector(CartViewController.goBack))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CustomCartCell

        // get the managed object at indexPath from frc
        cartManagedObject = frc.object(at: indexPath) as! Cart
        
        // use the attributes to fill the cell
        cell.cartName.text = cartManagedObject.name
        cell.cartPrice.text = "€" + String(format: "%.2f", cartManagedObject.price)
        cell.cartImage.image = UIImage(named: "images/" + cartManagedObject.image!)
        calulateTotal()
        
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cartManagedObject = frc.object(at: indexPath) as! Cart
            context.delete(cartManagedObject)
            productPrices = 0
            //calulateTotal()
            do{try context.save()}
            catch{}
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromCartToDetailSegue"
        {
            // get index path
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            // get the object from the context
            frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            frc.delegate = self
            
            do{try frc.performFetch()}
            catch{print("Core Data Error: FRC Cannot Perform Fetch")}
            cartManagedObject = frc.object(at: indexPath!) as! Cart
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
            let sorter = NSSortDescriptor(key: "groupName", ascending: true)
            request.sortDescriptors = [sorter]
            let predicate = NSPredicate(format: "%K == %@", "name", cartManagedObject.name!)
            request.predicate = predicate
            frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            frc.delegate = self
            
            do{try frc.performFetch()}
            catch{print("Core Data Error: FRC Cannot Perform Fetch")}
            
            storeManagedObject = frc.fetchedObjects?[0] as! Store!
            
            // get the destination controller
            let destination = segue.destination as! ProductDetailsViewController
            
            // push data to it
            destination.storeManagedObject = storeManagedObject
        }
        else if segue.identifier == "checkoutSegue"
        {
            let destination = segue.destination as! HistoryViewController
            
            destination.historyManagedObject = historyManagedObject
        }

    }
    
    func goBack()
    {
        navigationController?.popToRootViewController(animated: true)
    }
    

}
