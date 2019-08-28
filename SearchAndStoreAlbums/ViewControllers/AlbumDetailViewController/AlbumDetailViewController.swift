//
//  AlbumDetailViewController.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/28/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewAlbumDetail: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelAlbumName: UILabel!
    @IBOutlet weak var labelArtistName: UILabel!
    @IBOutlet weak var imageViewAlbumArt: UIImageView!
    
    @IBOutlet weak var buttonToggleAlbumPersistence: UIButton!
    
    // MARK: - Properties
    
    private var album: Album
    private (set) var headerView: HeaderView!
    
    weak var delegate: AlbumDetailViewControllerDelegate?

    // MARK: - Init methods
    
    init(album: Album) {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.album = album
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
        setupView()
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
        
        tableView.register(TrackDetailTableViewCell.nib, forCellReuseIdentifier: TrackDetailTableViewCell.reuseIdentifier())
    }
    
    private func setupView() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        labelAlbumName.text = album.name
        labelArtistName.text = album.artist.name
        setImage(toImageView: imageViewAlbumArt, withImageUrlSting: album.image.first?.imageUrl)
        
        let buttonTitle = album.isPersisted ? "Remove" : "Save"
        buttonToggleAlbumPersistence.setTitle(buttonTitle, for: .normal)
    }
    
    private func setupHeaderView() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

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
    
    // MARK: - Action methods
    
    @IBAction func buttonToggleAlbumPersistenceTapped(_ sender: UIButton) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        if album.isPersisted {
            delegate?.delete(album: album, albumDetailViewController: self)
        } else {
            delegate?.store(album: album, albumDetailViewController: self)
        }
    }
    
}

extension AlbumDetailViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        return album.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackDetailTableViewCell.reuseIdentifier()) as! TrackDetailTableViewCell
        let tracks = album.tracks[indexPath.row]
        cell.labelTrackName.text = tracks.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let title = " \(album.tracks.count) Tracks"
        return title
    }
    
}

extension AlbumDetailViewController: HeaderViewDelegate {

    // MARK: - HeaderViewDelegate

    func didTapButtonSearchForArtists(_ headerView: HeaderView) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        delegate?.didTapSearchForArtists(self)
    }
    
    func didTapButtonBack(_ headerView: HeaderView) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        delegate?.didTapBack(self)
    }
}
