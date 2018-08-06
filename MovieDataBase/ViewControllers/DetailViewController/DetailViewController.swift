//
//  DetailViewController.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 16/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie:Movie!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var userRating: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var overViewDelegate: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.showDetails(movie: self.movie)
    }
    
    func showDetails(movie:Movie){
        self.imageView.sd_setImage(with: movie.imageUrl())
        self.movieTitle.text = movie.title
        
        self.userRating.text = "Rating: \(movie.rating())"
        
        self.releaseDate.text = "Release Date\(movie.releaseDate)"
        
        self.overViewDelegate.text = movie.overView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
