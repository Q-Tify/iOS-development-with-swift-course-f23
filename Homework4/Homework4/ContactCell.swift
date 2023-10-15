import UIKit
import TinyConstraints

class ContactCell : UICollectionViewCell, SelfConfuguringCell {
    static let reuseIdentifier: String = "ContactCell"
    
    override init (frame: CGRect) {
        super.init (frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder) has not been implemented")
    }
    
    lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    //Decided to try some pods here
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 0
        clipsToBounds = true
        
        addSubview(contactImageView)
        addSubview(nameLabel)
        
        contactImageView.edgesToSuperview(excluding: .trailing, insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right:
        8))
        contactImageView.size(CGSize(width: 44, height: 44))
        
        nameLabel.leadingToTrailing(of: contactImageView, offset: 8)
        nameLabel.trailingToSuperview(offset: 8)
        nameLabel.centerY(to: contactImageView, offset: 0)
    }
    
    func configure(with contact: Contact) {
        self.contactImageView.image = UIImage(named: contact.image)
        nameLabel.text = contact.name
    }
}
