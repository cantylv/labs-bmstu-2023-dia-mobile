//
//  APIManager.swift
//  labs-bmstu-2023-dia-mobile
//
//  Created by Dmitriy Permyakov on 11.02.2024.
//

import Foundation

final class APIManager {

    static var shared = APIManager()

    func getServices(searchText: String = "", completion: @escaping([Service]) -> Void) {
        /// Задаём URL
        let urlString = "http://192.168.0.100:8000/api/v1/services"
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Невереный URL адрес")
            completion([])
            return
        }
        /// Кладём query параметры
        let queryItems = [
            URLQueryItem(name: "search", value: searchText)
        ]
        /// Если текст поиска не пустой, применяем `search` параметр
        if !searchText.isEmpty {
            urlComponents.queryItems = queryItems
        }

        /// Распаковка опционала URL
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)

        /// Запрос в сеть
        URLSession.shared.dataTask(with: request) { data, _, error in
            /// Если дата не получена и она nil -> ошибка
            guard let data else {
                print("ERROR: Data is NIL")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            /// Если ошибка
            if let error {
                print("ERROR:", error)
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            /// Парсима данные в энитити `ServiceRequest`
            if let service = try? JSONDecoder().decode(ServiceRequest.self, from: data) {
                /// Возаращаем данные в главном потоке
                DispatchQueue.main.async {
                    completion(service.services.map { $0.mapper })
                }
            } else {
                print("ERROR: Ошибка парсинга")
                DispatchQueue.main.async {
                    completion(.mockData)
                }
            }
        }
        .resume()
    }

    func getServiceByID(id: Int, completion: @escaping(Service) -> Void) {
        let urlString = "http://192.168.0.100:8000/api/v1/services/\(id)"
        guard let url = URL(string: urlString) else {
            print("Невереный URL адрес")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else {
                print("ERROR: Data is NIL")
                return
            }
            if let error {
                print("ERROR:", error)
                return
            }
            if let service = try? JSONDecoder().decode(ServiceEntity.self, from: data) {
                DispatchQueue.main.async {
                    completion(service.mapper)
                }
            } else {
                print("ERROR: Ошибка парсинга")
            }
        }
        .resume()
    }
}
