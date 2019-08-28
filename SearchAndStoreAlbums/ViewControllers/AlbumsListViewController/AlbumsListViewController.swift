//
//  AlbumsListViewController.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class AlbumsListViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var albums: [Album] = []
    private (set) var headerView: HeaderView!
    
    weak var delegate: AlbumsListViewControllerDelegate?
    
    // MARK: - Init methods
    
    init(albums: [Album]) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.albums = albums
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
    }
    
    // MARK: - Private methods
    
    private func registerCells() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        tableView.register(DetailAlbumTableViewCell.nib, forCellReuseIdentifier: DetailAlbumTableViewCell.reuseIdentifier())
    }
    
    private func setupHeaderView() {
        headerView = HeaderView.fromNib()
        guard let headerView = headerView else {
            os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            return
        }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.delegate = self
        headerView.buttonBack.isHidden = false
        
        viewContainer.addSubview(headerView)
        viewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[headerView]-(0)-|", options: [], metrics: nil, views: ["headerView": headerView]))
        viewContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView]|", options: [], metrics: nil, views: ["headerView": headerView]))
    }
    
    private func setImage(toImageView imageView: UIImageView, withImageUrlSting urlString: String?) {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        if let urlString = urlString, let imageUrl = URL(string: urlString) {
            imageView.af_setImage(withURL: imageUrl, placeholderImage: #imageLiteral(resourceName: "taxi"), imageTransition: .crossDissolve(0.2))
        } else {
            os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
            imageView.image = #imageLiteral(resourceName: "taxi")
        }
    }

}

extension AlbumsListViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailAlbumTableViewCell.reuseIdentifier()) as! DetailAlbumTableViewCell
        
        let album = albums[indexPath.row]
        cell.setCell(albumName: album.name, isAvailableOffline: true)
        setImage(toImageView: cell.imageViewAlbumArt, withImageUrlSting: album.image.first?.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        var title = "TOP Albums by: "
        if let artistName = albums.first?.artist.name {
            title += artistName
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        return UITableViewCell.defaultHeight()
    }
}

extension AlbumsListViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlbumsListViewController: HeaderViewDelegate {
    
    func didTapButtonSearchForArtists(_ headerView: HeaderView) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

    }
    
    func didTapButtonBack(_ headerView: HeaderView) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        delegate?.didTapBack(self)
    }
    
    
}
