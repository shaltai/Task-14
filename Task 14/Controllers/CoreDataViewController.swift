import UIKit
//import CoreData

class CoreDataViewController: UITableViewController {
   let context = Persistance.shared.persistentContainer.viewContext
   
   var tasks: [TaskCoreData] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      getTasks()
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
   }
   // Get tasks
   func getTasks() {
      do {
         tasks = try context.fetch(TaskCoreData.fetchRequest())
         DispatchQueue.main.async {
            self.tableView.reloadData()
         }
      } catch let error as NSError {
         print("Error: \(error), \(error.userInfo)")
      }
   }
   
   // Add task
   @objc func addTask() {
      // Alert modal
      let alert = UIAlertController(title: "Add Task",
                                    message: nil,
                                    preferredStyle: .alert)
      // Alert textfield
      var alertTextfield = UITextField()
      alert.addTextField { textfield in
         alertTextfield = textfield
         textfield.placeholder = "New Task"
      }
      // Alert save button
      let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
         guard let taskText = alertTextfield.text,
               let self = self,
               !taskText.isEmpty else { return }
         
         let task = TaskCoreData(context: self.context)
         task.text = taskText
         
         guard self.context.hasChanges else { return }
         do {
            try self.context.save()
         } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
         }
         self.getTasks()
      }
      // Alert cancel button
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      // Add actions to alert
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      // Show alert modal
      present(alert, animated: true, completion: nil)
      
   }
   
   // MARK: - Table view data source
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tasks.count
   }
   
   // Populate table
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      let task = tasks[indexPath.row]
      
      var content = cell.defaultContentConfiguration()
      content.text = task.text
      cell.contentConfiguration = content
      
      return cell
   }
   
   // Delete task
   override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
         let task = self.tasks[indexPath.row]
         
         self.context.delete(task)
         guard self.context.hasChanges else { return }
         do {
            try self.context.save()
         } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
         }
         self.getTasks()
      }
      let deleteSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
      return deleteSwipe
   }
}
