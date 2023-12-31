//
//  MovieAPI.swift
//  Unroll
//
//  Created by Gabriel Garcia on 07/09/23.
//

import UIKit

final class MovieApi {
    
    // MARK: - Singleton
    
    static let shared = MovieApi()
    
    // MARK: - Private Properties
    
    private let baseUrl = URL(string: "https://api.themoviedb.org/3")!
    private let headers = [
        "accept": "application/json",
        "Authorization": MovieApiKey.value
    ]
    
    private var watchRegion: Location?
    
    // MARK: - Fetch Methods
    
    /// Gets all the enable movie genres on API
    /// - Parameter completion: returns an array of genre
    func getMovieGenreList(completion: @escaping ([Genre]?) -> ()) {
        
        var url = baseUrl.appending(component: "genre/movie/list")
        let queryItems = [
            URLQueryItem(name: "language", value: getLanguage().query),
        ]
        url.append(queryItems: queryItems)
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let movieGenres = try? decoder.decode(Genres.self, from: data) else {
                return
            }
            
            completion(movieGenres.genres)
        })
        
        dataTask.resume()
    }
    
    /// Gets all the enable watch providers on API
    /// - Parameter completion: returns an array of watch provider
    func getWatchProviderList(completion: @escaping ([WatchProvider]?) -> ()) {
        
        var url = baseUrl.appending(component: "watch/providers/movie")
        let queryItems = [
            URLQueryItem(name: "language", value: getLanguage().query),
            URLQueryItem(name: "watch_region", value: getWatchRegion().query),
        ]
        url.append(queryItems: queryItems)
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let watchProviders = try? decoder.decode(WatchProviders.self, from: data) else {
                return
            }
            
            completion(watchProviders.results)
        })
        
        dataTask.resume()
    }
    
    func getWatchProvidersResponse(for movie: Movie, completion: @escaping (WatchProvidersResponse?) -> ()) {
        
        guard let movieId = movie.id else {
            return
        }
        
        let url = baseUrl.appending(component: "movie/\(movieId)/watch/providers")
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard let data = data else {
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let watchProviders = try? decoder.decode(WatchProvidersResponse.self, from: data) else {
                return
            }
            
            completion(watchProviders)
        })

        dataTask.resume()
    }
    
    /// Gets a list of movies using filters selected by the user
    /// - Parameters:
    ///   - filters: options selected by user to get a list of movies with a specific description
    ///   - completion: returns a movies object that has an array of movie and their current page
    func getMovieDiscoverList(filter: Filter, completion: @escaping (Movies?) -> ()) {
        
        var url = baseUrl.appending(component: "discover/movie")
        let queryItems = [
            URLQueryItem(name: "include_adult", value: filter.includeAdult),
            URLQueryItem(name: "include_video", value: filter.includeVideo),
            URLQueryItem(name: "language", value: getLanguage().query),
            URLQueryItem(name: "watch_region", value: getWatchRegion().query),
            URLQueryItem(name: "page", value: filter.page),
            URLQueryItem(name: "sort_by", value: filter.sortBy.query),
            URLQueryItem(name: "with_genres", value: filter.getFormattedGenres()),
            URLQueryItem(name: "with_watch_providers", value: filter.getFormattedWatchProviders()),
        ]
        url.append(queryItems: queryItems)
        
        print("url: \(url)")
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard let data = data else {
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            guard let movieDiscoveries = try? decoder.decode(Movies.self, from: data) else {
                return
            }

            completion(movieDiscoveries)
        })

        dataTask.resume()
    }
    
    /// Gets a various parameter number with movie information
    /// - Parameters:
    ///   - movie: the selected movie to get
    ///   - completion: returns a movie object with additional info
    func getMovieDetails(from movie: Movie, completion: @escaping (Movie?) -> ()) {
        
        guard let movieId = movie.id else {
            return
        }
        
        var url = baseUrl.appending(component: "movie/\(movieId)")
        let queryItems = [
            URLQueryItem(name: "language", value: getLanguage().query),
        ]
        url.append(queryItems: queryItems)
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let movieDetails = try? decoder.decode(Movie.self, from: data) else {
                return
            }
            
            completion(movieDetails)
        })
        
        dataTask.resume()
        
    }
    
    // MARK: - Helper Methods
    
    // Watch Region
    
    func getWatchRegion() -> Location {
        guard let watchRegion = self.watchRegion else {
            return .usa
        }
        return watchRegion
    }
    
    func setWatchRegion(to watchRegion: Location) {
        self.watchRegion = watchRegion
    }
    
    // Language
    
    func getLanguage() -> Language {
        guard let languageCode = NSLocale.current.language.languageCode,
              let region = NSLocale.current.language.region else {
            return .english
        }
        
        let language = "\(languageCode.identifier)-\(region.identifier)"
        
        switch Language(rawValue: language) {
        case .english:
            return .english
        case .portuguese:
            return .portuguese
        default:
            return .english
        }
    }
    
    func isOriginalLanguage(_ resultLanguage: String) -> Bool {
        let separator = String("-")
        let globalLanguageArray = getLanguage().query.components(separatedBy: separator)
        let globalLanguage = globalLanguageArray.first
        
        return globalLanguage == resultLanguage
    }
}
