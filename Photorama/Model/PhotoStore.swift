//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

// The PhotoStore class will handle the actual web service calls.
/*
 The URLSession API is a collection of classes that use a request to communicate with a server in a number of ways.
 The URLSessionTask class is responsible for communicating with a server.
 The URLSession class is responsible for creating tasks that match a given configuration.
 */


/*  一个管理photo的处理器
 
 主要两个方法：
 fetchInterestingPhotos ： 请求出一连串的 image 信息， urls
 fetchImage： 对于请求出来的一连串信息后，在得到的image URL中进行单个image的请求，进行 UIImage
 
 fetchInterestingPhotos 的完成闭包中调用 -> fetchImage
 fetchImage 的完成闭包中调用 -> update UI
 
 两种除了request，都自带一个对JSON response数据的解析
 
 */



//请求结果有两种:
//一种是成功后返回的数据，
//一种是Error信息
enum ImageResult {
    case success(UIImage)
    case failure(Error)   //一个failure case 接受参数
}

enum PhotoError: Error {
    case imageCreationError
}

//  定义一个photo结果列表
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
   // hold on to an instance of URLSession.
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
  
    
    
    
    // ------------------------------------------------
    
    
    // ----------------
    // get [photo]
    // ----------------
    
    //**build a request to the service
    //create a URLRequest that connects to api.flickr.com and
    //asks for the list of interesting photos.
    //Then, use the URLSession to create a URLSessionDataTask that transfers this request to the server.
    
    //进行photo数据的request
    // 这里completion 是一个闭包， 指的是完成后要干的事情
    // 因为请求是异步的，所有在请求完成后，还要继续干事情，闭包如何调用，见PhotoVC
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL  // 返回 FlickrAPI 封装好的URL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)   // 这里对result进行返回
            }
        })
        task.resume()
    }
    
    //  user FlickrAPI.photos to get the [Photo]
    //  在FlickrAPI中定义了对FlickrAPI返回的数据的解析，因此实现了逻辑分离。 这里只是调用下。
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    // ------------------------------------------------
    
    
    
    // ----------------
    // get photo , from photo object
    // ----------------
    //you will use the URL returned from the web service request to download the image data
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    
    // fetchImage 的helper func
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
    
    
    
    
    
    
    
    
    
}
