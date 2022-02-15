//
//  DetailInfoViewController.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 30.01.22.
//

import UIKit
import Kingfisher

final class DetailInfoViewController: UIViewController {
    // MARK: - Nested Types
    private enum Constants {
        static let buttonWidth: CGFloat = 60
        static let buttonHeight: CGFloat = 40
        static let buttonTextSize: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 7
        static let futterSpacing: CGFloat = 20
        static let futterStackViewSize: CGFloat = -30
        static let imageNameTextSize: CGFloat = 18
        static let photographerTextSize: CGFloat = 15
    }
    
    // MARK: - Properties
    var presenter: DetailInfoPresenterProtocol?
    
    // MARK: - UI Properties
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: Constants.imageNameTextSize, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let photographerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: Constants.photographerTextSize, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonTextSize, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(sharePressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonTextSize, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageNameLabel, photographerLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [saveButton, photographerLabel, shareButton])
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var futterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageNameLabel, buttonStackView])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constants.futterSpacing
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.presentDetailInfo()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .white
        
        setupSubviews()
        setLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(selectedImageView)
        view.addSubview(futterStackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            selectedImageView.bottomAnchor.constraint(
                equalTo: futterStackView.safeAreaLayoutGuide.topAnchor,
                constant: Constants.futterStackViewSize
            ),
            shareButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            shareButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            saveButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            
            futterStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            futterStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            futterStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setPhoto(with url: URL) {
        let processor = DownsamplingImageProcessor(size: selectedImageView.bounds.size)
        selectedImageView.kf.indicatorType = .activity
        selectedImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.futterStackView.isHidden = false
            case .failure:
                self.displayError()
            }
        }
    }
    
    //MARK: - Actions
    @objc func sharePressed() {
        presenter?.shareDetailInfo()
    }
    
    @objc func savePressed() {
        presenter?.savePhoto()
    }
}

// MARK: - DetailViewProtocol
extension DetailInfoViewController: DetailInfoViewProtocol {
    func displayDetailInfo(viewModel: DetailInfoViewModel) {
        imageNameLabel.text = viewModel.imageName
        photographerLabel.text = viewModel.photographer
        setPhoto(with: viewModel.url)
    }
    
    func displayActivityController(items: [String]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    func displayError(){
        AlertService.shared.showAlert(viewController: self, type: .error) { [weak self] in
            guard let self = self else { return }
            self.presenter?.presentDetailInfo()
        }
    }
    
    func displaySuccessMessage() {
        AlertService.shared.showAlert(viewController: self, type: .success)
    }
}

