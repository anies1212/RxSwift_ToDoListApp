//
//  TaskListViewController.swift
//  RxSwift_ToDoListApp
//
//  Created by anies1212 on 2022/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var button: UIButton!
    @IBOutlet var segmentedControl: UISegmentedControl!
    private let bag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        return cell
    }
    
    private func updateUI(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addTaskNC = navC.viewControllers.first as? AddTaskViewController else {return}
        addTaskNC.inputtedTask.subscribe(onNext: { task in
            let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex-1)
            var existingTask = self.tasks.value
            existingTask.append(task)
            self.tasks.accept(existingTask)
            self.filter(by: priority)
        }).disposed(by: bag)
    }
    
    @IBAction func priorityValueChange(segmentedControl: UISegmentedControl){
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex-1)
        filter(by: priority)
    }
    
    private func filter(by priority: Priority?){
        if priority == nil{
            self.filteredTasks = self.tasks.value
            updateUI()
        } else {
            self.tasks.map({ tasks in
                return tasks.filter({$0.priority == priority!})
            }).subscribe(onNext: { tasks in
                self.filteredTasks = tasks
                print("self.filteredTasks:\(self.filteredTasks)")
                self.updateUI()
            }).disposed(by: bag)
        }
    }
    



}

