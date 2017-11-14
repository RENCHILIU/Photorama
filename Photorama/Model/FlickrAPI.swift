//
//  Copyright © 2015 Big Nerd Ranch
//



/*
 The FlickrAPI struct will be responsible for knowing and handling all Flickr-related information.
 
 This includes knowing how to:
 
 1) generate the URLs that the Flickr API expects   生成特定方法的request URL
 2) knowing the format of the incoming JSON         解析 response中的JSON
 3) parse that JSON into the relevant model objects  通过JSON解析出封装好的Photo类
 
 */

/*
 两个主要方法：
 1.flickrURL 返回特定的url
 2.photos 对返回的json data进行解析
 
 
 
 
 
 */










import Foundation

enum FlickrError: Error {
    case invalidJSONData
}

//specify which endpoint on the Flickr server to hit.
//raw value that matches the corresponding Flickr endpoint.
enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}


// a Flicker API struct
struct FlickrAPI {
    
   
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    //define the date formatter 
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
   // URL 类型
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos,
                         parameters: ["extras": "url_h,date_taken"])
    }
    
    
    // format URL to different type URL , such as interestingPhotosURL
    /**
     @param1: 接受一个method（ request url的一部分）
     @param2: 接受额外参数进行补全
     
     */
    
    
    
    // 生成一个request的 URL
    private static func flickrURL(method: Method,
        parameters: [String:String]?) -> URL {
        
        //Initializes from a URL string.
            var components = URLComponents(string: baseURLString)!
        
        //An array of query items for the URL in the order in which they appear in the original query string.
            var queryItems = [URLQueryItem]()
            
            let baseParams = [
                "method": method.rawValue,
                "format": "json",
                "nojsoncallback": "1",
                "api_key": apiKey
            ]
        
            // 读取上面定义的基本参数
            for (key, value) in baseParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        
            //读取method中输入的额外参数
            if let additionalParams = parameters {
                for (key, value) in additionalParams {
                    let item = URLQueryItem(name: key, value: value)
                    queryItems.append(item)
                }
            }
        
            components.queryItems = queryItems
        
       
            return components.url!
    }
    
    
    
    
    // JSON parse to [Photo]
    static func photos(fromJSON data: Data) -> PhotosResult {
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // We weren't able to parse any of the photos.
                // Maybe the JSON format for photos has changed.
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    // photos的helper function, from JSON   -> 返回 封装Photo 这个类
    private static func photo(fromJSON json: [String : Any]) -> Photo? {
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                
                // Don't have enough information to construct a Photo
                return nil
        }

        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }

}
