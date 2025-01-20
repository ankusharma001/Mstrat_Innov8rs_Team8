import UIKit

class LoginViewController: UIViewController {
    
    // Connect these outlets from your storyboard
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var circleview: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add underline to text fields
        addUnderline(to: emailTextField)
        addUnderline(to: passwordTextField)
        
        // Set up text field targets to monitor changes
        [emailTextField, passwordTextField].forEach {
            $0?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        // Initially disable the login button
        loginButton.isEnabled = false
        loginButton.alpha = 0.5 // Optional: Dim the button for visual feedback
        
        // Make circle views properly circular
        for view in circleview {
            let size = min(view.frame.width, view.frame.height)
            view.frame.size = CGSize(width: size, height: size)
            view.layer.cornerRadius = size / 2
            view.layer.masksToBounds = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addUnderline(to: emailTextField)
        addUnderline(to: passwordTextField)
    }
    
    // Function to add underline to a text field
    private func addUnderline(to textField: UITextField) {
        let underline = CALayer()
        underline.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        underline.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(underline)
    }
    
    // Enable the login button when all fields are filled
    @objc private func textFieldDidChange() {
        let isFormFilled = !(emailTextField.text?.isEmpty ?? true) &&
                           !(passwordTextField.text?.isEmpty ?? true)
        loginButton.isEnabled = isFormFilled
        loginButton.alpha = isFormFilled ? 1.0 : 0.5 // Adjust button opacity for feedback
    }
    
    // Action for the Login button
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }
        
        // Get the stored email and password
        let storedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        let storedPassword = UserDefaults.standard.string(forKey: "userPassword") ?? ""
        
        // Check if email and password match the stored values
        if email == storedEmail && password == storedPassword {
            // Navigate to the home screen
            guard let storyboard = storyboard else { return }
            let homeScreenVC = storyboard.instantiateViewController(withIdentifier: "homescreen")
            navigationController?.pushViewController(homeScreenVC, animated: true)
        } else {
            showAlert(message: "Invalid email or password.")
        }
    }
    
    // Helper function to show alert messages
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Input Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
