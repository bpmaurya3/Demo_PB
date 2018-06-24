//
//  RequestFactory.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 8/22/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

let Rendition_Url_Constant = "/jcr:content/renditions/cq5dam.thumbnail"

enum RenditionSize: String {
//    case twoX_HeroBanner_Banner_Placard_HomeTiles = ".716.287.png"
//    case threeX_HeroBanner_Banner_Placard_HomeTiles = ".1074.430.png"
//    case twoX_Carousel = ".750.336.png"
//    case threeX_Carousel = ".1125.504.png"
//    case twoX_OfferTiles = ".354.216.png"
//    case threeX_OfferTiles = ".531.324.png"
//    case twoX_HomeTiles = ".730.250.png"
//    case threeX_HomeTiles = ".1095.375.png"
//    case IPad_HeroBanner_Banner_Placard_HomeTiles = ".2048.821.png"
//    case IPad_Carousel = ".2048.917.png"
//    case IPad_OfferTiles = ".2028.694.png"
//    case IPad_HomeTiles = ".967.590.png"
    
    case twoX_HeroBanner_Banner_Placard_HomeTiles = ".716.239.png"
    case threeX_HeroBanner_Banner_Placard_HomeTiles = ".1074.358.png"
    case IPad_HeroBanner_Banner_Placard_HomeTiles = ".2048.682.png"
    case ThreeTwenty_HeroBanner_Banner_Placard_HomeTiles = ".320.107.png"
    
    case twoX_Carousel = ".750.310.png"
    case threeX_Carousel = ".1125.465.png"
    case IPad_Carousel = ".2048.846.png"
    case ThreeTwenty_Carousel = ".320.132.png"
    
    case twoX_OfferTiles = ".354.216.png"
    case threeX_OfferTiles = ".531.324.png"
    case IPad_OfferTiles = ".967.590.png"
    case ThreeTwenty_OfferTiles = ".151.92.png"
    
    case twoX_HomeTiles = ".730.250.png"
    case threeX_HomeTiles = ".1095.375.png"
    case IPad_HomeTiles = ".2028.694.png"
    case ThreeTwenty_HomeTiles = ".300.103.png"
    
}

final internal class RequestFactory: NSObject {
//    fileprivate static let CMS_Dev_BaseURL = "http://203.112.146.83:4503/bin/paybackmobility"
//    fileprivate static let CMS_Dev_ImageURL = "http://203.112.146.83:4503"
//    fileprivate static let ESB_Dev_BaseURL = "http://203.112.146.87:8081/api/payback"
    
//    fileprivate static let CMS_Dev_BaseURL = "http://172.16.200.5:4503/bin/paybackmobility"
//    fileprivate static let CMS_Dev_ImageURL = "http://172.16.200.5:4503"
//    fileprivate static let ESB_Dev_BaseURL = "http://172.16.200.10:8081/api/payback"
    
    fileprivate static let CMS_Dev_BaseURL = "https://pbmobi.payback.in/bin/paybackmobility"
    fileprivate static let CMS_Dev_ImageURL = "https://pbmobi.payback.in"
    fileprivate static let ESB_Dev_BaseURL = "https://pbesb.payback.in/api/payback"
    
//    fileprivate static let CMS_Dev_BaseURL = "http://192.168.130.118:4503/bin/paybackmobility"
//    fileprivate static let CMS_Dev_ImageURL = "http://192.168.130.118:4503"
//    fileprivate static let ESB_Dev_BaseURL = "http://192.168.130.118:8081/api/payback"
    
//    fileprivate static let CMS_Dev_BaseURL = "http://192.168.130.156:4503/bin/paybackmobility"
//    fileprivate static let CMS_Dev_ImageURL = "http://192.168.130.156:4503"
//    fileprivate static let ESB_Dev_BaseURL = "http://192.168.130.156:8081/api/payback"
 
    fileprivate static let ESB_Rewards_ImageURL  = ""//"https://rewards.payback.in"
}

extension RequestFactory {
    
    static func getFinalImageURL(urlString: String) -> String {
        let urlStr = CMS_Dev_ImageURL + urlString
        
        let escapedString = urlStr.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        return escapedString
    }
    static func addHttpsWithUrl(urlString: String) -> String {
        let urlStr = "https://" + urlString
        
        let escapedString = urlStr.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        return escapedString
    }
    
    static func getFullURL(urlString: String) -> String {
        var tempUrl = ""
        if urlString.contains("http") {
            tempUrl = urlString
        } else if urlString.contains("www") {
            tempUrl = RequestFactory.addHttpsWithUrl(urlString: urlString)
        } else {
            tempUrl = RequestFactory.getFinalImageURL(urlString: urlString)
        }
        return tempUrl
    }
    
    static func getFinalRewardsImageURL(urlString: String) -> String {
        let urlStr = ESB_Rewards_ImageURL + urlString
        
        return urlStr
    }
}

// MARK: - Authentication

extension RequestFactory {
    static func request(requestBody: Data) -> URLRequest {
        let urlString = ESB_Dev_BaseURL
        
        let request = RequestBuilder()
            .ofType(.POST)
            .set(urlString: urlString)
            .set(contentType: "application/json")
            .set(httpBody: requestBody)
            .build()
        
        return request!
    }
}

// MARK: Tiles Grid

extension RequestFactory {
    
    static func otherOnlinePartnersForEarn() -> URLRequest {
        let parameters = "?content=otheronlinepartners&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
        .ofType(.GET)
        .set(urlString: pathWithParameters)
        .set(authorizationToken: "payback")
        .set(contentType: "application/json")
        .build()
        
        return request!
    }
    
    static func onlinePartnersForBurn() -> URLRequest {
        let parameters = "?content=redeemonlinepartners&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func earnPartners() -> URLRequest {
        let parameters = "?content=earnpartners&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func signupPartners() -> URLRequest {
        let parameters = "?content=signup&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func bankingServicesPartners() -> URLRequest {
        let parameters = "?content=banking-services&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func corporateRewardsPartners() -> URLRequest {
        let parameters = "?content=corporate-rewards&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Image Carousel

extension RequestFactory {
    static func onboard() -> URLRequest {
        let parameters = "?content=introduction&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func couponsCarousel() -> URLRequest {
        let parameters = "?content=coupons&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func rechargeCarousel() -> URLRequest {
        let parameters = "?content=recharge-offers&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func helpCenterCarousel() -> URLRequest {
        let parameters = "?content=customer-support&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func rewardsCarousel() -> URLRequest {
        let parameters = "?content=infinity-rewards&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func instoreOfferCarousel() -> URLRequest {
        let parameters = "?content=in-store-offers&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func onlineOfferCarousel() -> URLRequest {
        let parameters = "?content=online-offers&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func offerCarousel() -> URLRequest {
        let parameters = "?content=offer-zone&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Offer Landing Carousel: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Hero Banner

extension RequestFactory {
    // OP = Online Partner
    // OOP = Other Online Partner
    // EOOP = Earn Other Online Partner
    // BOP = Burn Online Partner
    static func carouselForEOOP() -> URLRequest {
        let parameters = "?content=otheronlinepartners&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func carouselForBOP() -> URLRequest {
        let parameters = "?content=redeemonlinepartners&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func carouselForEarnPartner() -> URLRequest {
        let parameters = "?content=earnpartners&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func carouselForBankingService() -> URLRequest {
        let parameters = "?content=banking-services&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func carouselForCorporateRewards() -> URLRequest {
        let parameters = "?content=corporate-rewards&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func heroBannerForShopOnline(component: String) -> URLRequest {
        let parameters = "?content=shop-online&component=\(component)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func bannerForReward() -> URLRequest {
        let parameters = "?content=infinity-rewards&component=bannerimage"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func plaCardForReward() -> URLRequest {
        let parameters = "?content=infinity-rewards&component=partnerplacard"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func bannerForPaybackPlus() -> URLRequest {
        let parameters = "?content=payback-plus&component=bannerimage"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Sign In
extension RequestFactory {
    static func signIn() -> URLRequest {
        let parameters = "?content=signin&component=signin"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}
// MARK: Sign UP
extension RequestFactory {
    static func signupImageGrid() -> URLRequest {
        let parameters = "?content=signup&component=imagegridwithtitle"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// PayBack Plus

extension RequestFactory {
    static func paybackPlusExclusive() -> URLRequest {
        let parameters = "?content=payback-plus&component=icondescgridview"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Point Calculator
extension RequestFactory {
    static func pointCalculator() -> URLRequest {
        let parameters = "?content=points-calculator&component=pointscalculator"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Static Web Content
extension RequestFactory {
    static func getStaticWebContent() -> URLRequest {
        let parameters = "?content=staticwebcontent&component=staticwebcontent"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}
// MARK: Segment Categories
extension RequestFactory {
    static func couponsCategories() -> URLRequest {
        let parameters = "?content=coupons&component=categories"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func rechargeCategories() -> URLRequest {
        let parameters = "?content=recharge-offers&component=categories"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func instoreOffersCategories() -> URLRequest {
        let parameters = "?content=in-store-offers&component=categories"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func onlineOffersCategories() -> URLRequest {
        let parameters = "?content=online-offers&component=categories"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Coupons by Category
extension RequestFactory {
    static func couponsDetails(tag: String) -> URLRequest {
        let parameters = "?content=coupons&component=verticaltilegrid&filterTag=\(tag)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func rechargeDetails(tag: String) -> URLRequest {
        let parameters = "?content=recharge-offers&component=verticaltilegrid&filterTag=\(tag)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func instoreOffersDetails(tag: String) -> URLRequest {
        let parameters = "?content=in-store-offers&component=verticaltilegrid&filterTag=\(tag)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func onlineOffersDetails(tag: String) -> URLRequest {
        let parameters = "?content=online-offers&component=verticaltilegrid&filterTag=\(tag)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func landingOffers() -> URLRequest {
        let parameters = "?content=offer-zone&component=verticaltilegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Offer Landing Verticaltilegrid Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func paybackPlusPartners() -> URLRequest {
        let parameters = "?content=payback-plus&component=verticaltilegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func insuranceWhyProtect() -> URLRequest {
        let parameters = "?content=insurance&component=verticaltilegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: Insurance
extension RequestFactory {
    static func insuranceHeroCarousel() -> URLRequest {
        let parameters = "?content=insurance&component=imagecarousel"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func insuranceTypes() -> URLRequest {
        let parameters = "?content=insurance&component=icongridview"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func insurancePartners() -> URLRequest {
        let parameters = "?content=insurance&component=partnerdetail"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func insuranceSubTypes(tag: String) -> URLRequest {
        let parameters = "?content=insurance-inner&component=tagimagegrid&filterTag=\(tag)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func insuranceDetails(tag: String) -> URLRequest {
        let parameters = "?content=insurance-inner&component=verticaltilegrid&filterTag=\(tag)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

// MARK: HelpCenter
extension RequestFactory {
    static func helpCenter() -> URLRequest {
        let parameters = "?content=customer-support&component=accordion"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}
// MARK: Landing
extension RequestFactory {
    static func homeLanding(content: String) -> URLRequest {
        let parameters = "?content=\(content)&component=imagegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Home Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func extentedHome() -> URLRequest {
        let parameters = "?content=home&component=apphome"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Home Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func earnLanding() -> URLRequest {
        let parameters = "?content=earn-points&component=imagegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Earn Landing Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func burnLanding() -> URLRequest {
        let parameters = "?content=redeem-points&component=imagegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Burn Landing Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func exploreLanding() -> URLRequest {
        let parameters = "?content=explore&component=imagegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Explore Landing Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    
    static func offerLandingGrid() -> URLRequest {
        let parameters = "?content=offer-zone&component=imagegrid"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Offer Landing Imagegrid Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}
extension RequestFactory {
    static func myCardContent() -> URLRequest {
        let parameters = "?content=myprofile&component=mycarddetails"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("myCardContent Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func showcaseCategories() -> URLRequest {
        let parameters = "?content=shop-online&component=showcasecategories"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("myCardContent Request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}

extension RequestFactory {
    static func transactionRedeemNavDetails() -> URLRequest {
        let parameters = "?content=navigator&component=navigator"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func explorePayback() -> URLRequest {
        let parameters = "?content=explore-payback&component=pbexplore"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        let request = RequestBuilder()
            .ofType(.GET)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
    static func writeToUs(email: String?, mobileNo: String?, message: String, toEmail: String?) -> URLRequest {
        var params = "/sendMail?content=writetous&component=writetous&"
        if let email = email, email != "" {
            params += "from=\(email)&"
        }
        if let phone = mobileNo, phone != "" {
            params += "phone=\(phone)&"
        }
        if let to = toEmail, to != "" {
            params += "to=\(to)&"
        }
        let parameters = params + "message=\(message)"
        let pathWithParameters = CMS_Dev_BaseURL + parameters
        print("Write to us request: \(pathWithParameters)")
        let request = RequestBuilder()
            .ofType(.POST)
            .set(urlString: pathWithParameters)
            .set(authorizationToken: "payback")
            .set(contentType: "application/json")
            .build()
        
        return request!
    }
}
