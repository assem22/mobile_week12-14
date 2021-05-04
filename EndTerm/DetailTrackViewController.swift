//
//  DetailTrackViewController.swift
//  EndTerm
//
//  Created by Assem Mukhamadi
//

import UIKit

class DetailTrackViewController: UIViewController {

    @IBOutlet weak var collectionField: UILabel!
    @IBOutlet weak var artistNameField: UILabel!
    @IBOutlet weak var trackNameField: UILabel!
    @IBOutlet weak var trackImageFiled: UIImageView!
    
    var selectedTrack: Track!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionField.text = selectedTrack.artistName
        artistNameField.text = selectedTrack.trackName
        trackNameField.text = selectedTrack.collectionName
        downloadImage(urlstr: selectedTrack.artworkUrl100 ?? "", imageView: trackImageFiled)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
   }
    
    
    func downloadImage(urlstr: String, imageView: UIImageView) {
            let url = URL(string: urlstr)!
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
}
