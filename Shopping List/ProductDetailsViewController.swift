//
//  ProductDetailsViewController.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 30/03/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import UIKit
import CoreData

class ProductDetailsViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productGenre: UILabel!
    @IBOutlet weak var ProductRating: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var storeManagedObject : Store! = nil
    var cartManagedObject : Cart! = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addToCart(_ sender: UIButton)
    {
        // get the table/entity
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
        
        // make a new Cart object
        cartManagedObject = Cart(entity: entity!, insertInto: context)
        
        // fill it with Store data
        cartManagedObject.brand = storeManagedObject.brand
        cartManagedObject.genre = storeManagedObject.genre
        cartManagedObject.groupName = storeManagedObject.groupName
        cartManagedObject.image = storeManagedObject.image
        cartManagedObject.name = storeManagedObject.name
        cartManagedObject.price = storeManagedObject.price
        cartManagedObject.rating = storeManagedObject.rating
        
        // save it
        do{try context.save()}
        catch{print("CoreData Error: Context Doesn't Save")}
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Product Details"
        
        let backgroundImage = UIImage(named: "images/music_pattern.png")
        self.view?.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        productBrand.text = "Brand: " + storeManagedObject.brand!
        productName.text = "Name: " + storeManagedObject.name!
        productPrice.text = "Price: €" + String(format: "%.2f", storeManagedObject.price)
        productGenre.text = "Best Genre: " + storeManagedObject.genre!
        ProductRating.text = "User Rating: " + String(storeManagedObject.rating) + "/5"
        productImage.image = UIImage(named: "images/" + storeManagedObject.image!)
        productImage.contentMode = UIViewContentMode.scaleAspectFit
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to Store", style: .plain, target: self, action: #selector(ProductDetailsViewController.goBack))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "addCartSegue"
        {
            // get the destination controller
            let destination = segue.destination as! CartViewController
            
            // push data to it
            destination.cartManagedObject = cartManagedObject
        }
    }
    
    func goBack()
    {
        navigationController?.popToRootViewController(animated: true)
    }

}
