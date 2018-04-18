//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/23/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    //Delcare Button
    
    @IBOutlet weak var mainView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//MARK: - 添加新Plan
    @IBAction func addNew(_ sender: UIBarButtonItem) {
//        //alert
//        let alert = UIAlertController(title:"Add New Plan", message:"Please input plan information", preferredStyle: .alert)
//        let alertActionAdd = UIAlertAction(title: "Add", style: .cancel){
//            (action) in
//            //*写入数据库
//            let context = self.getNSContext()
//            let entity = NSEntityDescription.entity(forEntityName: "Plan", in: context)
//            let newPlan = Plan(entity: entity!, insertInto: context)
//            newPlan.name = alert.textFields?.first?.text
//            newPlan.date = Date() as NSDate
//            do{
//                try context.save()
//            }catch{}
//            self.dismiss(animated: true, completion: nil)
//        }
//        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default){
//            (action) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(alertActionAdd)
//        alert.addAction(alertActionCancel)
//        alert.addTextField { (textField) in
//            textField.placeholder = "Please input plan name"
//        }
//        self.present(alert, animated: true)
    }

    
//General
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
//MARK: - Main Code Start Here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View Configure
        mainView.separatorStyle = .none
        mainView.delegate = self
        mainView.dataSource = self
        searchBar.delegate = self
        
        //FetchControllerSetting
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanList")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = nil
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.getNSContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        do{
            try fetchResultsController.performFetch()
        }catch{}
    }
    
//MARK: - FetchControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.mainView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.mainView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                mainView.insertRows(at: [_newIndexPath as IndexPath], with: .automatic)
            }
            break
        case .delete:
            
            if let _indexPath = indexPath {
                mainView.deleteRows(at: [_indexPath], with: .automatic)
                
            }
            break
        case .update:
            if let _indexPath = indexPath {
                mainView.reloadRows(at: [_indexPath], with: .automatic)
            }
        default:
            mainView.reloadData()
        }
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = fetchResultsController.object(at: indexPath) as! PlanList
        cell.textLabel?.text = object.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let object = self.fetchResultsController.object(at: indexPath)
        getNSContext().delete(object as! NSManagedObject)
        do{
            try getNSContext().save()
        }catch{}
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPlanDetail", sender: self)
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlanDetail"{
            let destinationVC = segue.destination as! DetailViewController
            if let indexPath = mainView.indexPathForSelectedRow{
                destinationVC.selectedPlan = (fetchResultsController.object(at: indexPath) as! PlanList)
            }
        }
    }
    
//MARK: - searhBar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != ""{
            let newSearchPredicate = NSPredicate(format: "name contains [cd] %@", searchBar.text!)
            fetchResultsController.fetchRequest.predicate = newSearchPredicate
            do{
                try fetchResultsController.performFetch()
            }catch{}
        }else{
            do{
                try fetchResultsController.performFetch()
            }catch{}
        }
        mainView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        do{
            try fetchResultsController.performFetch()
        }catch{}
        mainView.reloadData()
    }
    
    
//CoreData方法集合
    //获取NSContext
    func getNSContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }


}

