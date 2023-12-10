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
    func create(_ newSearchData: NewSearchData, completion: (Bool) -> Void) {
        self.deleteAllNewSearch()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let persistentContainer = appDelegate.persistentContainer.viewContext

        guard let newSearchEntity = NSEntityDescription.entity(forEntityName: "NewSearch", in: persistentContainer) else { return }
        let newSearch = NSManagedObject(entity: newSearchEntity, insertInto: persistentContainer)
        newSearch.setValuesForKeys([
            "city" : newSearchData.city,
            "source": newSearchData.source,
            "type": newSearchData.type
        ])

        do {
            try persistentContainer.save()
            completion(true)
        } catch {
            completion(false)
        }
    }

    // MARK: - Retrieve the last new search
    func retrieveNewSearch(completion: (NewSearchData?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let persistentContainer = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewSearch")

        do {
            let result = try persistentContainer.fetch(fetchRequest)
            if let data = result.last as? NSManagedObject,
                let city = data.value(forKey: "city") as? String,
                let source = data.value(forKey: "source") as? String,
                let type = data.value(forKey: "type") as? String {
                let newSearchData = NewSearchData(city: city, source: source, type: type)
                completion(newSearchData)
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }

    /*fileprivate*/ func deleteAllNewSearch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let persistentContainer = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewSearch")
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
