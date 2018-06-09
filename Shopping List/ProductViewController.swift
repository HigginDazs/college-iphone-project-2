//
//  ProductViewController.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 30/03/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var storeManagedObject : Store! = nil
    
    var frc : NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    func makeRequest()->NSFetchRequest<NSFetchRequestResult>
    {
        // create a request for People collection
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        
        // give a sorter
        let primarySorter = NSSortDescriptor(key: "groupName", ascending: true)
        let secondarySorter = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [primarySorter, secondarySorter]
        
        
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Store"
        

        let backgroundImage = UIImage(named: "images/music_pattern.png")
        self.collectionView?.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        
        //make frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: "groupName", cacheName: nil)
            
        frc?.delegate = self
            
        do{try frc?.performFetch()}
        catch{print("Core Data Error: FRC Cannot Perform Fetch")}
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (frc!.sections?.count)!
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (frc!.sections![section].numberOfObjects)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductViewCell
        let cellHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! ProductHeaderView
        
        // get the managed object at indexPath from frc
        storeManagedObject = frc?.object(at: indexPath) as! Store
        
        // use the attributes to fill the cell
        cell.productImage?.image = UIImage(named: "images/" + storeManagedObject.image!)
        cellHeader.sectionHeader.text = storeManagedObject.groupName?.capitalized
        
        // Configure the cell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        
        if segue.identifier == "detailSegue"
        {
            // get index path
            let indexPath = collectionView?.indexPath(for: sender as! UICollectionViewCell)
            
            // get the object from the context
            storeManagedObject = frc!.object(at: indexPath!) as! Store
            
            // get the destination controller
            let destination = segue.destination as! ProductDetailsViewController
            
            // push data to it
            destination.storeManagedObject = storeManagedObject
        }
        
    }
    
    @IBAction func starButton(_ sender: UIBarButtonItem)
    {
        let alertController = UIAlertController(title: "Rating", message: "Thank you for choosing to rate our app! Would you like to give us 5 stars?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        {
            action in self.fiveStar()
        }
        alertController.addAction(OKAction)
        
        let maybeAction = UIAlertAction(title: "Maybe Later", style: .default)
        {
            action in self.maybeRating()
        }
        alertController.addAction(maybeAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        {
            action in self.cancelRating()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true){}
    }
    
    func cancelRating()
    {
        let alertController = UIAlertController(title: "Seriously Though", message: "I think you misunderstood me. I said: Would you like to give us 5 stars?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Um... OK?...", style: .default)
        {
            action in self.fiveStar()
        }
        alertController.addAction(OKAction)
        
        let maybeAction = UIAlertAction(title: "Maybe Later...", style: .default)
        {
            action in self.maybeRating()
        }
        alertController.addAction(maybeAction)
        
        let cancelAction = UIAlertAction(title: "Please Cancel", style: .cancel)
        {
            action in self.cancelRating()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true){}
    }
    
    func maybeRating()
    {
        let alertController = UIAlertController(title: "How About Now?", message: "How about now? Feel like rating us 5 stars now?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Um... OK?...", style: .default)
        {
            action in self.fiveStar()
        }
        alertController.addAction(OKAction)
        
        let maybeAction = UIAlertAction(title: "Maybe Later...", style: .default)
        {
            action in self.maybeRating()
        }
        alertController.addAction(maybeAction)
        
        let cancelAction = UIAlertAction(title: "Please Cancel", style: .cancel)
        {
            action in self.cancelRating()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true){}
    }
    
    func fiveStar()
    {
        let alertController = UIAlertController(title: "Thank You", message: "Thanks for rating us 5 star! That wasn't so hard, now was it?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Please let me go...", style: .default) { action in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true){}
    }
        
}
