//
//  ViewController.swift
//  Checklist
//
//  Created by Hook Banner on 15.03.2022.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    var tableData: [[ChecklistItem?]?]!
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        // TODO запомнить выписать в Notion
        navigationItem.leftBarButtonItem = editButtonItem
        
        //REMEMBER
        tableView.allowsMultipleSelectionDuringEditing = true
        
        /// SECTION PART
        /// TODO Look what is UILocalizedIndexedCollation
        let collation = UILocalizedIndexedCollation.current()
        let sectionTitleCount = collation.sectionTitles.count
        var allSections = [[ChecklistItem?]?](repeating: nil, count: sectionTitleCount)
        var sectionNumber = 0
        
        for item in todoList.todos {
            sectionNumber = collation.section(for: item, collationStringSelector: #selector(getter: ChecklistItem.text))
            if allSections[sectionNumber] == nil {
                allSections[sectionNumber] = [ChecklistItem?]()
            }
            allSections[sectionNumber]!.append(item)
        }
        tableData = allSections
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //return todoList.todos.count
        return tableData[section] == nil ? 0 : tableData[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todoList.move(item: todoList.todos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let item = tableData[indexPath.section]?[indexPath.row] {
          configureText(for: cell, with: item)
          configureCheckmark(for: cell, with: item)
        }
      
      return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //REMEMBER. While multiple editing
        //
        if tableView.isEditing {
            return
        }
      if let cell = tableView.cellForRow(at: indexPath) {
        let item = todoList.todos[indexPath.row]
          toggleCheckMark(with: item)
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todoList.todos.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
      if let checkmarkCell = cell as? ChecklistTableViewCell {
          checkmarkCell.todoTextLabel.text = item.text
      }
    }
    
    func toggleCheckMark(with item: ChecklistItem) {
        item.toggleChecked()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
      if item.checked {
          checkmarkCell.checkMarkLabel.text = "√"
      } else {
          checkmarkCell.checkMarkLabel.text = ""
      }
        //item.toggleChecked()
    }
    
    @IBAction func addItem() {
        let newRowIndex = todoList.todos.count
        _ = todoList.newTodo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        //
        // REMEMBER
        //
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [ChecklistItem]()
            for indexPath in selectedRows {
                items.append(todoList.todos[indexPath.row])
            }
            todoList.remove(items: items)
            // Remember
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                addItemViewController.delegate = self
                addItemViewController.todos = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    addItemViewController.delegate = self
                    addItemViewController.todos = todoList
                    addItemViewController.itemToEdit = todoList.todos[indexPath.row]
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
    }
}


extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        //navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        //navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todos.count
        todoList.todos.append(item)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        print(item.text)
        if let index = todoList.todos.firstIndex(of: item) {
            print("here I")
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
    }
    
}
