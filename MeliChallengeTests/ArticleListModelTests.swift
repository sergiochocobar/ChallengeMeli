//
//  ArticleListViewModelTests.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import XCTest
import Combine
@testable import MeliChallenge

@MainActor
class ArticleListModelTests: XCTestCase {
    var mockListUseCase: MockListArticlesUseCase!
    var mockSearchUseCase: MockSearchArticlesUseCase!
    var viewModel: ArticleListViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        // Arrange
        mockListUseCase = MockListArticlesUseCase()
        mockSearchUseCase = MockSearchArticlesUseCase()
        
        viewModel = ArticleListViewModel(
            searchArticlesUseCase: mockSearchUseCase,
            listArticlesUseCase: mockListUseCase
        )
        cancellables = []
    }

    override func tearDown() {
        mockListUseCase = nil
        mockSearchUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_GivenSuccessfulLoad_WhenInitialLoad_ThenArticlesArePublished() async {
        // Arrange
        let fakeDetailDTO = ArticleDetailDTO(
            id: 1,
            title: "Initial Article",
            authors: nil,
            url: "",
            imageUrl: "",
            newsSite: "Test Site",
            summary: "Test Summary",
            publishedAt: "",
            updatedAt: "",
            featured: false,
            launches: nil,
            events: nil
        )

        let fakeListDTO = ArticleListDTO(
            count: 1,
            next: nil,
            previous: nil,
            results: [fakeDetailDTO]
        )
        
        let fakeResponse = ArticleResponseModel(dto: fakeListDTO)
        mockListUseCase.executeResult = .success(fakeResponse)
        
        let expectation = XCTestExpectation(description: "El @Published var articles se actualiza")
        
        viewModel.$articles
            .dropFirst()
            .sink { articles in
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, "Initial Article")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.initialLoad()

        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    
    func test_GivenNetworkError_WhenInitialLoad_ThenErrorMessageIsPublished() async {
        // Arrange
        let expectedError = NetworkError.badStatusCode(500)
        mockListUseCase.executeResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "El @Published var errorMessage se actualiza")
        
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, expectedError.errorDescription)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        viewModel.initialLoad()
    
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.articles.isEmpty)
    }
    
    func test_GivenSearchText_WhenDebounceTriggers_ThenSearchUseCaseIsCalled() async {
        // Arrange
        let fakeDetailDTO = ArticleDetailDTO(
            id: 2, title: "Search Result", authors: nil, url: "", imageUrl: "",
            newsSite: "", summary: "", publishedAt: "", updatedAt: "",
            featured: false, launches: nil, events: nil
        )
        let fakeListDTO = ArticleListDTO(
            count: 1, next: nil, previous: nil, results: [fakeDetailDTO]
        )
        let fakeResponse = ArticleResponseModel(dto: fakeListDTO)
        
        mockSearchUseCase.executeResult = .success(fakeResponse)
        
        let expectation = XCTestExpectation(description: "La búsqueda se ejecuta y $articles se actualiza")
        
        viewModel.$articles
            .dropFirst()
            .filter { !$0.isEmpty }
            .sink { articles in
                //Assert
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, "Search Result")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        viewModel.searchText = "SpaceX"
    
        await fulfillment(of: [expectation], timeout: 1.5)
        
        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
}
