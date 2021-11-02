import UIKit

class TodoRealmViewController: UITableViewController {
   let tasks = Persistance.shared.realm.objects(Task.self)
   
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
      
      //      tasks = Persistance.shared.realm.objects(Task.self)
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
      let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
         guard let taskText = alertTextField.text, !taskText.isEmpty else { return }
         
         Persistance.shared.save(task: taskText)
         self.tableView.reloadData()
      }
      // Alert cancel button
      let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
      // Add actions to alert
      alert.addAction(cancelAction)
      alert.addAction(saveAction)
      
      // Show alert modal
      present(alert, animated: true, completion: nil)
   }
   
   // Table View Data Source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tasks.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      let task = tasks[indexPath.row]
      
      var content = cell.defaultContentConfiguration()
      content.text = task.text
      cell.contentConfiguration = content
      
      return cell
   }
   
   // Table View Delegate
   override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
         try! Persistance.shared.realm.write {
            Persistance.shared.realm.delete(self.tasks[indexPath.row])
         }
         
         tableView.reloadData()
      }
      let deleteSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
      return deleteSwipe
   }
}
