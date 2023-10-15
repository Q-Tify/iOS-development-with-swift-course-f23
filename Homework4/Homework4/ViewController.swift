import UIKit

class ViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Contact>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Contact>
    
    private var collectionView: UICollectionView! = nil
    
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Contacts"
        
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        createMockData()
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let contact = dataSource.itemIdentifier(for: indexPath) {
            let contactDetailsVC = ContactDetailsViewController()
            contactDetailsVC.contact = contact
            navigationController?.pushViewController(contactDetailsVC, animated: true)
        }
    }
}


extension ViewController{
    
    enum Section {
        case main
    }
    
    private func createLayout ( ) -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize (widthDimension: .fractionalWidth (1.0), heightDimension: .fractionalHeight (1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0)

        let groupSize = NSCollectionLayoutSize (widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(61))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout (section: section)
        return layout

    }
    
    private func configureCollectionViewLayout () {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(ContactCell.self, forCellWithReuseIdentifier: ContactCell.reuseIdentifier)
        
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: {(collectionView, indexPath, contact) -> ContactCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCell.reuseIdentifier, for: indexPath) as! ContactCell
            cell.configure(with: contact)
            return cell
        })
    }
    
    private func generateRandomPhoneNumber() -> String {
        let format = "+7(XXX)XXX-XX-XX"
        var phoneNumber = ""
        for char in format {
            if char == "X" {
                let randomDigit = String(Int(arc4random_uniform(10)))
                phoneNumber.append(randomDigit)
            } else {
                phoneNumber.append(char)
            }
        }
        return phoneNumber
    }
    
    private func generateRandomName() -> String {
        let firstNames = ["John", "Jane", "Michael", "Emily", "David", "Sarah", "Robert", "Mary", "William", "Emma"]
        let lastNames = ["Smith", "Johnson", "Brown", "Davis", "Wilson", "Taylor", "Clark", "Miller", "Anderson", "Moore"]
        
        let randomFirstName = firstNames.randomElement() ?? "John"
        let randomLastName = lastNames.randomElement() ?? "Smith"
        
        return "\(randomFirstName) \(randomLastName)"
    }
    
    
    private func createMockData() {
        var mockContacts: [Contact] = []
        
        for i in 0..<40 {
            mockContacts.append(
                Contact(id: i,
                        name: generateRandomName(),
                        email: "example\(i)@gmail.com",
                        phone: generateRandomPhoneNumber(),
                        image: "256_\(i % 16)"))
        }
        
        applySnapshot(contacts: mockContacts)
    }
    
    private func applySnapshot (contacts: [Contact]) {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(contacts)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
