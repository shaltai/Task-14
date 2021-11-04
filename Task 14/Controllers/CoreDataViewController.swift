import UIKit

class CoreDataViewController: ToDoViewController {
   let context = Persistance.shared.persistentContainer.viewContext
   
   var tasks: [TaskCoreData] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      super.setupTable(title: "Core Data Tasks", identifier: "cell", selector: #selector(addTask))
      
      tasks = Persistance.shared.getTasks()
      tableView.reloadData()
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
         
         Persistance.shared.save(context: self.context)
         self.tasks = Persistance.shared.getTasks()
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
   
   // Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tasks.count
   }
   
   // Populate table
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      let task = tasks[indexPath.row]
      
      // Cell text style
      let completedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                       NSAttributedString.Key.strokeColor: UIColor.systemGray,
                                                       NSAttributedString.Key.foregroundColor: UIColor.systemGray
      ]
      let regularAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                                                              NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single]
      
      var content = cell.defaultContentConfiguration()
      
      if let taskText = task.text {
         if task.isCompleted {
            content.attributedText = NSAttributedString(string: taskText, attributes: completedAttributes)
         } else {
            content.attributedText = NSAttributedString(string: taskText, attributes: regularAttributes)
         }
      }
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
         self.tasks = Persistance.shared.getTasks()
         tableView.reloadData()
      }
      let deleteSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
      return deleteSwipe
   }
   
   // Update task
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let selectedTask = tasks[indexPath.row]
      // Alert modal
      let alert = UIAlertController(title: "Edit Task",
                                    message: nil,
                                    preferredStyle: .alert)
      // Alert textfield
      var alertTextfield = UITextField()
      alert.addTextField { textfield in
         alertTextfield = textfield
         textfield.text = selectedTask.text
      }
      // Alert update button
      let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
         guard let taskText = alertTextfield.text,
               let self = self,
               !taskText.isEmpty else { return }
         
         selectedTask.text = taskText
         
         guard self.context.hasChanges else { return }
         do {
            try self.context.save()
         } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
         }
         self.tasks = Persistance.shared.getTasks()
         tableView.reloadData()
      }
      // Alert cancel button
      let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
      // Add actions to alert
      alert.addAction(cancelAction)
      alert.addAction(updateAction)
      // Show alert modal
      present(alert, animated: true, completion: nil)
   }
   
   // Complete task
   override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let task = self.tasks[indexPath.row]
      let actionTitle: String = {
         let title = task.isCompleted ? "Put Back" : "Complete"
         return title
      }()
      
      let completeAction = UIContextualAction(style: .normal, title: actionTitle) { _, _, _ in
         task.isCompleted = !task.isCompleted
         Persistance.shared.save(context: self.context)
         self.tasks = Persistance.shared.getTasks()
         tableView.reloadData()
      }
      completeAction.backgroundColor = task.isCompleted ? .systemBlue : nil
      
      let completeSwipe = UISwipeActionsConfiguration(actions: [completeAction])
      return completeSwipe
   }
}
