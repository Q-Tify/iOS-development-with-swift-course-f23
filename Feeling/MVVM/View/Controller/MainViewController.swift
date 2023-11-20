import SnapKit
import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func updateSource(with newSource: [Photo])
    func loadPhotos() -> [Photo]
    func savePhotos(newSource: [Photo])
}

class MainViewController: UIViewController, MainViewControllerDelegate {
    var feelingsCollectionView: UICollectionView!
    
    var source: [Photo] = []
    var deleteItem = false
    var photoViewModel = PhotoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feelings"
        view.backgroundColor = .secondarySystemBackground
        
        source = loadPhotos()
        setupUI()
        setupCollectionView()
    }
    
    func setupUI() {
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain,
                                           target: self, action: #selector(deleteButtonTapped))
        navigationItem.leftBarButtonItem = deleteButton
    }
    
    func savePhotos(newSource: [Photo]) {
        photoViewModel.savePhotosToUserDefaults(photos: source)
    }

    func loadPhotos() -> [Photo] {
        return photoViewModel.getPhotosFromUserDefaults()
    }
    
    func updateSource(with newSource: [Photo]) {
        source = newSource
    }
    
    @objc
    func addButtonTapped() {
        var date: String
        date = ""
        getCurrentDateTimeFromAPI { dateTime in
            if let dateTime = dateTime {
                date = dateTime
                print("Current Date and Time from API: \(dateTime)")
            } else {
                print("Failed to fetch current date and time from API")
            }
        }
        
        source.append(Photo(id: source.count, imageName: "plus",
                            description: "Add your description of the feeling...", creation_date: date))
        
        savePhotos(newSource: source)
        
        feelingsCollectionView.reloadData()
    }
    
    @objc
    func deleteButtonTapped() {
        deleteItem = true
        navigationItem.leftBarButtonItem?.title = "Done"
        navigationItem.leftBarButtonItem?.action = #selector(doneButtonTapped)
    }
    
    @objc
    func doneButtonTapped() {
        deleteItem = false
        savePhotos(newSource: source)
        
        navigationItem.leftBarButtonItem?.title = "Delete"
        navigationItem.leftBarButtonItem?.action = #selector(deleteButtonTapped)
    }
    
    func setupCollectionView() {
        feelingsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        
        view.addSubview(feelingsCollectionView)
        feelingsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        feelingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
//        NSLayoutConstraint.activate([
//            feelingsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            feelingsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            feelingsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            feelingsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])
        
        feelingsCollectionView.dataSource = self
        feelingsCollectionView.delegate = self
        feelingsCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "\(PhotoCell.self)")
    }

    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = .init(width: 64, height: 64)
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        layout.sectionInset = .init(top: 20, left: 30, bottom: 20, right: 30)
        return layout
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = feelingsCollectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotoCell.self)",
                                                                    for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        if source[indexPath.item].imageName == "plus"{
            cell.imageView.image = UIImage(named: source[indexPath.item].imageName)
        } else {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent(source[indexPath.item].imageName)
                cell.imageView.image = UIImage(contentsOfFile: fileURL.path)
            }
        }
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if deleteItem {
            source.remove(at: indexPath.item)
            feelingsCollectionView.deleteItems(at: [indexPath])
        } else {
            let feeling = source[indexPath.item]
            let feelingDetailsVC = FeelingDetailsViewController()
            feelingDetailsVC.feelingIndex = indexPath.item
            feelingDetailsVC.feeling = feeling
            feelingDetailsVC.mainViewControllerDelegate = self
            navigationController?.pushViewController(feelingDetailsVC, animated: true)
        }
    }
}
