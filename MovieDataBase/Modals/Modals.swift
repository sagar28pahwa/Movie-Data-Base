//
//  Modals.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 31/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import Foundation

struct PagingInfo{
    
    var currentPage:Int
    
    var totalPages:Int
    
    func canPage()->Bool{
        return (self.totalPages - self.currentPage) >= 1
    }
}

struct Movie {
    
    enum SizesAvail:String{
        case w92       = "w92"
        case w154      = "w154"
        case w185      = "w185"
        case w342      = "w342"
        case w500      = "w500"
        case w780      = "w780"
        case wOriginal = "original"
    }
    
    var posterPath: String
    var title: String
    var user_Rating: Float
    var overView: String
    var releaseDate : String
    
    func rating()->Float{
        return self.user_Rating
    }
    
    var id : Int
    
    
    
    func imageUrl(size:SizesAvail = .w342)->URL?{
        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(self.posterPath)")
    }
}

enum Mode{
    case mostPopularDescending
    case highestRatingDescending
    case discover
    
    case queryText(String)
    
    func sortby()->String{
        switch self {
        case .mostPopularDescending   : return "popularity.desc"
            
        case .highestRatingDescending : return "vote_average.desc"
            
        case .discover                : return "popularity.desc"
            
        case .queryText(_)            : return "popularity.desc"
        }
    }
    
    struct Keys {
        static let TMDBKey = "c90cc7656037d3f247d3c5fd29fb8090"
    }
    
    func url(page:Int)->URL?{
        switch self {
        case .mostPopularDescending   :
            
            let urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(Keys.TMDBKey)&sort_by=\(self.sortby())&page=\(page)"
            
            return URL(string: urlString)
            
        case .highestRatingDescending :
            
            let urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(Keys.TMDBKey)&sort_by=\(self.sortby())&page=\(page)"
            
            return URL(string: urlString)
            
        case .discover :
            
            let urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(Keys.TMDBKey)&sort_by=\(self.sortby())&page=\(page)"
            
            return URL(string: urlString)
            
        case .queryText(let searchText) :
            
            let urlString = "http://api.themoviedb.org/3/search/movie?api_key=\(Keys.TMDBKey)&query=\(searchText)&page=\(page)"
            
            return URL(string: urlString)
        }
    }
}


extension Mode:CustomStringConvertible{
    
    var description: String {
        
        switch self {
            
        case .discover                : return "Discover"
            
        case .highestRatingDescending : return "Highest Rating"
            
        case .mostPopularDescending   : return "Most Popular"
            
        case .queryText(let text)     : return "Searches for \(text)"
        }
    }
    
    
}
