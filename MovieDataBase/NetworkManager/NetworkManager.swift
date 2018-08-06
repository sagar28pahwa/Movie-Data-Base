//
//  File.swift
//  FlickrImages
//
//  Created by Sagar Pahwa on 15/07/18.
//  Copyright © 2018 Sagar Pahwa. All rights reserved.
//

import Foundation

class MovieProvider:NSObject {
    
    typealias MovieResponse = (NSError?, [Movie]?,PagingInfo?) -> Void
    
    struct Keys {
        static let TMDBKey = "c90cc7656037d3f247d3c5fd29fb8090"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchMovies(page:Int,mode:Mode = .mostPopularDescending, onCompletion: @escaping MovieResponse) -> Void {
        
        guard let url = mode.url(page: page)
        
        else { return }
        
        let searchTask = URLSession.shared.dataTask(with: url as URL) {data, response, error -> Void in
            
            if error != nil {
                print("Error fetching photos: \(error)")
                onCompletion(error as NSError?, nil,nil)
                return
            }
            
            do {
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                else { return }
                
                if let statusCode = resultsDictionary["code"] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                        onCompletion(invalidAccessError, nil,nil)
                        return
                    }
                }
                
                guard let totalPages     = resultsDictionary["total_pages"] as? Int,
                      let page           = resultsDictionary["page"]        as? Int,
                      let movieArray     = resultsDictionary["results"]     as? [NSDictionary]
                
                else { return }
                
                let movies: [Movie] =
                    
                    movieArray.map { movieDictionary in

                    let posterPath      = movieDictionary["poster_path"]  as? String ?? ""
                    let vote_average    = movieDictionary["vote_average"] as? Float ?? 0
                    let title           = movieDictionary["title"]        as? String ?? ""
                    let overview        = movieDictionary["overview"]     as? String ?? ""
                    let releaseDate     = movieDictionary["release_date"] as? String ?? ""
                    let movieId         = movieDictionary["id"]           as? Int ?? 0

                    let movie = Movie(posterPath  : posterPath  ,
                                      title       : title       ,
                                      user_Rating : vote_average,
                                      overView    : overview    ,
                                      releaseDate : releaseDate ,
                                      id          : movieId     )
                    return movie
                }
                
                
                let pagingInfo = PagingInfo(currentPage    : page          ,
                                            totalPages     : totalPages    )
                    
                    
                onCompletion(nil, movies,pagingInfo)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil,nil)
                return
            }
        }
        
        searchTask.resume()
    }
}
