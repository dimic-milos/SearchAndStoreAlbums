//
//  AlbumSearchCoordinatorTests.swift
//  SearchAndStoreAlbumsTests
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import XCTest
@testable import SearchAndStoreAlbums

class AlbumSearchCoordinatorTests: XCTestCase {
    
    func test_Init() {
        let sut = AlbumSearchCoordinator(artistNameCapable: NetworkingService(), parserService: ParserService(), rootViewController: MainNavigationController())
        XCTAssertNotNil(sut)
    }
    
    func test_DidTapSearch_MakesGetArtistsNetworkCall() {
        let mockArtistNameCapable = MockArtistNameCapable()
        let sut = AlbumSearchCoordinator(artistNameCapable: mockArtistNameCapable, parserService: ParserService(), rootViewController: MainNavigationController())
        sut.didTapSearch(forText: "", ArtistSearchViewController())
        XCTAssertTrue(mockArtistNameCapable.isGetArtistsCalled)
    }
    
    func test_DidTapSearch_MakesGetArtistsNetworkCallForExpectedName() {
        let expectedName = "kiko"
        let mockArtistNameCapable = MockArtistNameCapable()
        let sut = AlbumSearchCoordinator(artistNameCapable: mockArtistNameCapable, parserService: ParserService(), rootViewController: MainNavigationController())
        sut.didTapSearch(forText: expectedName, ArtistSearchViewController())
        XCTAssertEqual(mockArtistNameCapable.requestedName, expectedName)
    }


    func test_DidTapButtonShowVehiclesOnTheMap_PopViewControllerIsCalled() {
        let spyNavigationController = SpyNavigationController()
        let sut = AlbumSearchCoordinator(artistNameCapable: NetworkingService(), parserService: ParserService(), rootViewController: spyNavigationController)
        sut.viewControllers.append(UIViewController())
        sut.didTapSearchBarCancelButton(in: ArtistSearchViewController())
        
        let exp = expectation(description: "Test after timeout")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(spyNavigationController.isDismissViewControllerCalled)
        } else {
            XCTFail("timedOut")
        }
        
        
    }
}

extension AlbumSearchCoordinatorTests {
    
    class MockArtistNameCapable: ArtistNameCapable {
        
        var isGetArtistsCalled = false
        var requestedName: String?
        
        func getAllArtists(withName artistName: String, apiResponse: NetworkingService.APIResponseCallback?) {
            isGetArtistsCalled = true
            requestedName = artistName
        }
    }
    
    class SpyNavigationController: UINavigationController {
        
        var isDismissViewControllerCalled = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissViewControllerCalled = true
        }
    }
}

