import SwiftUI

struct DetailView: View {
    /// ID для запроса в сеть
    var id: Int
    /// Переменная, содержащая информацию из сети
    @State private var service: Service = .clear

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {

                /// Картинка из сети по URL
                AsyncImage(url: service.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                }

                /// Блок с текстами
                Group {
                    Text(service.serviceName)
                        .font(.title2)
                        .bold()

                    Divider()
                        .padding(.bottom)

                    generateTextWithTitle(
                        title: "Описание",
                        subtitle: service.description
                    )
                    generateTextWithTitle(
                        title: "Необходимый возраст:",
                        subtitle: service.age
                    )
                    generateTextWithTitle(
                        title: "Заработная плата:",
                        subtitle: service.salary
                    )
                    generateTextWithTitle(
                        title: "Пол:",
                        subtitle: service.gender
                    )
                    generateTextWithTitle(
                        title: "Начало работы:",
                        subtitle: service.dateStart
                    )
                    generateTextWithTitle(
                        title: "Конец работы:",
                        subtitle: service.dateEnd
                    )
                    generateTextWithTitle(
                        title: "Наличие русского гражданства:",
                        subtitle: service.rusPassport
                    )
                    generateTextWithTitle(
                        title: "Наличие медицинской страховки:",
                        subtitle: service.insurance
                    )
                }
                .padding(.horizontal)
            }
            /// Запрос в сеть для получения услуги по ID
            .onAppear {
                APIManager.shared.getServiceByID(id: id) { service in
                    self.service = service
                }
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    /// Генерация вью текст с жирным заголовком и его содержимым, чтобы избежать дублирование кода
    /// - Parameters:
    ///   - title: Заголов с жирным текстом
    ///   - subtitle: Содержимое, например описание
    /// - Returns: вьюха с двумя текстами
    func generateTextWithTitle(title: String, subtitle: String) -> some View {
        Text(title)
            .bold()
        Text(subtitle)
            .font(.system(size: 12, weight: .regular))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DetailView(id: 2)
    }
}
