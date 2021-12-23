//
//  MusicViewModel.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 21/12/21.
//

import Foundation
class MusicViewModel {

    static let shareInstance = MusicViewModel()

    func fetchMusicDataFromItunesServer(completion: @escaping([MusicModel]?, Error?) -> ()) {
          NetworkService.shareInstance.getAllMusicData{ (music, error) in
              if(error==nil){
                  completion(music?.results, nil)
              }
          }
      }
}
