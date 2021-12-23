//
//  NetworkService.swift
//  MusicPlayerApp
//
//  Created by Priya Raybhan on 21/12/21.
//

import Foundation
class NetworkService: NSObject {
    
    
    static let shareInstance = NetworkService()

        func getAllMusicData(completion: @escaping(ResultsModel?, Error?) -> ()){



            let urlString = "https://itunes.apple.com/search?media=music&term=bollywood"



            guard let url = URL(string: urlString) else { return }



            URLSession.shared.dataTask(with: url) { (data, response, error) in



                if let err = error{



                    completion(nil,err)



                    print("Loading data error: \(err.localizedDescription)")



                }else{



                    guard let data = data else { return }



                    do{



                        let results = try JSONDecoder().decode(ResultsModel.self, from: data)



                        completion(results, nil)



                    }catch let jsonErr{



                        print("json error : \(jsonErr.localizedDescription)")



                    }



                }



            }.resume()



        }
    
}
