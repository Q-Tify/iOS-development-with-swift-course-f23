import SnapKit
import UIKit

class FeelingDetailsViewController: UIViewController {
    var feeling: Photo?
    var feelingIndex: Int?
    weak var mainViewControllerDelegate: MainViewControllerDelegate?
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private let feelingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let choosePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.setTitle("Choose Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        updateUI()
    }
    
    @objc
    func editButtonTapped() {
        descriptionTextView.isEditable = true
        choosePhotoButton.isHidden = false
        
        navigationItem.rightBarButtonItem?.title = "Done"
        navigationItem.rightBarButtonItem?.action = #selector(doneButtonTapped)
    }
    
    @objc
    func doneButtonTapped() {
        descriptionTextView.isEditable = false
        choosePhotoButton.isHidden = true
        
        guard let delegate = mainViewControllerDelegate else {
            print("There is no delegate")
            return
        }
        
        guard let index = feelingIndex else {
            print("There is no index")
            return
        }
        
        guard let newText = descriptionTextView.text else {
            print("There is no text")
            return
        }
        
        var newSource = delegate.loadPhotos()
        
        newSource[index].description = newText
        
        delegate.updateSource(with: newSource)
        delegate.savePhotos(newSource: newSource)
        
        navigationItem.rightBarButtonItem?.title = "Edit"
        navigationItem.rightBarButtonItem?.action = #selector(editButtonTapped)
    }
    
    private func setupUI() {
        view.addSubview(feelingImageView)
        view.addSubview(descriptionTextView)
        view.addSubview(choosePhotoButton)
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain,
                                         target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
        
        choosePhotoButton.addTarget(self, action: #selector(imageViewTapped), for: .touchUpInside)
        
        feelingImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(200)
        }

        choosePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(200)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(feelingImageView.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.snp.bottom).offset(0)
        }
//        NSLayoutConstraint.activate([
//            feelingImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            feelingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            feelingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            feelingImageView.heightAnchor.constraint(equalToConstant: 200),
//
//            choosePhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            choosePhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            choosePhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            choosePhotoButton.heightAnchor.constraint(equalToConstant: 200),
//
//            descriptionTextView.topAnchor.constraint(equalTo: feelingImageView.bottomAnchor, constant: 10),
//            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        ])
    }
    
    private func updateUI() {
        if let feeling = feeling {
            descriptionTextView.text = "\(feeling.description)"
            
            if feeling.imageName == "plus"{
                feelingImageView.image = UIImage(named: feeling.imageName)
            } else {
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                     in: .userDomainMask).first {
                    let fileURL = documentsDirectory.appendingPathComponent(feeling.imageName)
                    feelingImageView.image = UIImage(contentsOfFile: fileURL.path)
                }
            }
        }
    }
}

extension FeelingDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc
    func imageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageData = pickedImage.pngData(),
           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let randomNumber = arc4random_uniform(1_000_001)
            let fileURL = documentsDirectory.appendingPathComponent("selectedImage\(Int(randomNumber)).png")
            try? imageData.write(to: fileURL)

            guard let delegate = mainViewControllerDelegate else {
                print("There is no delegate")
                return
            }
            
            guard let index = feelingIndex else {
                print("There is no index")
                return
            }
            
            var newSource = delegate.loadPhotos()
            
            newSource[index].imageName = "selectedImage\(Int(randomNumber)).png"
            
            delegate.updateSource(with: newSource)
            delegate.savePhotos(newSource: newSource)

            feelingImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
