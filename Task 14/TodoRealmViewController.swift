import UIKit

class TodoRealmViewController: UITableViewController {
   var tasks: [String] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupTable()
   }
   
   func setupTable() {
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//      view.backgroundColor = .white
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
         if let taskText = alertTextField.text, !taskText.isEmpty {
            self.tasks.append(taskText)
            self.tableView.reloadData()
         }
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
      return tasks.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      var content = cell.defaultContentConfiguration()
      content.text = tasks[indexPath.row]
      cell.contentConfiguration = content
      return cell
   }
   
   // Table View Delegate
   override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
         self.tasks.remove(at: indexPath.row)
         tableView.reloadData()
      }
      let deleteSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
      return deleteSwipe
   }
}
