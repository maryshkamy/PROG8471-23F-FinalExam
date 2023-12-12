//
//  UIViewController+CoreData.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import UIKit
import CoreData

extension UIViewController {

    // MARK: - Create a new searh at the model
    func create(searchData: SearchData, completion: @escaping (Bool) -> Void) {
        let newSearch = [
            "city" : searchData.city,
            "source": searchData.source,
            "type": searchData.type
        ]
        self.delete(entity: "Search")
        self.create(entity: "Search", data: newSearch, completion: completion)
    }

    // MARK: - Retrieve the last new search data
    func retrieveNewSearch(completion: (SearchData?) -> Void) {
        self.read(entity: "Search") { response in
            if let response = response, let data = response.last as? NSManagedObject,
                let city = data.value(forKey: "city") as? String,
                let source = data.value(forKey: "source") as? String,
                let type = data.value(forKey: "type") as? String {
                let newSearchData = SearchData(city: city, source: source, type: type)
                completion(newSearchData)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Create a new searh history at the model
    func create(searchHistory: SearchHistoryData, completion: @escaping (Bool) -> Void) {
        var newHistory: [String: Any] = [
            "city" : searchHistory.search.city,
            "source": searchHistory.search.source,
            "type": searchHistory.search.type,
        ]

        if let news = searchHistory.news {
            newHistory["newsAuthor"] = news.author
            newHistory["newsDescription"] = news.description
            newHistory["newsPublishedAt"] = news.publishedAt
            newHistory["newsSource"] = news.source
            newHistory["newsTitle"] = news.title
        }

        if let weather = searchHistory.weather {
            newHistory["weatherCity"] = weather.city
            newHistory["weatherDate"] = weather.date
            newHistory["weatherDescription"] = weather.description
            newHistory["weatherHumidity"] = weather.humidity
            newHistory["weatherIcon"] = weather.icon
            newHistory["weatherTemperature"] = weather.temperature
            newHistory["weatherWind"] = weather.wind
        }

        self.delete(entity: "Search")
        self.create(entity: "SearchHistory", data: newHistory, completion: completion)
    }

    // MARK: - Delete a requested searh history at the model
    func delete(searchHistory: SearchHistoryData, completion: (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let persistentContainer = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        fetchRequest.includesPropertyValues = false

        do {
            let result = try persistentContainer.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "weatherDate") as! Date) == searchHistory.weather?.date {
                    persistentContainer.delete(data)
                }
            }
            try persistentContainer.save()
            completion(true)
        } catch {
            print("LOG: Error to delete all data from New Search Entity")
            completion(false)
        }
    }

    // MARK: - Retrieve all the search history data
    func retrieveSearchHistory(completion: ([SearchHistoryData]) -> Void) {
        self.read(entity: "SearchHistory") { response in
            if let response = response {
                var searchHistory: [SearchHistoryData] = []

                for data in response as! [NSManagedObject] {
                    let searchData = SearchData(
                        city: data.value(forKey: "city") as! String,
                        source: data.value(forKey: "source") as! String,
                        type: data.value(forKey: "type") as! String
                    )

                    var newsData: NewsData?
                    if (data.value(forKey: "newsAuthor") as? String) != nil {
                        newsData = NewsData(
                            author: data.value(forKey: "newsAuthor") as! String,
                            description: data.value(forKey: "newsDescription") as! String,
                            publishedAt: data.value(forKey: "newsPublishedAt") as! String,
                            source: data.value(forKey: "newsSource") as! String,
                            title: data.value(forKey: "newsTitle") as! String
                        )
                    }

                    var weatherData: WeatherData?
                    if (data.value(forKey: "weatherCity") as? String) != nil {
                        weatherData = WeatherData(
                            city: data.value(forKey: "weatherCity") as! String,
                            date: data.value(forKey: "weatherDate") as! Date,
                            description: data.value(forKey: "weatherDescription") as! String,
                            humidity: data.value(forKey: "weatherHumidity") as! Int,
                            icon: data.value(forKey: "weatherIcon") as! String,
                            temperature: data.value(forKey: "weatherTemperature") as! Double,
                            wind: data.value(forKey: "weatherWind") as! Double
                        )
                    }

                    searchHistory.append(SearchHistoryData(search: searchData, news: newsData, weather: weatherData))
                }

                completion(searchHistory)
            } else {
                completion([])
            }
        }
    }

    // MARK: - CRUD: Create a data at the specific entity
    fileprivate func create(entity: String, data: [String: Any], completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let persistentContainer = appDelegate.persistentContainer.viewContext

            guard let newSearchEntity = NSEntityDescription.entity(forEntityName: entity, in: persistentContainer) else { return }
            let newSearch = NSManagedObject(entity: newSearchEntity, insertInto: persistentContainer)
            newSearch.setValuesForKeys(data)

            do {
                try persistentContainer.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    // MARK: - CRUD: Read all data at one specific entity

    fileprivate func read(entity: String, completion: ([NSFetchRequestResult]?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let persistentContainer = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        do {
            let result = try persistentContainer.fetch(fetchRequest)
            completion(result)
        } catch {
            completion(nil)
        }
    }

    // MARK: - CRUD: Delete all data at one specific entity
    fileprivate func delete(entity: String) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let persistentContainer = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            fetchRequest.includesPropertyValues = false
            
            do {
                let result = try persistentContainer.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    persistentContainer.delete(data)
                }
                try persistentContainer.save()
            } catch {
                print("LOG: Error to delete all data from New Search Entity")
            }
        }
    }
}
