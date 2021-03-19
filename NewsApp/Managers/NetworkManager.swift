//
//  NetworkManager.swift
//  NewsApp
//
//  Created by finebel on 10.08.20.
//

import UIKit

enum NewsError: String, Error {
    case universalError = "Es ist ein unbekannter Fehler aufgetreten."
    case unableToComplete = "Der Request konnte nicht abgeschlossen werden. Bitte überprüfe ggf. deine Internetverbindung."
    case invalidResponse = "Ungültige Serverantwort. Versuche es später erneut."
    case invalidData = "Ungültige Daten erhalten. Versuche es später erneut."
    case invalidURL = "Es wurde eine ungültige URL verwendet."
}

///Provides methods for donwloading articles and images
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURLString = "https://newsapi.org/v2/top-headlines?country=de&category=general"
    #warning("You need to paste your own API-Key here")
    private let apiKey = "xxxxxxxx"//<- Paste your API-Key here
    
    func getArticles(pageSize: Int = 30, completion: @escaping ((Result<NewsResponse, NewsError>) -> Void)) {
        let endpoint = baseURLString + "&pageSize=\(pageSize)&apiKey=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                completion(.success(newsResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    private let cache = NSCache<NSString, UIImage>()
    
    ///Based on the `urlString` this method downloads and caches an image.
    func downloadImage(from urlString: String?, completed: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString ?? "") else {
            completed(#imageLiteral(resourceName: "placeholder"))
            return
        }
        
        let cacheKey = NSString(string: url.absoluteString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                
                completed(#imageLiteral(resourceName: "placeholder"))//placeholderImage
                return
            }
            
            completed(image)
            self.cache.setObject(image, forKey: cacheKey)
        }
        
        task.resume()
    }
}
