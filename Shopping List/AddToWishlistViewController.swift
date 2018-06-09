//
//  AddToWishlistViewController.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 08/04/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import UIKit
import CoreData

class AddToWishlistViewController: UIViewController {

    // outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var instrumentChoice: UISegmentedControl!
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var sliderVal: UILabel!
    
    var instrumentSwitch : String = ""
    
    // coredata elements: context and managedObject
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var wishlistManagedObject : Wishlist! = nil
    
    func saveList()
    {
        // get the table/entity
        let entity = NSEntityDescription.entity(forEntityName: "Wishlist", in: context)
        
        // make a new Person object
        wishlistManagedObject = Wishlist(entity: entity!, insertInto: context)
        
        // fill it with data from textfields
        wishlistManagedObject.name          = nameTextField.text
        wishlistManagedObject.brand         = brandTextField.text
        wishlistManagedObject.genre         = genreTextField.text
        wishlistManagedObject.rating        = Double(ratingSlider.value)
        wishlistManagedObject.instrument    = instrumentChoice.titleForSegment(at: instrumentChoice.selectedSegmentIndex)
        wishlistManagedObject.image         = instrumentChoice.titleForSegment(at: instrumentChoice.selectedSegmentIndex)
        
        // save it
        do{try context.save()}
        catch{print("CoreData Error: Context Doesn't Save")}
    }
    
    func updateList()
    {
        // fill it with data from textfields
        wishlistManagedObject.name          = nameTextField.text
        wishlistManagedObject.brand         = brandTextField.text
        wishlistManagedObject.genre         = genreTextField.text
        wishlistManagedObject.rating        = Double(ratingSlider.value)
        wishlistManagedObject.instrument    = instrumentChoice.titleForSegment(at: instrumentChoice.selectedSegmentIndex)
        wishlistManagedObject.image         = instrumentChoice.titleForSegment(at: instrumentChoice.selectedSegmentIndex)
        
        // save it
        do{try context.save()}
        catch{print("CoreData Error: Context Doesn't Save")}
    }

    @IBAction func addUpdate(_ sender: UIButton)
    {
        // call save or update
        if wishlistManagedObject != nil
        {
            updateList()
        }
        else
        {
            saveList()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateRating(_ sender: UISlider)
    {
        sliderVal.text = String(format: "%.2f", ratingSlider.value) + "/5.0"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate textfields with managaedObject data
        if wishlistManagedObject != nil
        {
            nameTextField.text          = wishlistManagedObject.name
            brandTextField.text         = wishlistManagedObject.brand
            genreTextField.text         = wishlistManagedObject.genre
            ratingSlider.value          = Float(wishlistManagedObject.rating)
            sliderVal.text              = String(format: "%.2f", wishlistManagedObject.rating) + "/5.0"
            
            instrumentSwitch = wishlistManagedObject.instrument!
            
            switch instrumentSwitch {
            case "Bass":
                instrumentChoice.selectedSegmentIndex = 0
            case "Drum":
                instrumentChoice.selectedSegmentIndex = 1
            case "Guitar":
                instrumentChoice.selectedSegmentIndex = 2
            case "Keyboard":
                instrumentChoice.selectedSegmentIndex = 3
            default:
                instrumentChoice.selectedSegmentIndex = 4
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
