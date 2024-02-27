import SwiftUI

struct MainView: View {

    /// Переменная, содержащая инфмормацию из сети
    @State private var services: [Service] = []
    /// Переменная, из ввода текста для сортировки по поиску
    @State private var searchText = ""
    
    var body: some View {
        /// Инициализация стэка страниц
        NavigationStack {
            /// Скролл вью, чтобы можно было скроллить контент
            ScrollView {

                /// Отрисовка ввода текста с кнопкой поиск
                HStack {
                    TextField(text: $searchText) {
                        Text("Поиск")
                    }
                    .padding(8)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.horizontal)

                    Button {
                        APIManager.shared.getServices(searchText: searchText) { services in
                            self.services = services
                        }
                    } label: {
                        Text("Поиск")
                            .tint(Color.buttonColor)
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)

                /// Перебор всех сервисов и отрисовка карточки
                ForEach(services) { service in
                    VStack {
                        NavigationLink(value: service) {
                            ServiceCard(service: service)
                            /// Делаем углы карточки
                                .clipShape(.rect(cornerRadius: 16))
                            /// Накладываем закруглённую рамку
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(lineWidth: 1)
                                }
                            /// Отступы от границ экрана
                                .padding(.horizontal, 6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Услуги")
            .navigationDestination(for: Service.self) { service in
                DetailView(id: service.id)
            }
        }
        /// Запрос в сеть
        .onAppear {
            APIManager.shared.getServices { data in
                services = data
            }
        }
    }
}

// MARK: - Subviews

extension MainView {

    @ViewBuilder
    /// Отрисовка карточки услуги
    /// - Parameter service: данные об услуге
    /// - Returns: вьюха ячейки
    func ServiceCard(service: Service) -> some View {
        VStack(alignment: .leading) {
            /// Картинка из сети по URL
            AsyncImage(url: service.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipped()
            } placeholder: {
                /// Спиннер во время ожидания прогрузки фото
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
            }

            /// Блок с тектами
            Group {
                Text(service.serviceName)
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                Text("Необходимый возраст:")
                    .bold()
                Text(service.age)
                    .font(.system(size: 12, weight: .regular))
                Text("Зарплата:")
                    .bold()
                Text(service.salary)
                    .font(.system(size: 12, weight: .regular))
                Text("Начало работы:")
                    .bold()
                Text(service.dateStart)
                    .font(.system(size: 12, weight: .regular))
                Text("Начало работы:")
                    .bold()
                Text(service.dateEnd)
                    .font(.system(size: 12, weight: .regular))

                Text("Подробнее")
                /// Цвет текста
                    .foregroundStyle(.white)
                /// Отступ по бокам
                    .padding(.horizontal, 10)
                /// Отступ по вертикали
                    .padding(.vertical, 8)
                /// Красим фон кнопки в фиолетовый
                    .background(Color.buttonColor)
                /// Делаем углы у кнопки 6 градусов
                    .clipShape(.rect(cornerRadius: 6))
                /// Деламе вертикальный отступ кнопки от текста выше и низ
                    .padding(.vertical)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview {
    MainView()
}
