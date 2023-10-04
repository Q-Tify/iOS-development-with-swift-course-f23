import UIKit


protocol ProfileInputDelegate: AnyObject{
    func configure(withTitle title: String, description: String)
}

class ProfileView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ProfileImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelsContainerStackView = UIStackView()
        labelsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerStackView.axis = .vertical
        labelsContainerStackView.distribution = .fillEqually
        labelsContainerStackView.spacing = 15
        
        labelsContainerStackView.addArrangedSubview(titleLabel)
        labelsContainerStackView.addArrangedSubview(descriptionLabel)
        
        addSubview(profileImageView)
        addSubview(labelsContainerStackView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            NSLayoutConstraint(item: labelsContainerStackView, attribute: .centerY, relatedBy: .equal, toItem: profileImageView, attribute: .centerY, multiplier: 1, constant: 0),
            labelsContainerStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200),
            NSLayoutConstraint(item: descriptionLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200),
            NSLayoutConstraint(item: labelsContainerStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50),
        ])
        
       
    }
    
    required init?(coder: NSCoder){
        fatalError("Error")
    }
}

extension ProfileView: ProfileInputDelegate{
    func configure(withTitle title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
