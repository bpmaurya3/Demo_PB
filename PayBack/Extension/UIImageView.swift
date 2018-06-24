//
//  UIImageView.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/13/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import UIKit
extension UIImageView {
    
    private func getRenditionPath(imageType: ImageType) -> String {
        var renditionPath = ""
        
        switch imageType {
        case .banner:
            renditionPath = DeviceType.IS_IPAD ? "\(Rendition_Url_Constant)\(RenditionSize.IPad_HeroBanner_Banner_Placard_HomeTiles.rawValue)" : DeviceType.IS_IPHONE_5 ? "\(Rendition_Url_Constant)\(RenditionSize.ThreeTwenty_HeroBanner_Banner_Placard_HomeTiles.rawValue)" : UIDevice.current.scale == 3 ? "\(Rendition_Url_Constant)\(RenditionSize.threeX_HeroBanner_Banner_Placard_HomeTiles.rawValue)" : "\(Rendition_Url_Constant)\(RenditionSize.twoX_HeroBanner_Banner_Placard_HomeTiles.rawValue)"
        case .carousel:
            renditionPath = DeviceType.IS_IPAD ? "\(Rendition_Url_Constant)\(RenditionSize.IPad_Carousel.rawValue)" : DeviceType.IS_IPHONE_5 ? "\(Rendition_Url_Constant)\(RenditionSize.ThreeTwenty_Carousel.rawValue)" : UIDevice.current.scale == 3 ? "\(Rendition_Url_Constant)\(RenditionSize.threeX_Carousel.rawValue)" : "\(Rendition_Url_Constant)\(RenditionSize.twoX_Carousel.rawValue)"
        case .offerTiles:
            renditionPath = DeviceType.IS_IPAD ? "\(Rendition_Url_Constant)\(RenditionSize.IPad_OfferTiles.rawValue)" : DeviceType.IS_IPHONE_5 ? "\(Rendition_Url_Constant)\(RenditionSize.ThreeTwenty_OfferTiles.rawValue)" : UIDevice.current.scale == 3 ? "\(Rendition_Url_Constant)\(RenditionSize.threeX_OfferTiles.rawValue)" : "\(Rendition_Url_Constant)\(RenditionSize.twoX_OfferTiles.rawValue)"
        case .homeTiles:
            renditionPath = DeviceType.IS_IPAD ? "\(Rendition_Url_Constant)\(RenditionSize.IPad_HomeTiles.rawValue)" : DeviceType.IS_IPHONE_5 ? "\(Rendition_Url_Constant)\(RenditionSize.ThreeTwenty_HomeTiles.rawValue)" : UIDevice.current.scale == 3 ? "\(Rendition_Url_Constant)\(RenditionSize.threeX_HomeTiles.rawValue)" : "\(Rendition_Url_Constant)\(RenditionSize.twoX_HomeTiles.rawValue)"
        case .none:
            renditionPath = ""
        }
        
        return renditionPath
    }
    
    func downloadImageFromUrl(urlString: String, imageType: ImageType = .none) {
        var renditionPath = self.getRenditionPath(imageType: imageType)
        if urlString.contains("http") { // for ESB images
            renditionPath = self.getRenditionPath(imageType: .none)
        }
        let imageUrl = RequestFactory.getFullURL(urlString: urlString) + renditionPath
        
        guard let url = URL(string: imageUrl) else {
            return
        }
        //print("\(url)")
        self.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .retryFailed) { (_, _, _, _) in
//            if let error = error {
//                print("Image URL not proper: \(String(describing: url)) & Error: \(error)")
//            }
        }
        
      /*
         let session = URLSession(configuration: URLSessionConfiguration.default)
         let url = URLRequest(url: urlStr)
        let downloadTask = session.dataTask(with: url, completionHandler: { data, _, error in
            
            if error == nil {
                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                } else {
                    print("Image URL not proper: \(url)")
                    DispatchQueue.main.async { [weak self] in
                        self?.image = #imageLiteral(resourceName: "Sample_2")
                    }
                }
            }
            
        })
        downloadTask.resume()
         */
    }
}
