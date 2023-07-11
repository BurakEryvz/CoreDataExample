//
//  BrandTableViewController.swift
//  appWithCoreData
//
//  Created by Burak Eryavuz on 10.07.2023.
//

import UIKit
import CoreData


class BrandTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var brands = [CarBrands]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBrand()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.brandTableCellName, for: indexPath)
        
        cell.textLabel?.text = brands[indexPath.row].brandName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToModelSegue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ModelTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.parentBrand = brands[indexPath.row]
        }
    }
    
    
    //MARK: - ADD BUTTON METHOD
    @IBAction func addButtoPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Brand", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newBrand = CarBrands(context: self.context)
            newBrand.brandName = textField.text!
            self.brands.append(newBrand)
            self.saveBrand()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Add a new Brand"
        }
        
        present(alert, animated: true)
    }
    
    
    
    
    
    
    
    
    //MARK: - Model Manipualtion Methods
    
    func saveBrand() {
        
        do {
            try context.save()
        } catch {
            print("Error saving brands")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadBrand() {
        
        
        let request : NSFetchRequest<CarBrands> = CarBrands.fetchRequest()
        
        
        do {
            self.brands = try context.fetch(request)
        } catch {
            print("Error loading brands")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    

}
