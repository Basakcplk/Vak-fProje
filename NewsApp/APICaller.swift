//
//  APICaller.swift
//  NewsApp
//
//  Created by Apple on 26.08.2024.
//

import Foundation

final class APICaller {         //Haber API'sine çağrı yapmak için kullanılan sınıf
    static let shared = APICaller()
    
    struct Constants {              //Sabit değerleri (örneğin API URL'si) depolar
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=4a6db2f300924611b71ec8f7bb80d145")
    }
    
    private init() {}
                                         
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void ) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in   //API'ye HTTP isteği gönderir
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

// Model oluşturma

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let author: String?
    
}
struct Source: Codable {
    let name: String?
 //   let id: JSONNull?
}

/*class JSONNull: Codable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

}*/
