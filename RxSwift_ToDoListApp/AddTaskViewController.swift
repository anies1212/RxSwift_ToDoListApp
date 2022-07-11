//
//  AddTaskViewController.swift
//  RxSwift_ToDoListApp
//
//  Created by anies1212 on 2022/07/10.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var barButtonItem: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    private let subject = PublishSubject<Task>()
    var inputtedTask: Observable<Task>{
        return self.subject.asObservable()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func save(){
        
        guard let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex), let title = self.textField.text else {return}
        let task = Task(title: title, priority: priority)
        subject.onNext(task)
        self.dismiss(animated: true)
    }
    


}
