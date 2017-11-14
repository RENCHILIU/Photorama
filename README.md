# Photorama 
  a classical web data image request func tool （Flickr）
  
  from:@Big Nerd Ranch

  
  
  
  
# application structure

    |FlickrAPI
    |PhotoStore 
    |Photo
    |PhotosViewController


###FlickrAPI

    
     The FlickrAPI struct will be responsible for knowing and handling all Flickr-related information.
     
     This includes knowing how to:
     1) generate the URLs that the Flickr API expects   
     2) knowing the format of the incoming JSON         
     3) parse that JSON into the relevant model objects  

    |FlickrAPI
    |
    |----- |flickrURL: building a specified request URL 
    |      
    |      
    |----- |photos: parse resonsed JSON to <a image info list>
              -photo: parse <image info list> to <a image class>


          
###PhotoStore

     The PhotoStore class will handle the actual web service calls.
   
     The URLSession API is a collection of classes that use a request to communicate with a server in a number of ways.
     The URLSessionTask class is responsible for communicating with a server.
     The URLSession class is responsible for creating tasks that match a given configuration.

 
      |PhotoStore 
      |
      |----- |fetchInterestingPhotos: create a URLRequest that connects to api.flickr.com and asks for the list of interesting photos.
              -processPhotosRequest: parse JSON
      |      
      |      
      |----- |fetchImage: returned from the web service request to download the image data
                -processImageRequest: parse JSON




###PhotosViewController

      UI handler
      fetchInterestingPhotos ->complete closure -> fetchImage -> complete closure -> update UI
  
  
  
  
  
  
  
  
###Photo

      
       a Photo class to represent each photo that is returned from the web service request.
       
          
          
          
          




