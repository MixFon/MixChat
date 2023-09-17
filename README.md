[![CI](https://github.com/TFS-iOS/chat-app-MixFon/actions/workflows/main.yml/badge.svg?branch=features%2Fci-cd)](https://github.com/TFS-iOS/chat-app-MixFon/actions/workflows/main.yml)

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white) 
# MixChat

Данный проект представляет собой простой мессенжер. В нем можно создавать караны, удалять каналы, вести переписка в канале, отправлять сообщения и изображения. Так же в проекте отражены сдующие темы с которыми сталкивается любой IOS разработчик

|              | Таблицы и навигация |
| :--------------------------------------: | :-----------------: |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/navigation.png" /> | Работа с таблицами и реализация навигации в iOS-приложениях. |
|              | Память, функции, замыкания |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/play-video.png" /> | Понимание управления памятью, функций и замыканий в языке программирования Swift. |
|              | Многопоточность |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/upload.png" /> | Техники выполнения параллельных и асинхронных задач в iOS-приложениях с ипользованиес GCD, Operations, Task. |
|              | Реактивное программирование |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/access.png" /> | Введение в реактивное программирование с использованием фреймворка Combine. Реализовано обновление данных для имени и биографии в лейблах и текстфилдах с помощью двух издателей PassthroughSubject. Создан новый воркер для сохранения/загрузки данных с помощью Combine. |
|              | Менеджеры зависимостей |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/new-product.png" /> |  Работа с менеджерами зависимостей, такими как CocoaPods. Реализовано подключение библиотек работы с API с помощью CocoaPods. |
|              | Фреймворк Core Data |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/hosting.png" /> | Работа с Core Data для сохранения данных в iOS-приложениях. Реализовано сохранение/загрузка каналов и сообщений с помощью CoreData. Реализовано легирование методов CoreData с помощью Logger из первого домашнего задания. Настроены модели CoreData. Установлена связь один ко многим в Channes->Message. Установлено каскадное удаление. Реализовано удаление каналов по скайпу влево. Реализована актуализация каналов. Удаляются каналы из CoreData, который есть в CoreData, но нет на сервере. |
|              | Архитектура iOS-приложений |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/data.png" /> | Структура всего проекта подведена под одну архитектуру Swift Clean. Каждую сцену собирает координатор. Присутствует разбиение по слоям. За исключение одного файла ThemeViewController, этот файл не стал разбивать на слои, так как он достаточно небольшой и создавать для него VIP цикл излишне. |
|              | Работа с сетью |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/application.png" /> | Взаимодействие с сетевыми запросами и API в iOS-приложениях. Создание каналов, отправка сообщений, события по удаленияю канала, обновления канала. Все происходит через API. Так же реализован выбор аватарка из сети. Параллельно делается 4 запроса на получение url картинок (всего 120 ссылок). Далее ссылки передаются в контроллер выбора изображения, в котором загружаются только те картинки, ячейки которых видны на экране. Реализована обработка SSE ивентов. Реализована отправка и отображение картинок в экране сообщений. |
|              | Анимация в iOS SDK |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/animation.png" /> | Создание анимаций и переходов с использованием iOS SDK. Реализована анимация тряски кнопки редактирования в профиле пользователя, согласно условию "Длительность анимации 0.3 сек. Кнопка “проворачивается” вокруг своей оси на 18 градусов и по часовой, и против часовой стрелки. Так же отклоняется вверх / вниз на 5 pt, влево / вправо на 5pt." На экране смены темы и на экране профиля реализован показ частичек в виде картинок. Так же реализован кастомные переход между экранами Profile и EditProfile. |
|              | Тестирвание |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/testing.png" /> | Техники и инструменты для тестирования iOS-приложений. В приложении реализованы Unit тесты, они покрывают работу интеракторов списка каналов и сообщения каналов. Так же реализованы UI тесты в которых производится проверка данных на экране профиля. |
|              | CI/CD |
| <img src="https://github.com/TFS-iOS/chat-app-MixFon/blob/features/ci-cd/icons/technology.png" /> | Введение в непрерывную интеграцию и непрерывное развертывание iOS-приложений. Реализована CI прогонка тестов с помощью Fastlane и GitHub Actions. |
