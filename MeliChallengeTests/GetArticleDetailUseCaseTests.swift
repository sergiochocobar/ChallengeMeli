//
//  GetArticleDetailUseCaseTests.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 31/10/2025.
//

import XCTest
@testable import MeliChallenge

class GetArticleDetailUseCaseTests: XCTestCase {
    var mockRepository: MockSpaceFlightRepository!
    var useCase: GetArticleDetailUseCase!

    override func setUp() {
        super.setUp()
        // Arrange
        mockRepository = MockSpaceFlightRepository()
        useCase = GetArticleDetailUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func test_GivenSuccessfulDTO_WhenExecute_ThenReturnsCorrectArticleModel() async throws {
        // Arrange
        let fakeDTO = ArticleDetailDTO(
            id: 123,
            title: "Fake Article",
            authors: nil,
            url: "http://fake.url",
            imageUrl: "http://image",
            newsSite: "Fake Site",
            summary: "Fake Summary",
            publishedAt: "", updatedAt: "", featured: false, launches: nil, events: nil
        )
        
        mockRepository.getArticleDetailResult = .success(fakeDTO)
        
        // Act
        let model = try await useCase.execute(id: 123)
        
        // Assert
        XCTAssertEqual(model.id, 123)
        XCTAssertEqual(model.title, "Fake Article")
        XCTAssertEqual(model.summary, "Fake Summary")
        XCTAssertEqual(model.newsSite, "Fake Site")
    }
    
    func test_GivenNetworkError_WhenExecute_ThenThrowsError() async {
        // Arrange
        let expectedError = NetworkError.badStatusCode(404)
        
        mockRepository.getArticleDetailResult = .failure(expectedError)
        
        // Act
        do {
            _ = try await useCase.execute(id: 404)
            XCTFail("El caso de uso debía lanzar un error, pero no lo hizo.")
        } catch {
            guard let networkError = error as? NetworkError else {
                XCTFail("El error no es del tipo NetworkError")
                return
            }
            XCTAssertEqual(networkError.errorDescription, expectedError.errorDescription)
        }
    }
}
