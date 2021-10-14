import UIKit
import RealmSwift

class TodoRealmViewController: UITableViewController {
   private let realm = try! Realm()
   var tasks: Results<Task>?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupTable()
   }
   
   func setupTable() {
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      // Navigation Bar Appearance
      let navigationBarAppearance = UINavigationBarAppearance()
      navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      navigationBarAppearance.backgroundColor = .systemBlue
      navigationController?.navigationBar.standardAppearance = navigationBarAppearance
      navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
      // Title
      navigationItem.title = "Tasks"
      navigationController?.navigationBar.tintColor = .white
      navigationController?.navigationBar.prefersLargeTitles = true
      // Navigation Bar Button
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(addTask))
      
      tasks = realm.objects(Task.self)
   }
   
   @objc func addTask(_ sender: AnyObject) {
      // Alert modal
      let alert = UIAlertController(title: "New Task",
                                    message: nil,
                                    preferredStyle: .alert)
      // Alert Textfield
      var alertTextField = UITextField()
      alert.addTextField { textField in
         alertTextField = textField
         textField.placeholder = "New task"
      }
      // Alert save button
      let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
         guard let taskText = alertTextField.text, !taskText.isEmpty else { return }
         
         let task = Task()
         task.text = taskText
         try! self.realm.write {
            self.realm.add(task)
         }
         self.tableView.reloadData()
      }
      // Alert cancel button
      let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
      // Add actions to alert
      alert.addAction(saveButton)
      alert.addAction(cancelButton)
      
      // Show modal
      present(alert, animated: true, completion: nil)
   }
   
   // Table View Data Source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tasks?.count ?? 0
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      if let task = tasks?[indexPath.row] {
         
         var content = cell.defaultContentConfiguration()
         content.text = task.text
         cell.contentConfiguration = content
      }
      
      return cell
   }
   
   // Table View Delegate
   override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
         try! self.realm.write {
            guard let tasks = self.tasks else { return }
            self.realm.delete(tasks[indexPath.row])
         }
//         self.tasks?.remove(at: indexPath.row)
         tableView.reloadData()
      }
      let deleteSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
      return deleteSwipe
   }
}
