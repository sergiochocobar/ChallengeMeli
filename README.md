# Meli Challenge - Space Flight News

Esta aplicación es una solución al challenge técnico de Mercado Libre, diseñada para consumir la API de [Space Flight News](https://api.spaceflightnewsapi.net/v4/documentation) y mostrar artículos de noticias espaciales.

La app permite:
* Ver un listado de los últimos artículos.
* Buscar artículos por un término específico.
* Ver el detalle de un artículo seleccionado.
* Manejar estados de carga y errores de red.

---

## Decisiones Técnicas y Arquitectura

A continuación, se detallan las decisiones tomadas en base a los puntos de evaluación del challenge:

### 1. Arquitectura y Patrones de Diseño

El proyecto está estructurado siguiendo una arquitectura **MVVM (Model-View-ViewModel)** combinada con principios de **Clean Architecture** para separar responsabilidades.

* **View (SwiftUI):** Las vistas como `ArticleListView` y `ArticleDetailView` reaccionan a los cambios de estado publicados por el ViewModel.
* **ViewModel:** Clases como `ArticleListViewModel` y `ArticleDetailViewModel` manejan la lógica de presentación, el estado de la UI (`isLoading`, `errorMessage`, `articles`) y se comunican con los Casos de Uso. Usan `@MainActor` para garantizar que todas las actualizaciones de `@Published` ocurran en el hilo principal.
* **Use Cases (Casos de Uso):** Clases como `ListArticlesUseCase` y `GetArticleDetailUseCase` contienen una regla de negocio específica. Dependen de abstracciones (protocolos) en lugar de implementaciones concretas.
* **Repository (Repositorio):** Se define un protocolo `SpaceFlightRepositoryProtocol` que define el contrato para la obtención de datos. La implementación (`SpaceFlightRepository`) se encarga de hablar con el `NetworkClient`.
* **Networking:** Se usa una capa de red genérica basada en `async/await` con un protocolo `NetworkClientProtocol` y una definición de `Endpoint`, lo que la hace reutilizable.

Esta separación permite un **alto nivel de testabilidad** (puedo mockear los UseCases en los tests del ViewModel, y mockear el Repositorio en los tests de los UseCases) y mantenibilidad.

### 2. Manejo de Errores (Punto de Vista del Usuario)

Se priorizó una experiencia fluida dando feedback claro:

* **Errores de Carga Inicial:** Si la carga inicial falla, `ArticleListView` muestra un mensaje de error claro ("Tenemos un Problema") con el detalle del error y un botón de "Reintentar".
* **Búsqueda Sin Resultados:** Si una búsqueda no devuelve resultados, se muestra un mensaje informativo ("No se encontraron resultados para...").
* **Estados de Carga:** Se usan `ProgressView` (Spinners) tanto en la carga inicial como en la paginación (`loadMoreArticlesIfNeeded`) y en la pantalla de detalle, para que el usuario siempre sepa que la app está trabajando.

### 3. Manejo de Errores (Punto de Vista del Developer)

* **Errores de Red Tipificados:** Se creó un enum `NetworkError` que conforma `LocalizedError`. Esto centraliza todos los posibles errores de red (URL inválida, mal status code, fallos de decodificación) en un solo tipo.
* **Propagación de Errores:** Los errores se propagan "hacia arriba" usando `throws` desde la capa de Red, pasando por el Repositorio y los Casos de Uso.
* **Captura en el ViewModel:** El `ArticleListViewModel` captura estos errores en un bloque `do/catch` dentro de la `Task` y asigna el `.errorDescription` a la variable `@Published var errorMessage`, que la UI consume.

### 4. Calidad del Proyecto (Tests Unitarios)

Se incluyó un target de Tests (`MeliChallengeTests`) para asegurar la calidad y el correcto funcionamiento de la lógica de negocio, independientemente de la UI.

* **Mocks:** Se crearon Mocks para las dependencias, como `MockListArticlesUseCase` y `MockSpaceFlightRepository`.
* **Tests de ViewModels:** Se testea la lógica de los ViewModels de forma aislada. Por ejemplo, `ArticleListViewModelTests` verifica que:
    * `test_GivenSuccessfulLoad_WhenInitialLoad_ThenArticlesArePublished`: Los artículos se publican correctamente.
    * `test_GivenNetworkError_WhenInitialLoad_ThenErrorMessageIsPublished`: El mensaje de error se publica si la red falla.
    * `test_GivenSearchText_WhenDebounceTriggers_ThenSearchUseCaseIsCalled`: El *debounce* de la búsqueda funciona y llama al caso de uso.
* **Tests de Casos de Uso:** Se testea la lógica de negocio. Por ejemplo, `ListArticlesUseCaseTests` y `GetArticleDetailUseCaseTests` confirman que los DTOs del repositorio se mapean correctamente a los Modelos de Dominio.

Todos los tests se ejecutan sobre `@MainActor` para simular el entorno real de los ViewModels.

### 5. Diseño de Layouts y Rotación

* **SwiftUI:** Se utilizó SwiftUI de forma nativa.
* **Layouts Adaptativos:** Se usaron componentes como `NavigationStack`, `ScrollView`, `VStack` y `HStack`.
* **Imágenes Asíncronas:** Se utiliza `AsyncImage` para cargar imágenes de la red de forma eficiente, con placeholders de carga y de error.

### 6. Uso de la Memoria

* **Ciclo de Vida de ViewModels:** Se usa `@StateObject` para instanciar los ViewModels. Esto asegura que el ViewModel vive mientras la Vista esté en pantalla y se libera de memoria correctamente cuando la vista es destruida (por ejemplo, al hacer "pop" en el `NavigationStack`).
* **Combine Cancellables:** En `ArticleListViewModel`, la suscripción al `searchText` se almacena en una propiedad `searchCancellable: AnyCancellable?`. Esta suscripción está ligada al ciclo de vida del ViewModel; cuando el ViewModel es desinicializado, el `AnyCancellable` también lo es, cerrando la suscripción y evitando "memory leaks".
* **Paginación:** Los artículos se cargan en lotes (`limit: 20`) y se añaden a la lista solo cuando el usuario se acerca al final, en lugar de cargar miles de artículos a la vez.

### 7. Permisos del Sistema Operativo

Al iniciar, la aplicación pide permiso para enviar Notificaciones.

Esto se hace para preparar la app para futuras funcionalidades, como poder avisar al usuario cuando haya nuevos artículos de su interés.
