//
//  Task.swift
//  RxSwift_ToDoListApp
//
//  Created by anies1212 on 2022/07/10.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}


