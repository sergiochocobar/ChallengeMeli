//
//  ListArticlesUseCaseTests.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 30/10/2025.
//

import XCTest
@testable import MeliChallenge

class ListArticlesUseCaseTests: XCTestCase {

    var mockRepository: MockSpaceFlightRepository!
    var useCase: ListArticlesUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockSpaceFlightRepository()
        useCase = ListArticlesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func test_GivenSuccessfulDTO_WhenExecute_ThenReturnsCorrectResponseModel() async throws {
        // Arrange
        let fakeDetailDTO = ArticleDetailDTO(
            id: 1, title: "List Article", authors: nil, url: "", imageUrl: "",
            newsSite: "Site", summary: "Summary", publishedAt: "",
            updatedAt: "", featured: false, launches: nil, events: nil
        )
        
        let fakeListDTO = ArticleListDTO(
            count: 1, next: "next_page", previous: nil, results: [fakeDetailDTO]
        )

        mockRepository.listArticlesResult = .success(fakeListDTO)
        
        // Act
        let responseModel = try await useCase.execute(limit: 10, offset: 0)
        
        // Assert
        XCTAssertEqual(responseModel.count, 1)
        XCTAssertEqual(responseModel.next, "next_page")
        XCTAssertEqual(responseModel.articles.count, 1)
        XCTAssertEqual(responseModel.articles.first?.title, "List Article")
    }
    

    func test_GivenNetworkError_WhenExecute_ThenThrowsError() async {
        // Arrange
        let expectedError = NetworkError.invalidURL
        mockRepository.listArticlesResult = .failure(expectedError)
        
        // Act y Assert
        do {
            _ = try await useCase.execute(limit: 10, offset: 0)
            XCTFail("El caso de uso debía lanzar un error, pero no lo hizo.")
        } catch {
            guard let networkError = error as? NetworkError else {
                XCTFail("Error inesperado: \(error)")
                return
            }
            XCTAssertEqual(networkError.errorDescription, expectedError.errorDescription)
        }
    }
}
