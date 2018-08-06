//
//  ViewController.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 15/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import UIKit

enum NumberOfCells{
    case two
    
    case four
    
    func number()->Int{
        switch self {
        case .two: return 2
        
        case .four : return 4
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var customNavigationBarTitle: UILabel!
    var numberOfCells = NumberOfCells.two
    
    var array:[Movie] = []
    
    let minimumLineSpacing:CGFloat = 10
    
    let minimumInteritemSpacing:CGFloat = 10
    
    let reuseIdentifier = "MovieImageCell"
    
    var searchBarText = ""
    
    var pagingInfo = PagingInfo(currentPage    : 1,
                                totalPages     : 0)
    
    var footerView:CustomFooterView?
    
    let footerViewReuseIdentifier = "RefreshFooterView"
    
    var isLoading:Bool = false
    
    var activeMode:Mode = .discover
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
        self.displayDiscover()
    }
    
    @IBAction func showActionSheet(_ sender: Any) { self.showActionSheetForSorting() }
    
    @IBAction func settingAction(_ sender: Any) {
        self.showActionSheet()
    }
}

extension ViewController{
    
     func performSearch(mode: Mode,page:Int = 1) {
        
        MovieProvider.fetchMovies(page:page,mode:mode){ (error: NSError?, movies: [Movie]?,pagingInfo:PagingInfo?) -> Void in
            
        if let arr = movies{
            self.isLoading = false
            self.array.append(contentsOf:arr)
            
            if let pageInfo = pagingInfo{
                self.pagingInfo = pageInfo
            }
            
        }
        else if let error = error{

        if (error.code == MovieProvider.Errors.invalidAccessErrorCode) {
            DispatchQueue.main.async{ () -> Void in
                self.showErrorAlert()
          }
         }
        }
        
        DispatchQueue.main.async { () -> Void in
            self.customNavigationBarTitle.text = mode.description
            self.collectionView.reloadData()
         }
        }
    }
    
    func set(numberOfCells:NumberOfCells){
        self.numberOfCells = numberOfCells
        self.collectionView.reloadData()
    }
    
    func showActionSheet(){
        
        let alert = UIAlertController(title: "Choose number of images", message: "Per Row", preferredStyle: .actionSheet)
        
        let displayTwoImagesPerRowAlertAction = UIAlertAction(title: "two", style: .default) { [unowned self] (action) in
            self.set(numberOfCells: .two)
        }
        
        let displayFourImagesPerRowAlertAction = UIAlertAction(title: "four", style: .default) { [unowned self] (action) in
            self.set(numberOfCells: .four)
        }
        
        let cancelAlertAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addAction(displayTwoImagesPerRowAlertAction)
        
        alert.addAction(displayFourImagesPerRowAlertAction)
        
        alert.addAction(cancelAlertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayMostPopularSorted(){
        self.activeMode = .mostPopularDescending
        self.commonConfiguration()
    }
    
    func displayHighestRatingSorted(){
        self.activeMode = .highestRatingDescending
        self.self.commonConfiguration()
    }
    
    func displayDiscover(){
        self.activeMode = .discover
        self.commonConfiguration()
    }
    
    func commonConfiguration(){
        self.customNavigationBarTitle.text = self.activeMode.description
        self.refresh()
        self.performSearch(mode: self.activeMode, page: self.pagingInfo.currentPage)
    }
    
    func showActionSheetForSorting(){
        
        let alert = UIAlertController(title: "Sort", message: "Movies", preferredStyle: .actionSheet)
        
        let popularAlertAction = UIAlertAction(title: "Most Popular", style: .default) { [unowned self] (action) in
            
            self.displayMostPopularSorted()

        }
        
        let ratingAlertAction = UIAlertAction(title: "Highest Rating", style: .default) { [unowned self] (action) in
            
            self.displayHighestRatingSorted()
        }
        
        let discoverAlertAction = UIAlertAction(title: "Discover", style: .default) { [unowned self] (action) in
            
            self.displayDiscover()
        }
        
        let cancelAlertAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addAction(popularAlertAction)
        
        alert.addAction(ratingAlertAction)
        
        alert.addAction(discoverAlertAction)
        
        alert.addAction(cancelAlertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetPageIndex(){
        self.pagingInfo = PagingInfo(currentPage: 1, totalPages: 0)
    }
    
    func refresh(){
        self.array = []
        self.resetPageIndex()
        self.collectionView.reloadData()
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath,
              let destination = segue.destination as? DetailViewController
        
        else { return }
        
        let num = self.numberOfCells.number()
        
        let index = (indexPath.section * num) + indexPath.item
        
        destination.movie = self.array[index]
    }
}

extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.refresh()
        self.activeMode = .queryText(searchBar.text!)
        self.performSearch(mode: self.activeMode)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { self.refresh() }
}
