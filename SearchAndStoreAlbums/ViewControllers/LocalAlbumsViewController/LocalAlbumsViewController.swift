//
//  LocalAlbumsViewController.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class LocalAlbumsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties

    private var albums: [Album] = []
    private (set) var headerView: HeaderView!
    private let localAlbumsController: LocalAlbumsController
    
    weak var delegate: LocalAlbumsViewControllerDelegate?
    
    // MARK: - Init methods
    
    init(localAlbumsController: LocalAlbumsController) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.localAlbumsController = localAlbumsController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        registerCells()
        setupHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        delegate?.viewWillAppear(in: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
    }
    
    // MARK: - Public methods
    
    func update(withAlbums albums: [Album]) {
        self.albums = albums
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        albums = localAlbumsController.getOfflineAlbums()
    }
    
    private func registerCells() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        collectionView.register(BasicAlbumInfoCollectionViewCell.nib, forCellWithReuseIdentifier: BasicAlbumInfoCollectionViewCell.reuseIdentifier())
    }
    
    private func setupHeaderView() {
//        #warning("load it directly from xib")
        headerView = HeaderView.fromNib()
        guard let headerView = headerView else {
            os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return
        }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.delegate = self
        headerView.buttonBack.isHidden = true
        
        viewContainer.addSubview(headerView)
        viewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[headerView]-(0)-|", options: [], metrics: nil, views: ["headerView": headerView]))
        viewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView]|", options: [], metrics: nil, views: ["headerView": headerView]))
    }
}

extension LocalAlbumsViewController: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicAlbumInfoCollectionViewCell.reuseIdentifier(), for: indexPath) as! BasicAlbumInfoCollectionViewCell
        let album = albums[indexPath.row]
        cell.labelAlbumName.text = album.name
        cell.labelArtistName.text = album.artist.name
        cell.labelTracksCount.text = "No. of tracks: \(album.tracks.count)"
        return cell
    }
}

extension LocalAlbumsViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        delegate?.didSelect(album: albums[indexPath.row], in: self)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        return .init(width: 100, height: 50)
    }
}


extension LocalAlbumsViewController: HeaderViewDelegate {
    
    // MARK: - HeaderViewDelegate
    
    func didTapButtonSearchForArtists(_ headerView: HeaderView) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        delegate?.didRequestToSearchForArtists(self)
    }
    
    func didTapButtonBack(_ headerView: HeaderView) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

    }
}

