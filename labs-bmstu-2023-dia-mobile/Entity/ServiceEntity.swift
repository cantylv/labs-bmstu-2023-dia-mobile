import Foundation

struct ServiceRequest: Decodable {
    let services: [ServiceEntity]
}

struct ServiceEntity: Decodable {
    let id: Int
    let job: String
    let img: String
    let about: String
    let sex: String
    let date_start: String
    let date_end: String
    let age: Int
    let salary: Int
    let insurance: Bool
    let rus_passport: Bool
}

// MARK: - Mapper

extension ServiceEntity {

    var mapper: Service {
        .init(
            id: id,
            serviceName: job,
            gender: sex.sexMapper,
            rusPassport: rus_passport ? "Есть необходимость" : "Нет необходимости",
            insurance: insurance ? "Есть необходимость" : "Нет необходимости",
            description: about,
            imageURL: URL(string: img.replacingOccurrences(of: "localhost", with: "192.168.0.100")),
            age: "\(age)",
            salary: "\(salary) RUB",
            dateStart: date_start.correctData,
            dateEnd: date_end.correctData
        )
    }
}

private extension String {

    var sexMapper: String {
        switch self {
        case "A": return "Не важно"
        case "M": return "Мужской"
        case "W": return "Женский"
        default: return "Ошибка"
        }
    }
    
    var correctData: String {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy в HH:mm"
            let formattedDate = dateFormatter.string(from: date)
            print(formattedDate)
            return formattedDate
        } else {
            print("Неверный формат даты")
            return ""
        }
    }

}



    
