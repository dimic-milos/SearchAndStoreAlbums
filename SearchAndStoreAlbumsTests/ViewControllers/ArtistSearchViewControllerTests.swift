//
//  ArtistSearchViewControllerTests.swift
//  SearchAndStoreAlbumsTests
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//


import XCTest
@testable import SearchAndStoreAlbums

class ArtistSearchViewControllerTests: XCTestCase {
    
    var sut: ArtistSearchViewController!
    
    override func setUp() {
        sut = ArtistSearchViewController()
    }
    
    func test_SutHasTableView() {
        sut.beginAppearanceTransition(true, animated: false)
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_SutHasSearchBar() {
        sut.beginAppearanceTransition(true, animated: false)
        XCTAssertNotNil(sut.searchBar)
    }
    
    func test_DidTapClear_DelegateIsNotifed() {
        let mockArtistSearchViewControllerDelegate = MockArtistSearchViewControllerDelegate()
        sut.delegate = mockArtistSearchViewControllerDelegate
        _ = sut.searchBar(UISearchBar(), shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: "\n")
        XCTAssertTrue(mockArtistSearchViewControllerDelegate.isDelegateNotified)
    }
}

extension ArtistSearchViewControllerTests {
    
    class MockArtistSearchViewControllerDelegate: ArtistSearchViewControllerDelegate {
        
        var isDelegateNotified = false

        func didTapSearchBarCancelButton(in artistSearchViewController: ArtistSearchViewController) {
            
        }
        
        func didTapSearch(forText searchText: String, _ artistSearchViewController: ArtistSearchViewController) {
            isDelegateNotified = true
        }
        
        func didSelect(artist: Artist, in artistSearchViewController: ArtistSearchViewController) {
        
        }
    }
}
