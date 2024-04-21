//
//  SecondViewController.swift
//  DataTransfersBetweenVC
//
//  Created by Mikhail Egorov on 30.06.2023.
//

import UIKit

protocol UpdatingDataController: AnyObject {
    var updatingData: String { get set }
}

class SecondViewController: UIViewController, UpdatingDataController {

    
    @IBOutlet var dataTextField: UITextField!
    
    var updatingData: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTextFieldData(withText: updatingData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateTextFieldData(withText text: String) {
        dataTextField.text = text
    }
    
    // MARK: - with Property
    @IBAction func saveDataWithProperty(_ sender: Any) {
        self.navigationController?.viewControllers.forEach({ viewController in
            (viewController as? UpdatableDataController)?.updatedData = dataTextField.text ?? ""
        })
    }
    
    // MARK: - with Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // define segue id
        switch segue.identifier {
        case "toFirstScreen":
            // processing transition
        prepareFirstScreen(segue)
        default:
            break
        }
    }
    
    private func prepareFirstScreen(_ segue: UIStoryboardSegue) {
        //secure extracting optional value
        guard let destinationController = segue.destination as? ViewController else { return }
        destinationController.updatedData = dataTextField.text ?? ""
    }
    
    // MARK: - with delegate
    var handleUpdatedDataDelegate: DataUpdateProtocol?
    
    // go from B to A
    // passing data using a delegate
    @IBAction func saveDataWithDelegate(_ sender: Any) {
        // get update data
        let updatedData = dataTextField.text ?? ""
        // call delegate method
        handleUpdatedDataDelegate?.onDataUpdate(data: updatedData)
        // return to prev screen
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - with closure
    var completionHandler: ((String) -> Void)?
    
    // go from B to A
    // passing data using a closure
    
    @IBAction func saveDataWithClosure(_ sender: Any) {
        // get update data
        let updatedData = dataTextField.text ?? ""
        // call delegate method
        completionHandler?(updatedData)
        // return to prev screen
        navigationController?.popViewController(animated: true)
    }
    
}
