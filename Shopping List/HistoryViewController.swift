//
//  HistoryViewController.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 30/03/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import UIKit
import CoreData

class CustomHistoryCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productGenre: UILabel!
}

class HistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate {

    var historyManagedObject : History! = nil
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let selectedIndex = searchBar.selectedScopeButtonIndex
        
        frc = NSFetchedResultsController(fetchRequest: searchRequest(searchChoice: searchText, scopeIndex: selectedIndex),  managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>
    {
        // create a request for History table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        // give a sorter
        let sorter = NSSortDescriptor(key: "groupName", ascending: false)
        
        request.sortDescriptors = [sorter]
        
        // give a predicate for query
        //let predicate = NSPredicate(format: "%K >= %@", "name", "conor")
        
        //request.predicate = predicate
        return request
    }
    
    func searchRequest(searchChoice : String, scopeIndex : Int)->NSFetchRequest<NSFetchRequestResult>
    {
        // create a request for History table
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        
        // give a sorter
        let sorter = NSSortDescriptor(key: "groupName", ascending: true)
        
        request.sortDescriptors = [sorter]
        
        var predicate : NSPredicate? = nil
        
        switch scopeIndex
        {
            case 0:
                predicate = NSPredicate(format: "%K CONTAINS[c] %@", "name", searchChoice)
            case 1:
                predicate = NSPredicate(format: "%K CONTAINS[c] %@", "brand", searchChoice)
            case 2:
                predicate = NSPredicate(format: "%K CONTAINS[c] %@", "genre", searchChoice)
            default:
                break
        }
        
        // give a predicate for query
        request.predicate = predicate
        
        return request
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "History"
        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to Store", style: .plain, target: self, action: #selector(HistoryViewController.goBack))

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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! CustomHistoryCell
        
        // get the managed object at indexPath from frc
        historyManagedObject = frc.object(at: indexPath) as! History
        
        // use the attributes to fill the cell
        cell.productName.text = historyManagedObject.name
        cell.productBrand.text = historyManagedObject.brand
        cell.productGenre.text = historyManagedObject.genre
        cell.productPrice.text = "€" + String(format: "%.2f", historyManagedObject.price)
        cell.productImage.image = UIImage(named: "images/" + historyManagedObject.image!)
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            historyManagedObject = frc.object(at: indexPath) as! History
            context.delete(historyManagedObject)
            do{try context.save()}
            catch{}
        }
    }
    
    func goBack()
    {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func statsButton(_ sender: UIBarButtonItem)
    {
        
        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
        
        var alertController : UIAlertController? = nil
        
        var alertMessage : String = "There are no statistics available."
        
        if (frc.fetchedObjects?.count)! > 0
        {
            alertMessage = "Purchased items: " + String((frc.fetchedObjects?.count)!) + "\n" +
                "Total price: €" + String(format: "%.2f", getPrice()) + "\n" +
                "Average item price: €" + String(format: "%.2f", getAvg()) + "\n" +
                "Cheapest item: " + getMinMax(minOrMax: 0) + "\n" +
                "Most expensive item: " + getMinMax(minOrMax: 1)
        }
        
        alertController = UIAlertController(title: "Statistics", message: alertMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
        alertController?.addAction(OKAction)
        self.present(alertController!, animated: true){}
        
        
        
    }
    
    func getPrice() -> Double
    {
        var totalPrice : Double = 0
        
        for i in 0 ... ((frc.fetchedObjects?.count)! - 1)
        {
            historyManagedObject = frc.object(at: [0,i]) as! History
            totalPrice += historyManagedObject.price
        }
        
        return totalPrice
    }
    
    func getAvg() -> Double
    {
        let avgPrice = getPrice() / Double((frc.fetchedObjects?.count)!)
        return avgPrice
    }
    
    func getMinMax(minOrMax : Int) -> String
    {
        var items : [(String, Double)] = []
        var sortedItems : [(String, Double)] = []
        
        for i in 0 ... ((frc.fetchedObjects?.count)! - 1)
        {
            historyManagedObject = frc.object(at: [0,i]) as! History
            let values = (historyManagedObject.name!, historyManagedObject.price)
            items.append(values)
        }
        
        if minOrMax == 0
        {
            sortedItems = items.sorted{$0.1 < $1.1}
        }
        else
        {
            sortedItems = items.sorted{$0.1 > $1.1}
        }
        
        return sortedItems[0].0
    }
    

}
