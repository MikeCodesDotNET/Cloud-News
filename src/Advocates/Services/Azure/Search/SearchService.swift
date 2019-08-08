//
//  SearchService.swift
//  Advocates
//
//  Created by Michael James on 19/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class SearchService {
    
    private var pref: UserDefaults!
    private let baseUrl: String
    private let apiVersion = "2019-05-06"
    
    
    init(indexName: String) {
        
        pref = UserDefaults.standard
        self.baseUrl = "https://" + Constants.AzureSearch.serviceName + ".search.windows.net/indexes/" + indexName
    }
    
    
    // MARK: - Azure Search HTTP API
    
    func suggest(query: String, completion: @escaping ([SearchResult]) -> Void) {
    
        //Azure Searchrequest URL length cannot exceed 8 KB so its safer to query using a POST request to put our query in the body.
        let suggestionRequest = SuggestionRequest.init(fuzzy: true, minimumCoverage: 100, search: query, searchFields: "title", select: "title, description, url, source, id", suggesterName: "name")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedRequest = try! encoder.encode(suggestionRequest)
    
        //Create query URL b
        let url = URL(string: "\(baseUrl)/docs/suggest?api-version=\(apiVersion)")!
    
        //Create URL Request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.AzureSearch.apiKey, forHTTPHeaderField: "api-key")
        request.httpMethod = "POST"
        request.httpBody = encodedRequest
        
        //Make request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
            }
            
            // check for http errors
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            //Convert the response data into a concrete type & pass back to completion handler
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(SearchResultWrapper.self, from: data)
                completion(result.results)
                
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
        }
        task.resume()
    
    }
    
    func search(query: String, completion: @escaping ([SearchResult]) -> Void) {
       
        //Azure Searchrequest URL length cannot exceed 8 KB so its safer to query using a POST request to put our query in the body.
        let searchRequest = SearchRequest.init(count: true, minimumCoverage: 100, searchTerm: query, searchFields: "title")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedRequest = try! encoder.encode(searchRequest)
        
        //Create query URL b
        let url = URL(string: "\(baseUrl)/docs/search?api-version=\(apiVersion)")!
        
        //Create URL Request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.AzureSearch.apiKey, forHTTPHeaderField: "api-key")
        request.httpMethod = "POST"
        request.httpBody = encodedRequest
        
        //Make request 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
            }
            
            // check for http errors
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            //Convert the response data into a concrete type & pass back to completion handler
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(SearchResultWrapper.self, from: data)
                completion(result.results)
                
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
        }
        task.resume()
    }
    
    
    
    // MARK: - Search History
    
    func setSearchHistories(value: [String]) {
        pref.set(value, forKey: "histories")
    }
    
    func deleteSearchHistories(index: Int) {
        guard var histories = pref.object(forKey: "histories") as? [String] else { return }
        histories.remove(at: index)
        
        pref.set(histories, forKey: "histories")
    }
    
    func appendSearchHistories(value: String) {
        var histories = [String]()
        if let _histories = pref.object(forKey: "histories") as? [String] {
            histories = _histories
        }
        histories.append(value)
        pref.set(histories, forKey: "histories")
    }
    
    func getSearchHistories() -> [String]? {
        guard let histories = pref.object(forKey: "histories") as? [String] else { return nil }
        return histories
    }
    
}


// MARK: - Search Response Models

class SearchResultWrapper : Codable {
    
    let odataContext: String
    let odataCount: Int?
    let searchCoverage: Int
    let results: [SearchResult]
    
    init(odataContext: String, odataCount: Int, searchCoverage: Int, results: [SearchResult]) {
        self.odataContext = odataContext
        self.odataCount = odataCount
        self.searchCoverage = searchCoverage
        self.results = results
    }
    
    enum CodingKeys: String, CodingKey {
        case odataContext = "@odata.context"
        case odataCount = "@odata.count"
        case searchCoverage = "@search.coverage"
        case results = "value"
    }
}


class SearchResult : Codable {
    
    let searchScore: Double?
    let searchText: String?
    let id: String
    let title: String
    let valueDescription: String
    let source: String
    let url: String
    
    init(searchScore: Double, searchText: String, id: String, title: String, valueDescription: String, source: String, url: String) {
        self.searchScore = searchScore
        self.searchText = searchText
        self.id = id
        self.title = title
        self.valueDescription = valueDescription
        self.source = source
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case searchScore = "@search.score"
        case searchText = "@search.text"
        case id = "id"
        case title = "title"
        case valueDescription = "description"
        case source = "source"
        case url = "url"
    }
    
}

class SearchRequest : Codable {
    
    let count: Bool
    let highlightPreTag: String
    let highlightPostTag: String
    let minimumCoverage: Int
    let search: String
    let searchFields: String
    let searchMode: String
    
    init(count: Bool, minimumCoverage: Int, searchTerm: String, searchFields: String) {
        self.count = count
        self.highlightPreTag = "["
        self.highlightPostTag = "]"
        self.minimumCoverage = minimumCoverage
        self.search = searchTerm
        self.searchFields = searchFields
        self.searchMode = "all"
    }
}

class SuggestionRequest : Codable {
    
    let fuzzy: Bool
    let highlightPreTag: String
    let highlightPostTag: String
    let minimumCoverage: Int
    let search: String
    let searchFields: String
    let select: String
    let suggesterName: String
    
    init(fuzzy: Bool, minimumCoverage: Int, search: String, searchFields: String, select: String, suggesterName: String) {
        self.fuzzy = fuzzy
        self.highlightPreTag = "["
        self.highlightPostTag = "]"
        self.minimumCoverage = minimumCoverage
        self.search = search
        self.searchFields = searchFields
        self.select = select
        self.suggesterName = suggesterName
    }
    
}
