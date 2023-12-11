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

    func create(searchHistory: SearchHistoryData, completion: @escaping (Bool) -> Void) {
        var newHistory: [String: Any] = [
            "city" : searchHistory.search.city,
            "source": searchHistory.search.source,
            "type": searchHistory.search.type,
        ]

        if let weather = searchHistory.weather {
            newHistory["weatherCity"] = weather.city
            newHistory["weatherDate"] = weather.date
            newHistory["weatherDescription"] = weather.description
            newHistory["weatherHumidity"] = weather.humidity
            newHistory["weatherIcon"] = weather.icon
            newHistory["weatherTemperature"] = weather.temperature
            newHistory["weatherWind"] = weather.wind
        }

        self.create(entity: "SearchHistory", data: newHistory, completion: completion)
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
