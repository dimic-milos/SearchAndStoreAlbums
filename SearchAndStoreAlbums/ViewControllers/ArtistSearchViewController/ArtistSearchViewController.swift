//
//  ArtistSearchViewController.swift
//  SearchAndStoreAlbums
//
//  Created by Dimic Milos on 8/27/19.
//  Copyright © 2019 Dimic Milos. All rights reserved.
//

import os
import UIKit

class ArtistSearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var artists: [Artist] = []
    private var tempArtists: [Artist] = []
    private lazy var keyboardHeightToConstraintLenghtAdjuster = KeyboardHeightToConstraintLenghtAdjuster(viewController: self, constraint: tableViewBottomConstraint, padding: 20)
    
    weak var delegate: ArtistSearchViewControllerDelegate?

    // MARK: - Init methods
    
    init() {
        os_log(.info, log: .initialization, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        addObservers()
        setupSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        os_log(.info, log: .ui, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        removeObservers()
    }
    
    // MARK: - Public methods
    
    public func reload(withArtists artists: [Artist]) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        self.tempArtists = artists
        reloadTableView()
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggled(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

       NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardToggled(notification: NSNotification) {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        keyboardHeightToConstraintLenghtAdjuster.animate(for: notification)
    }
    
    private func setupSearchBar() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .search
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] (timer) in
            timer.invalidate()
            self?.searchBar.becomeFirstResponder()
        }
    }
    
    private func clearSearchBar() {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)

        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    private func reloadTableView() {
        os_log(.info, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        guard let tableView = tableView else { os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file); return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file); return }
            self.artists = self.tempArtists
            tableView.reloadData()
        }
    }
    
    // MARK: - Action methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        clearSearchBar()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] (timer) in
            timer.invalidate()
            guard let self = self else { os_log(.error, log: .sequence, "function: %s, line: %i, \nfile: %s", #function, #line, #file); return }
            self.delegate?.didTapSearchBarCancelButton(in: self)
        }
    }
}

extension ArtistSearchViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        if searchText == "" {
            tempArtists = []
            reloadTableView()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        if text == "\n", let text = searchBar.text {
            searchBar.resignFirstResponder()
            delegate?.didTapSearch(forText: text, self)
        }
        return true
    }
}

extension ArtistSearchViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        os_log(.info, log: .frequent, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        let cell =  UITableViewCell()
        let artist = artists[indexPath.row]
        cell.textLabel?.text = artist.name
        return cell
    }
}

extension ArtistSearchViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        os_log(.info, log: .action, "function: %s, line: %i, \nfile: %s", #function, #line, #file)
        
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(artist: artists[indexPath.row], in: self)
    }
}
