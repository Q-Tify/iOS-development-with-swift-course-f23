import UIKit

class ProfileInputView: UIStackView {
    
    //Delegate to call the function configure from the ProfileView class
    weak var delegate: ProfileInputDelegate?
    
    let profileTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter profile title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let profileDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter profile description"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let changeProfileInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.spacing = 16
        self.alignment = .fill
        
        addArrangedSubview(profileTitleTextField)
        addArrangedSubview(profileDescriptionTextField)
        addArrangedSubview(changeProfileInfoButton)
        
        NSLayoutConstraint.activate([
        NSLayoutConstraint(item: profileTitleTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 250),
        NSLayoutConstraint(item: profileDescriptionTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 250)])
        
        changeProfileInfoButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonDidTapped(){
        self.delegate?.configure(
            withTitle: profileTitleTextField.text ?? "Optional is nil",
            description: profileDescriptionTextField.text ?? "Optional is nil")
        profileTitleTextField.text = ""
        profileDescriptionTextField.text = ""
        
    }
}
