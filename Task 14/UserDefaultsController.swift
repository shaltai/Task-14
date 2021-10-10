import UIKit
import Foundation

class UserDefaultsController: UIViewController {
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var surnameTextField: UITextField!

   override func viewDidLoad() {
      super.viewDidLoad()
      setupTextFilds()
   }

   func setupTextFilds () {
      nameTextField.text = Persistance.shared.userName
      surnameTextField.text = Persistance.shared.userSurname
   }

   @IBAction func setupNameTextField(_ sender: UITextField) {
      Persistance.shared.userName = sender.text
   }
   
   @IBAction func setupSurnameTextField(_ sender: UITextField) {
      Persistance.shared.userSurname = sender.text
   }
   
}

