//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

/*
 a Photo class to represent each photo that is returned from the web service request.
 */
class Photo {
    
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
