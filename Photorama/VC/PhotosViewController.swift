//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            // complettion 闭包，当数据获取完了，返回的是photoResult 做一些事情。 如果不是，那么就返回error
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
            }
            
            
        }
    }
    
    
    
    
    //store.fetchInterestingPhotos  的完成 闭包中的一个func，当获取了一大批的数据， 在对单个的imge的url进行获取。
    //同时这里面又是一个complete 闭包，完成fetch后，进行UI的刷新。
    func updateImageView(for photo: Photo) {
        self.store.fetchImage(for: photo) {
            (imageResult) -> Void in
            switch imageResult {
            case let .success(image):
                OperationQueue.main.addOperation {
                    self.imageView.image = image
                }
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
}
