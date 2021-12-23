//
//  MusicModel.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 21/12/21.
//

import Foundation
class MusicModel: Decodable {
    var artistName: String?
    var trackName: String?
    var previewUrl: String?
    var artworkUrl100 : String?

    init(artistName:String, trackName: String, previewUrl:String, artworkUrl100: String){
        self.artistName = artistName
        self.trackName = trackName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100

    }
}


class ResultsModel: Decodable {
    
    var results = [MusicModel]()
    
    init(results: [MusicModel]) {
        self.results = results
    }
    
}
