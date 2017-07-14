//
//  ErrandTableViewController.swift
//  PinTask
//
//  Created by Placoderm on 7/13/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit
import CoreData

class ErrandTableViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //var errands = [("take dog to vet", "1920 Zanker Road, San Jose"), ("service car", ""), ("buy groceries", "")]
    
    var errands = [ErrandData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //CRUD - Read
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ErrandData")
        
        do {//database retreive errands
            let result = try managedObjectContext.fetch(request)
            errands = result as! [ErrandData]
        } catch {
            print ("\(error)")
        }
    }
    //CRUD - Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let errand = errands[indexPath.row]
        
        managedObjectContext.delete(errand)//database removal
        do {
            try managedObjectContext.save()
        } catch {
            print ("\(error)")
        }
        
        errands.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errands.count
    }
    //cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErrandCell", for: indexPath) as! errandCell
        cell.errandTitle?.text = errands[indexPath.row].errandText
        cell.errandAddress?.text = errands[indexPath.row].errandAddress
        return cell
    }
    
    //unwind segue
    //CRUD - Create
    @IBAction func unwindToErrandListView(sender: UIStoryboardSegue)
    {
        let new_errand = NSEntityDescription.insertNewObject(forEntityName: "ErrandData", into: managedObjectContext) as! ErrandData
        
        let sourceViewController = sender.source as! AddErrandViewController
        
        if let errand_title = sourceViewController.errandTextField.text {
            new_errand.errandText = errand_title
        }
        if let errand_address = sourceViewController.addressTextField.text {
            new_errand.errandAddress = errand_address
        }
        
        do {//database save new errand
            try managedObjectContext.save()
        } catch {
            print ("\(error)")
        }
        
        errands.append(new_errand)
        tableView.reloadData()
    }

}
