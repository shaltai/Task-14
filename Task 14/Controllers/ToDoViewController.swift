import UIKit

class ToDoViewController: UITableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   func setupTable(title: String = "Tasks", identifier: String, selector: Selector) {
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
      tableView.backgroundColor = .white
      // Navigation Bar Appearance
      let navigationBarAppearance = UINavigationBarAppearance()
      navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      navigationBarAppearance.backgroundColor = .systemBlue
      navigationController?.navigationBar.standardAppearance = navigationBarAppearance
      navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
      // Title
      navigationItem.title = title
      navigationController?.navigationBar.tintColor = .white
      navigationController?.navigationBar.prefersLargeTitles = true
      // Navigation Bar Button
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                          style: .plain,
                                                          target: self,
                                                          action: selector)
   }
}
