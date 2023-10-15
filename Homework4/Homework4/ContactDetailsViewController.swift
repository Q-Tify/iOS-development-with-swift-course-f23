import UIKit

class ContactDetailsViewController: UIViewController {
    var contact: Contact?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.centerX(to: view, offset: 0),
            nameLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            
            emailLabel.centerX(to: view, offset: 0),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            phoneLabel.centerX(to: view, offset: 0),
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
        ])
        
        // Add the UIImageView to the UIScrollView
        scrollView.addSubview(contactImageView)
        
        // Set the delegate of the UIScrollView to enable zooming
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        
        NSLayoutConstraint.activate([
            contactImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contactImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contactImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contactImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contactImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contactImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func updateUI() {
        if let contact = contact {
            nameLabel.text = "\(contact.name)"
            emailLabel.text = "\(contact.email)"
            phoneLabel.text = "\(contact.phone)"
            
            contactImageView.image = UIImage(named: contact.image)
        }
    }
}

// Implemented UIScrollViewDelegate to enable zooming
extension ContactDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contactImageView
    }
}
