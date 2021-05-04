//
//  MusicListViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit

class MusicListViewController: UIViewController {
    
    let networkService = NetworkService()
    var searchResponse: SearchResponse? = nil
    private var timer: Timer?

    @IBOutlet weak var tableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    var searchBar:UISearchBar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
//        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
//        print("track?.artworkUrl60: ", track?.artworkUrl100)
        cell.textLabel?.text = track?.trackName
        return cell
    }
    
    func tableView(_ collectionView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = searchResponse?.results[indexPath.item]

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailTrackViewController") as? DetailTrackViewController{
            vc.selectedTrack = object
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MusicListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=25"

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.request(urlString: urlString) { [weak self] (result) in
                switch result{
                case .success(let searchResponse):
                    self?.searchResponse = searchResponse
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
}
