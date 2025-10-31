//
//  ArticleDetailViewModelTests.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import XCTest
import Combine
@testable import MeliChallenge

@MainActor
class ArticleDetailViewModelTests: XCTestCase {

    var mockUseCase: MockGetArticleDetailUseCase!
    var viewModel: ArticleDetailViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        // Arrange
        mockUseCase = MockGetArticleDetailUseCase()
        viewModel = ArticleDetailViewModel(
            articleId: 1,
            getArticleDetailUseCase: mockUseCase
        )
        cancellables = []
    }

    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func test_GivenSuccessfulLoad_WhenLoadArticleDetail_ThenArticleIsPublished() async {
        // Arrange
        let fakeArticle = ArticleModel(id: 1,
                                       title: "Success Article",
                                       imageUrl: "",
                                       newsSite: "",
                                       summary: "",
                                       url: "",
                                       publishedAt: Date(),
                                       authors: ["Test Author"],
                                       launches: ["Test Launch"])
        
        mockUseCase.executeResult = .success(fakeArticle)
        
        let expectation = XCTestExpectation(description: "El @Published var article se actualiza")
        
        viewModel.$article
            .dropFirst()
            .sink { article in
                //Assert
                XCTAssertEqual(article?.id, 1)
                XCTAssertEqual(article?.title, "Success Article")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        viewModel.loadArticleDetail()
    
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_GivenNetworkError_WhenLoadArticleDetail_ThenErrorMessageIsPublished() async {
        // Arrange
        let expectedError = NetworkError.invalidURL
        mockUseCase.executeResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "El @Published var errorMessage se actualiza con un error")
        
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .sink { errorMessage in
                // Assert
                XCTAssertEqual(errorMessage, expectedError.errorDescription)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        viewModel.loadArticleDetail()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.article)
    }
}
