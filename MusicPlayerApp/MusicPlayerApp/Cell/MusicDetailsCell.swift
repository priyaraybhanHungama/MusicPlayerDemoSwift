//
//  MuiscDetailsCell.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 21/12/21.
//

import Foundation
import UIKit

protocol MusicDetailsCellDelegate {
    func btnQueueTappedWithTag(tag:Int)

}
class MusicDetailsCell: UITableViewCell {
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackArtwork: UIImageView!
    @IBOutlet weak var btnAddInQueue: UIButton!

    var delegate : MusicDetailsCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackArtwork.layer.cornerRadius = 8.0
        trackArtwork.layer.masksToBounds = true
        trackArtwork.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackTitle.text = "";
        artistName.text = "";
        trackArtwork?.image = #imageLiteral(resourceName: "defualtPlaylist.png")
        trackArtwork?.contentMode = .scaleAspectFit
    }

    @IBAction func btnAddToQueuePressed(_ sender: UIButton) {
        delegate?.btnQueueTappedWithTag(tag: sender.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
