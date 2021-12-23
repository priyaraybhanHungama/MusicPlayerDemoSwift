//
//  MusicViewController.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 21/12/21.
//

import Foundation
import UIKit

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var queueTracksCount: UILabel!
    @IBOutlet var btnQueue: UIButton!
    var arrQueue = [MusicModel]()
    var queueController = QueueViewController()

    var arrMusicVM = [MusicModel]()
    var viewModel = MusicViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTableView()
        self.registerTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        arrQueue = [MusicModel]()
        self.getData()
        self.queueTracksCount.layer.cornerRadius = self.queueTracksCount.frame.size.height/2
        self.queueTracksCount.layer.masksToBounds = true
        self.queueTracksCount.clipsToBounds = true
    }
    //MARK: -
    //MARK: TableView
    
    private func updateTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerTableView() {
        tableView.register(UINib.init(nibName: StringValues.MusicDetailsCellId, bundle: nil), forCellReuseIdentifier: StringValues.MusicDetailsCellId)
    }

    //MARK - Fetch data from server
    
    func getData(){
        
        viewModel.fetchMusicDataFromItunesServer {  (music, error) in

            if(error==nil){
                self.arrMusicVM = music ?? []
                DispatchQueue.main.async {
                    self.queueTracksCount.text = String(self.arrQueue.count)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: -
    //MARK: UITableView Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrMusicVM.count > 0 {
            return arrMusicVM.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musicCell = tableView.dequeueReusableCell(withIdentifier: StringValues.MusicDetailsCellId, for: indexPath) as? MusicDetailsCell
        let MVM = arrMusicVM[indexPath.row]
        musicCell?.artistName?.text = MVM.artistName ?? ""
        musicCell?.trackTitle?.text = MVM.trackName ?? ""
        musicCell?.btnAddInQueue.tag = indexPath.row
        let url = URL(string: MVM.artworkUrl100 ?? "")
        musicCell?.delegate = self
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                musicCell?.trackArtwork?.image = UIImage(data: data!)
                }
        }
        return musicCell!
    }
    
    @IBAction func btnQueueClicked(_ sender: Any) {
        queueController = self.storyboard?.instantiateViewController(withIdentifier: StringValues.QueueViewControllerId) as! QueueViewController
        queueController.arrQueue = arrQueue
        self.navigationController?.pushViewController(queueController, animated: true)
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 12.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
extension MusicViewController : MusicDetailsCellDelegate {
    func btnQueueTappedWithTag(tag: Int) {
        let MVM = arrMusicVM[tag]
        self.arrQueue.append(MVM)
        self.showToast(message: "Song added into queue")
        self.queueTracksCount.text = String(self.arrQueue.count)
    }
}

