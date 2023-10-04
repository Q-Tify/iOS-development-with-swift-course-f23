import UIKit

class ViewController: UIViewController {
    
    private let profileView = ProfileView()
    private let profileInputView = ProfileInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        view.backgroundColor = .white
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear called")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear called")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear called")
    }
    
    private func setupViews(){
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileInputView.translatesAutoresizingMaskIntoConstraints = false
        
        profileView.backgroundColor = UIColor(red: 0.97, green: 0.84, blue: 0.10, alpha: 1.0)
        profileView.layer.cornerRadius = 20.0
        
        profileView.configure(withTitle: "Arseniy Rubtsov", description: "Junior IOS Developer")
        profileInputView.delegate = profileView
        
        view.addSubview(profileView)
        view.addSubview(profileInputView)
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: profileView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            profileView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            profileView.widthAnchor.constraint(equalToConstant: 350),
            profileView.heightAnchor.constraint(equalToConstant: 150),
            
            profileInputView.topAnchor.constraint(equalToSystemSpacingBelow: profileView.bottomAnchor, multiplier: 1.0),
            NSLayoutConstraint(item: profileInputView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])
    }
}

