//
//  ArticleModelTests.swift
//  MeliChallenge
//
//  Created by Sergio Chocobar on 31/10/2025.
//

// ArticleModelTests.swift
import XCTest
@testable import MeliChallenge

class ArticleModelTests: XCTestCase {

    func test_GivenArticleListDTO_WhenMappedToModel_ThenDataIsCorrect() {
        // Arrange
        let detailDTO = ArticleDetailDTO(
            id: 1,
            title: "Test Title",
            authors: nil,
            url: "http://test.com",
            imageUrl: "http://image.com",
            newsSite: "Test Site",
            summary: "Test Summary",
            publishedAt: "2025-10-30T00:00:00Z",
            updatedAt: "2025-10-30T00:00:00Z",
            featured: false,
            launches: nil,
            events: nil
        )
        
        let listDTO = ArticleListDTO(
            count: 1,
            next: "next_page",
            previous: nil,
            results: [detailDTO]
        )
        
        // Act
        let responseModel = ArticleResponseModel(dto: listDTO)
        
        // Assert (Confirmar)
        XCTAssertEqual(responseModel.count, 1)
        XCTAssertEqual(responseModel.next, "next_page")
        XCTAssertNil(responseModel.previous)
        
        XCTAssertEqual(responseModel.articles.count, 1)
        let articleModel = responseModel.articles.first
        
        XCTAssertEqual(articleModel?.id, 1)
        XCTAssertEqual(articleModel?.title, "Test Title")
        XCTAssertEqual(articleModel?.summary, "Test Summary")
        XCTAssertEqual(articleModel?.newsSite, "Test Site")
        XCTAssertEqual(articleModel?.imageUrl, "http://image.com")
        XCTAssertEqual(articleModel?.url, "http://test.com")
    }
}
