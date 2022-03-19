//
//  TodoList.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

class TodoList {
  
  var todos: [ChecklistItem] = []
  let todosTexts: [String] = ["Take a jog", "Watch a movie", "Code an app", "Walk the dog", "Study design patterns"]
  
  init() {
      
      let preArray = [Int](repeating: 1, count: 5)
      let length = todosTexts.count
      todos = preArray.enumerated().map { (index, element) in
          let rowItem = ChecklistItem()
          rowItem.text = todosTexts[index % length]
          return rowItem
      }
    
  }
    
    func newTodo() -> ChecklistItem {
      let item = ChecklistItem()
      item.text = randomTitle()
      item.checked  = true
      todos.append(item)
      return item
    }
    
    private func randomTitle() -> String {
      let titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
      let randomNumber = Int.random(in: 0 ... titles.count - 1)
      return titles[randomNumber]
    }
  
    func move(item: ChecklistItem, to index: Int) {
        guard let currentIndex = todos.firstIndex(of: item) else {
            return
        }
        todos.remove(at: currentIndex)
        todos.insert(item, at: index)
    }
    
    func remove(items: [ChecklistItem]) {
        for item in items {
            if let index = todos.firstIndex(of: item) {
                todos.remove(at: index)
            }
        }
    }
}
