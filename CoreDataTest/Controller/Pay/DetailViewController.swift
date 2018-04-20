//
//  detailView.swift
//  CoreDataTest
//
//  Created by Jiawei Zhou on 3/25/18.
//  Copyright © 2018 Jiawei Zhou. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController, UISearchBarDelegate ,NSFetchedResultsControllerDelegate{
    
    //General
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchResultsControllerDetail: NSFetchedResultsController<NSFetchRequestResult>!
    var selectedPlan : PlanList?
    @IBOutlet var detailView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Add New Payment
    @IBAction func addNewPayment(_ sender: UIBarButtonItem) {
//        //alert
//        let alert = UIAlertController(title:"Add New Plan", message:"Please input plan information", preferredStyle: .alert)
//        let alertActionAdd = UIAlertAction(title: "Add", style: .default){
//            (action) in
//            //*写入数据库
//            let context = self.getNSContext()
//            let entity = NSEntityDescription.entity(forEntityName: "SinglePayment", in: context)
//            let newPayment = SinglePayment(entity: entity!, insertInto: context)
//            newPayment.name = alert.textFields![0].text
//            newPayment.amount = 3.5
//            newPayment.date = Date() as NSDate
//            newPayment.plans = self.selectedPlan
//            do{
//                try context.save()
//            }catch{}
//            self.dismiss(animated: true, completion: nil)
//        }
//        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel){
//            (action) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(alertActionCancel)
//        alert.addAction(alertActionAdd)
//        alert.addTextField { (textField) in
//            textField.placeholder = "Please input payment name"
//        }
//        alert.addTextField { (textField) in
//            textField.placeholder = "Amount"
//        }
//        self.present(alert, animated: true)
        performSegue(withIdentifier: "goToAddPayment", sender: self)
    }
    
    //Edit
    @IBAction func editPlan(_ sender: UIBarButtonItem) {
//        let alert = UIAlertController(title: "Edit Current Plan", message:"Set New Plan Name", preferredStyle: .alert)
//        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel){
//            (action) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        let alertActionAdd = UIAlertAction(title: "Save", style: .default){
//            (action) in
//            //*更新Plan信息
//            self.selectedPlan?.name = alert.textFields?.first?.text
//            self.title = self.selectedPlan?.name
//            do{
//                try self.getNSContext().save()
//            }catch{}
//        }
//
//        alert.addAction(alertActionCancel)
//        alert.addAction(alertActionAdd)
//        alert.addTextField { (textField) in
//            textField.placeholder = "Please input payment name"
//        }
//        self.present(alert, animated: true)
        performSegue(withIdentifier: "goToEditPlan", sender: self)
    }
    
//MARK: - Main Code Start Here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View COnfigure
        detailView.separatorStyle = .none
        detailView.delegate = self
        detailView.dataSource = self
        
        //Search Bar
        searchBar.delegate = self

        //FetchControllerSetting
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pay")
        let predicate = NSPredicate(format: "plan.name MATCHES %@", selectedPlan!.name!)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchResultsControllerDetail = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.getNSContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsControllerDetail.delegate = self
        do{
            try fetchResultsControllerDetail.performFetch()
        }catch{}
        self.title = selectedPlan?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = selectedPlan?.name
    }
    
//MARK: - FetchControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.detailView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.detailView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                detailView.insertRows(at: [_newIndexPath as IndexPath], with: .automatic)
            }
            break
        case .delete:
            
            if let _indexPath = indexPath {
                selectedPlan?.updateAmount()
                detailView.deleteRows(at: [_indexPath], with: .automatic)
            }
            break
        case .update:
            if let _indexPath = indexPath {
                detailView.reloadRows(at: [_indexPath], with: .automatic)
            }
        default:
            detailView.reloadData()
        }
    }
    
//MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsControllerDetail.sections![section].numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        let object = fetchResultsControllerDetail.object(at: indexPath) as! Pay
        if object.isPayOff{
            cell.textLabel?.text = object.name! + " (PAYOFF)"
        }else{
            cell.textLabel?.text = object.name
        }
        cell.detailTextLabel?.text = String(object.amount)
        return cell
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let object = self.fetchResultsControllerDetail.object(at: indexPath)
        getNSContext().delete(object as! NSManagedObject)
        do{
            try getNSContext().save()
        }catch{}
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToReviewDetail", sender: self)
    }
    
//MARK: - searBar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != ""{
            let newSearchPredicate = NSPredicate(format: "name contains [cd] %@", searchBar.text!)
            let predicate = NSPredicate(format: "plan.name MATCHES %@", selectedPlan!.name!)
            let compoundPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [newSearchPredicate, predicate])
            fetchResultsControllerDetail.fetchRequest.predicate = compoundPredicate
            do{
                try fetchResultsControllerDetail.performFetch()
            }catch{}
        }else{
            let predicate = NSPredicate(format: "plan.name MATCHES %@", selectedPlan!.name!)
            fetchResultsControllerDetail.fetchRequest.predicate = predicate
            do{
                try fetchResultsControllerDetail.performFetch()
            }catch{}
        }
        detailView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        let predicate = NSPredicate(format: "plan.name MATCHES %@", selectedPlan!.name!)
        fetchResultsControllerDetail.fetchRequest.predicate = predicate
        do{
            try fetchResultsControllerDetail.performFetch()
        }catch{}
        detailView.reloadData()
    }
    
//MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddPayment"{
            let destinationVC = segue.destination as! AddPaymentViewController
            destinationVC.selectedPlan = self.selectedPlan
        }
        if segue.identifier == "goToEditPlan"{
            let destinationVC = segue.destination as! EditPlanViewController
            destinationVC.selectedPlan = self.selectedPlan
        }
        if segue.identifier == "goToReviewDetail"{
            let destinationVC = segue.destination as! PayDetailViewController
            destinationVC.selectedPlan = selectedPlan
            if let indexPath = detailView.indexPathForSelectedRow{
                destinationVC.selectedPay = (fetchResultsControllerDetail.object(at: indexPath) as! Pay)
            }
        }
    }
    
    
//MARK: - CoreData方法集合
    //获取NSContext
    func getNSContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    

}
