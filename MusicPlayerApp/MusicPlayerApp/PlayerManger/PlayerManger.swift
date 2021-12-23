//
//  PlayerManger.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 22/12/21.
//

import Foundation
import AVFoundation

import MediaPlayer
var nowPlayingInfo = [String : Any] ()
private var playerItemContext = 0

class PlayerManger: NSObject {
    static let shareInstance = PlayerManger()
    var player:AVPlayer?
    var arrQueue = [MusicViewModel]()
    var isPlayerPlaying = Bool()

    func playTrackWithUrl(audioUrl : String){
        
        let playerItem:AVPlayerItem  = AVPlayerItem.init(url: URL.init(string:audioUrl)!)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        self.player = AVPlayer.init(playerItem: playerItem)
        self.player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil) // somewhere after player init
        if (self.player != nil && self.player?.rate == 0)
        {
            self.player?.play()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: StringValues.kPlayNextTrackObserver), object: nil, userInfo: [:])
        
    }
    
    func updateTime() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    @objc func update () {
        
        self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            
            if (self.player?.currentItem?.duration) != nil {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: StringValues.kUpdatePlayerInfoObserver), object: nil, userInfo: [:])
                
            }
        })
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            //
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                
                updateTime()
                
                break
                // Player item is ready to play.
            case .failed: break
                // Player item failed. See error.
            case .unknown: break
                // Player item is not yet ready.
            default:
                break
            }
        }else if keyPath == "rate"{
            if self.player?.rate == 0.0 {
            }else if self.player?.rate == 1.0 {
                if !(self.player?.currentItem?.duration.seconds.isNaN ?? false) {
                }
            }
        }
        
    }
    
    
    
}

extension AVPlayer {
    
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}
