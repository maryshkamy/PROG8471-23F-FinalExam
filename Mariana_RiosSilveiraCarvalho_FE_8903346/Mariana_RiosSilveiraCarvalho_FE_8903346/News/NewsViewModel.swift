//
//  NewsViewModel.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-11.
//

import Foundation

protocol NewsViewModelDelegate: AnyObject {
    func showError()
    func updateTableView()
    func updateCoreData(with searchData: SearchData, and news: NewsData)
}

protocol NewsViewModelProtocol {
    var dataSource: [Article] { get }
    var delegate: NewsViewModelDelegate? { get set }
    func load(_ searchHistoryData: SearchHistoryData)
    func didUpdateLocation(_ newSearchData: SearchData, date: String)
}

class NewsViewModel: NewsViewModelProtocol {
    // MARK: - Protocol Variables
    private(set) var dataSource: [Article]
    weak var delegate: NewsViewModelDelegate?

    // MARK: - Initializer
    init() {
        self.dataSource = []
    }

    // MARK: - Protocol Functions
    func load(_ searchHistoryData: SearchHistoryData) {
        if let news = searchHistoryData.news {
            self.requestInfo(from: SearchData(city: searchHistoryData.search.city, source: searchHistoryData.search.source, type: searchHistoryData.search.type), and: news.publishedAt)
        }
    }

    func didUpdateLocation(_ newSearchData: SearchData, date: String = Date.now.description) {
        self.requestInfo(from: newSearchData, and: date)
    }

    // MARK: - Private Functions
    private func requestInfo(from newSearchData: SearchData, and date: String) {
        let cityFilter = newSearchData.city != "" ? "&q=\(newSearchData.city)" : ""
        let dateFilter = date != "" ? "&to=\(date)" : ""
        guard let url = URL(string: "https://newsapi.org/v2/everything?language=en&sortBy=publishedAt&apiKey=ecc53be23f964ac18214a0629b31dfa5\(cityFilter)&from=2023-12-01\(dateFilter)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    print(news)

                    self.dataSource = news.articles
                    if self.dataSource.count > 0, let firstNews = self.dataSource.first {
                        self.delegate?.updateTableView()

                        if dateFilter == "" {
                            self.delegate?.updateCoreData(
                                with: newSearchData,
                                and: NewsData(
                                    author: firstNews.author ?? "Unknown",
                                    description: firstNews.description,
                                    publishedAt: firstNews.publishedAt,
                                    source: firstNews.source.name,
                                    title: firstNews.title
                                )
                            )
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    self.delegate?.showError()
                }
            }
        }
        task.resume()
    }
}
