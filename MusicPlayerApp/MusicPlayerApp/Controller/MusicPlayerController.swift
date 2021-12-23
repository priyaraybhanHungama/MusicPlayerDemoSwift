//
//  MusicPlayerController.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 22/12/21.
//

import Foundation
import UIKit
import AVFoundation



class MusicPlayerController: UIViewController   {
    @IBOutlet weak var songTitle: UILabel?
    @IBOutlet weak var artistName: UILabel?
    @IBOutlet weak var artistImage: UIImageView?
    @IBOutlet weak var trackStatusSlider: UISlider?
    @IBOutlet weak var startTime: UILabel?
    @IBOutlet weak var totalTime: UILabel?
    @IBOutlet weak var btnPlayPause: UIButton?
    @IBOutlet weak var btnPreviousSong: UIButton?
    @IBOutlet weak var btnNextSong: UIButton?
    
    var songList = [MusicModel]()
    var currentIndex: Int = 0
    override func viewDidLoad() {
        
        PlayerManger.shareInstance.isPlayerPlaying =  true
        updateUI()
        addObserver()
        btnPlayClicked(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if PlayerManger.shareInstance.player?.rate != 0 && PlayerManger.shareInstance.player?.error == nil{
            PlayerManger.shareInstance.player?.replaceCurrentItem(with: nil)
        }
    }
    
    deinit {
        purgeMediaPlayer()
        NotificationCenter.default.removeObserver(self)
    }
    
    func purgeMediaPlayer() {
        PlayerManger.shareInstance.player = nil
    }
    
    func addObserver()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePlayerInfo), name: NSNotification.Name(StringValues.kUpdatePlayerInfoObserver), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.btnForwordClicked(_:)), name: NSNotification.Name(StringValues.kPlayNextTrackObserver), object: nil)
        
    }
    
    func updateUI()
    {
        
        self.title = "Player"
        let MVM = songList[currentIndex]
        songTitle?.text = MVM.trackName ?? ""
        artistName?.text = MVM.artistName ?? ""
        
        let url = URL(string: MVM.artworkUrl100 ?? "")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.artistImage?.image = UIImage(data: data!)
                self.artistImage?.contentMode = UIView.ContentMode.scaleAspectFit
            }
        }
        
        self.trackStatusSlider?.maximumValue = 00.00
        self.trackStatusSlider?.value = 00.00
        
        self.startTime?.text = "00.00"
        self.totalTime?.text = "00.00"
        
        self.artistImage?.layer.cornerRadius = 12.0
        self.artistImage?.layer.masksToBounds = true
        self.artistImage?.clipsToBounds = true
        
    }
    
    @objc func updatePlayerInfo(){
        
        self.trackStatusSlider?.maximumValue = Float((PlayerManger.shareInstance.player?.currentItem?.duration.seconds)!).isNaN ? 0.0 : Float((PlayerManger.shareInstance.player?.currentItem?.duration.seconds)!)
        self.trackStatusSlider?.value = Float((PlayerManger.shareInstance.player?.currentItem?.currentTime().seconds)!).isNaN ? 0.0 : Float((PlayerManger.shareInstance.player?.currentItem?.currentTime().seconds)!)
        
        self.startTime?.text = String(format: "%.1f",self.trackStatusSlider?.value ?? 0)
        self.totalTime?.text = String(format: "%.1f",self.trackStatusSlider?.maximumValue ?? 0)
    }
    
    @IBAction func btnPlayClicked(_ sender: Any) {
        
        if self.btnPlayPause?.isSelected == true
        {
            PlayerManger.shareInstance.isPlayerPlaying =  false
            PlayerManger.shareInstance.player?.pause()
            self.btnPlayPause?.isSelected = false
            self.btnPlayPause?.setImage(UIImage(named: "play"), for: .normal)
        }
        else
        {
            if PlayerManger.shareInstance.isPlayerPlaying == false
            {
                PlayerManger.shareInstance.player?.play()
            }
            else
            {
                let MVM = songList[currentIndex]
                PlayerManger.shareInstance.playTrackWithUrl(audioUrl: MVM.previewUrl ?? "")
            }
            PlayerManger.shareInstance.isPlayerPlaying =  true
            self.btnPlayPause?.isSelected = true
            self.btnPlayPause?.setImage(UIImage(named: "pause"), for: .selected)
        }
        
    }
    
    @IBAction func btnBackwordClicked(_ sender: Any) {
        
        if currentIndex != 0
        {
            currentIndex = currentIndex - 1
            updateUI()
            if PlayerManger.shareInstance.player?.rate != 0 && PlayerManger.shareInstance.player?.error == nil{
                PlayerManger.shareInstance.player?.replaceCurrentItem(with: nil)
            }
            let MVM = songList[currentIndex]
            PlayerManger.shareInstance.playTrackWithUrl(audioUrl: MVM.previewUrl ?? "")
            
                        if currentIndex == 0
                        {
                            self.btnNextSong?.isEnabled = true
                            self.btnPreviousSong?.isEnabled = false
                            
                        }
    
        }
    }
    
    @IBAction func btnForwordClicked(_ sender: Any) {
        if currentIndex != songList.count - 1
        {
            currentIndex = currentIndex + 1
            updateUI()
            if PlayerManger.shareInstance.player?.rate != 0 && PlayerManger.shareInstance.player?.error == nil{
                PlayerManger.shareInstance.player?.replaceCurrentItem(with: nil)
            }
            let MVM = songList[currentIndex]
            PlayerManger.shareInstance.playTrackWithUrl(audioUrl: MVM.previewUrl ?? "")
                        if currentIndex == songList.count - 1
                        {
                            self.btnNextSong?.isEnabled = false
                            self.btnPreviousSong?.isEnabled = true
            
                        }
        }
    }
    
    
    
    
    
}
