//
//  ViewController.swift
//  DataTransfersBetweenVC
//
//  Created by Mikhail Egorov on 30.06.2023.
//

import UIKit

protocol UpdatableDataController: AnyObject {
    var updatedData: String { get set }
}

class ViewController: UIViewController, UpdatableDataController, DataUpdateProtocol {
    
    @IBOutlet var dataLabel: UILabel!
    
    var updatedData: String = "Test data"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabel(withText: updatedData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // update textLabel data
    private func updateLabel(withText text: String) {
        dataLabel.text = updatedData
    }
    
    // MARK: - with Property
    @IBAction func editDataWithProperty(_ sender: Any) {
        // get transition VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! UpdatingDataController
        
        //to pass data
        editScreen.updatingData = dataLabel.text ?? ""
        
        //go to next screen
        self.navigationController?.pushViewController(editScreen as! UIViewController, animated: true)
    }
    
    // MARK: - with Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // define segue id
        switch segue.identifier {
        case "toEditScreen":
            // processing transition
            prepareEditScreen(segue)
        default:
            break
        }
    }
    
    @IBAction func unwindToFirstScreen(_ unwindSegue: UIStoryboardSegue) { }
    
    // preparing to go to the edit screen
    private func prepareEditScreen(_ segue: UIStoryboardSegue) {
        // secure extracting optional value
        guard let destinationController = segue.destination as? SecondViewController else { return }
        destinationController.updatingData = dataLabel.text ?? ""
    }
    
    // MARK: - with delegate
    // class ViewController: + DataUpdateProtocol
    func onDataUpdate(data: String) {
        updatedData = data
        updateLabel(withText: data)
    }
    
    // go from A to B
    // passing data using a property and setting a delegate
    @IBAction func editDataWithDelegate(_ sender: Any) {
        // get VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        
        //to pass data
        editScreen.updatingData = dataLabel.text ?? ""
        
        //set current class like delegate
        editScreen.handleUpdatedDataDelegate = self
        
        //go to next screen
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
    // MARK: - with Closure
    // go from A to B
    // passing data using a property and initialisation closure
    @IBAction func editDataWithClosure(_ sender: Any) {
        // get VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        
        //to pass data
        editScreen.updatingData = dataLabel.text ?? ""
        
        // to pass closure
        editScreen.completionHandler = { [unowned self] updatedValue in
            updatedData = updatedValue
            updateLabel(withText: updatedValue)
        }
        
        //go to next screen
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
    
}

