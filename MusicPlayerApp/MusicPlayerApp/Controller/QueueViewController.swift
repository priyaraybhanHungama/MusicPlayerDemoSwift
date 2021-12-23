//
//  QueueViewController.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 23/12/21.
//

import Foundation
import UIKit
class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrQueue = [MusicModel]()
    @IBOutlet var queueTableView: UITableView!
    var controller = MusicPlayerController()

    override func viewDidLoad() {
        self.title = "Player Queue"
        self.registerTableView()
    }

    //MARK: -
    //MARK: TableView
    
    private func registerTableView() {
        self.queueTableView.register(UINib.init(nibName: StringValues.MusicDetailsCellId, bundle: nil), forCellReuseIdentifier: StringValues.MusicDetailsCellId)
        self.queueTableView.delegate = self
        self.queueTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrQueue.count > 0 {
            return arrQueue.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musicCell = tableView.dequeueReusableCell(withIdentifier: StringValues.MusicDetailsCellId, for: indexPath) as? MusicDetailsCell
        let MVM = arrQueue[indexPath.row]
        musicCell?.artistName?.text = MVM.artistName ?? ""
        musicCell?.trackTitle?.text = MVM.trackName ?? ""
        musicCell?.btnAddInQueue.isHidden = true
        let url = URL(string: MVM.artworkUrl100 ?? "")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                musicCell?.trackArtwork?.image = UIImage(data: data!)
                }
        }
        return musicCell!
    }  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        controller = self.storyboard?.instantiateViewController(withIdentifier: StringValues.MusicPlayerControllerId) as! MusicPlayerController
        controller.currentIndex = indexPath.row
        controller.songList = arrQueue
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
