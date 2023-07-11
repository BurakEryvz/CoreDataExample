//
//  ModelTableViewController.swift
//  appWithCoreData
//
//  Created by Burak Eryavuz on 10.07.2023.
//

import UIKit
import CoreData

class ModelTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var models = [ModelsOfBrand]()
    var parentBrand : CarBrands? {
        didSet{
            print("Car brand is selected.")
            self.loadModel()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.modelTableCellName, for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row].modelName! + " " + models[indexPath.row].releaseDate!
        
        return cell
    }
    
    //MARK: - ADD BUTTON METHOD
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldModelName = UITextField()
        var textFieldModelReleaseDate = UITextField()
        
        let alert = UIAlertController(title: "Add Model", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newModel = ModelsOfBrand(context: self.context)
            newModel.modelName = textFieldModelName.text
            newModel.releaseDate = textFieldModelReleaseDate.text
            newModel.parentBrand = self.parentBrand
            
            self.models.append(newModel)
            self.saveModel()
            
        }
        
        alert.addTextField { fieldName in
            textFieldModelName = fieldName
            textFieldModelName.placeholder = "Typing model name..."
        }
        
        alert.addTextField { fieldDate in
            textFieldModelReleaseDate = fieldDate
            textFieldModelReleaseDate.placeholder = "Typing release date..."
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
        
    }
    
    //MARK: - MODEL MANIPULATION METHODS
    
    func saveModel(){
        
        do{
            try context.save()
        } catch {
            print("Error saving model.")
        }
        
        tableView.reloadData()
    }
    
    
    func loadModel(){
        
        let request : NSFetchRequest<ModelsOfBrand> = ModelsOfBrand.fetchRequest()
        
        let predicate = NSPredicate(format: "parentBrand.brandName MATCHES %@", parentBrand!.brandName!)
        
        request.predicate = predicate
        
        do{
            models = try context.fetch(request)
        } catch {
            print("Error fetching model.")
        }
        
        
    }
    
}



