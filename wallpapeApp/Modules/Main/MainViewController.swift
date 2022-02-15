//
//  ViewController.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 28.01.22.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Nested Types
    private enum Constants {
        static let minimumSpacing: CGFloat = 40
        static let numberOfItemsInSection: Int = 16
    }
    
    // MARK: - Properties
    var presenter: MainPresenterProtocol?
    
    private var nextPage: Int = 1
    private var isSearching: Bool = false
   
    private var photos: [Photo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.showsSearchResultsController = true
        searchController.automaticallyShowsScopeBar = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter Name Or Symbole"
        return searchController
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let bonusWidth: CGFloat = UIScreen.main.bounds.width
        let size: CGFloat = (bonusWidth - Constants.minimumSpacing) / 2
        let cellSize = CGSize(width: size, height: size)
        let sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = cellSize
        layout.sectionInset = sectionInset
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(MainCVCell.self, forCellWithReuseIdentifier: MainCVCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
        
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        startSettings()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        navigationItem.searchController = searchController
        
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func startSettings() {
        presenter?.fetchData(page: nextPage)
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func displayPhotos(model: [Photo]) {
        if (photos?.append(contentsOf: model)) == nil {
            photos = model
        }
    }
    
    func updateNextPage(page: Int) {
        nextPage = page
    }
    
    func displayError() {
        AlertService.shared.showAlert(viewController: self, type: .error) { [weak self] in
            guard let self = self else { return }
            self.presenter?.fetchData(page: self.nextPage)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = photos?.count else { return Constants.numberOfItemsInSection }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCVCell.identifier, for: indexPath) as! MainCVCell
        if let photos = photos {
            cell.configureCell(url: photos[indexPath.row].mediumSrcUrl)
        } 
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if  offsetY > contentHeight - scrollView.frame.height {
            if isSearching {
                presenter?.fetchSearchData(page: nextPage, text: searchController.searchBar.text)
            } else {
                presenter?.fetchData(page: nextPage)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = photos else { return }
        presenter?.tapOnThePhoto(model: photos[indexPath.row])
    }
}

// MARK: - UISearchResultsUpdating & UISearchControllerDelegate
extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.isEmpty {
            isSearching = false
            photos = []
            nextPage = 1
            presenter?.fetchData(page: nextPage)
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        photos = []
        presenter?.fetchSearchData(page: nextPage, text: searchController.searchBar.text)
        isSearching = true
        return true
    }
}
