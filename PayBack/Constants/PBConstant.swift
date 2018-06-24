//
//  PBConstant.swift
//  PaybackPopup
//
//  Created by Mohsin.Surani on 22/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import UIKit

var isErrorViewDisplaying = false
var isProfileEditing = false

let alertPopUpID = "AlertPopUp"
let alertCouponID = "AlertCouponPopUp"
let feedBackAlertID = "FeedBackAlertPopUp"
let passwordAlertID = "PasswordPopUp"

let LocationFound = "LocatonFound"

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
// Home Tiles Height
let HomeTiles_Height = ScreenSize.SCREEN_WIDTH / 730 * 250
// MARK: Offer Tiles Height Ratio
let OfferTiles_HeightRatio: CGFloat = 354 / 216
// MARK: Carousel Height
let Carousel_Height = ScreenSize.SCREEN_WIDTH / 1500 * 620//750 * 336
// MARK: Banner Height
let Banner_Height = ScreenSize.SCREEN_WIDTH / 1500 * 500 //716 * 287
// MARK: Segment Menu Height constant
let segmentHeight: CGFloat = ScreenSize.SCREEN_HEIGHT / 10
// MARK: Point calculator Constants
let chooseMonthlySpends = NSLocalizedString("Choose your monthly spends from the\nfollowing and learn how much you can earn.", comment: "")
let pointFooterViewNibID = "PointFooterView"
// MARK: GOOLE MAP API KEY
let providerAPIKey = "AIzaSyAmKvUHvO1kOMzIMSRNypAY1qlK99dAq7o"//"AIzaSyByLcg58aK83PgV1o-xKxzfRoECFJsjwtc" 

// MARK: Right Menu Controller
let rightMenuVC: [String] = ["MyAccountVC", "MyTransactionsVC", "MyOrdersVC", "MyWhishlistVC", "ChangePinViewController", "TrackOrderVC", "MyCartVC"]

let No_Data_Found_CellDataSource_Count = 1
let iPad_AdSize: CGFloat = 90
let BestInFashionCategoryId = "224"
let ElectronicAndApplianceCategoryId = "1"

public struct DeviceType {
    static let IS_IPHONE_4_OR_LESS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONEX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

}

struct Maximum {
    static let allowedCharactersForDescription = 70
}

struct Cells {
    static let defaultCVCell = "UICollectionViewCell"
    static let defaultTVCell = "UITableViewCell"
    static let noDataFoundTVCell = "NoDataFoundTVCell"
    
    static let onBoardCVCell = "OnBoardCVCell"
    static let carouselCVCell = "CarouselCVCell"
    static let offerTVCell = "PBOfferTVCell"
    static let shopClickCVCell = "PBShopClickCVCell"
    static let showCaseCategoryCVCell = "ShowCaseCategoryCVCell"
    static let whatsYourWishTVCell = "WhatsYourWishTVCell"
    static let showCaseCategoryTVCell = "ShowCaseCategoryTVCell"
    static let adWithBannerTVCell = "AdWithBannerTVCell"
    static let carouselTVCell = "CarouselTVCell"
    static let hotDealsTVCell = "HotDealsTVCell"
    static let topTrendTVCell = "TopTrendTVCell"
    static let shopClickTVCell = "ShopClickTVCell"
    static let categoriesTVCell = "CategoriesTVCell"
    static let topTrendLargeCVCell = "PBTopTrendLargeCVCell"
    static let notificationTVCell = "PBNotificationTVCell"
    static let heroBannerCVCell = "HeroBannerCVCell"
    static let onlinePartnerCell = "OnlinePartnerCell"
    static let earnProductDetailHeaderCell = "ProductDetailHeaderCell"
    static let compareCellNibID = "CompareCell"
    static let reviewCellNibID = "ReviewCell"
    static let specifyCellNibID = "SpecifyCell"
    static let avgRatingNibID = "AverageRatingView"
    static let rateProgressNibID = "RateProgressCell"
    static let avgRatingCellNibID = "AvgRatingCell"
    static let burnDetailHeaderCellNibID = "BurnProductDetailHeaderCell"
    static let insuranceHeaderCellNibID = "InsuranceHeaderCell"
    static let insuranceProtectCellNibID = "InsuranceProtectCell"
    static let insuranceCategoryCellNibID = "InsuranceCategoryCell"
    static let aboutItemCellId = "AboutItemCell"
    static let otherpartnerCellId = "OtherPartnerCell"
    static let pointCellNibID = "MyPointsCell"
    // MARK: HELP CENTRE
    static let helpCentreCellID = "PBHelpCentreTVCell"
    static let helpCentreLabelCellID = "PBHelpCentreLabelTVCell"
    static let helpCentreDetailTVCellID = "PBHelpCentreDetailTVCell"
    static let helpCntreFeedbackTVCellID = "PBHelpCntreFeedbackTVCell"
    // MARK: OFFER ZONE
    static let categoryCellID = "GridTVCell"
    static let offersCellID = "PBOfferTVCell"
    static let offerContentCeLLID = "PBOfferContentCVCell"
    static let rechargeOfferCellID = "PBRechargeTVCell"
    // MARK: PayBack Plus
    static let userInfoTVCellID = "PBUserInfoTVCell"
    static let userPointTVCellID = "PBUserPointTVCell"
    static let userPointOfferTVCellID = "PBUserPointOfferTVCell"
    static let userOfferTVCellID = "PBUserOffersTVCell"
    static let exclusivBenefitsTVCellID = "ExclusivBenefitsTVCell"
    static let exclusivBenefitsCVCellID = "ExclusiveBenefitsCVCell"
    // MARK: WishList
    static let wishListCellID = "PBWishListTVCell"
    // MARK: MYTRANSACTION
    static let myTransactionTVCell = "MyTransactionTVCell"
    static let myTransactionVTVCell = "MyTransactionVTVCell"
    
    static let pbBaseControllerTableViewCell = "PBBaseControllerTableViewCell"
    
    static let homeShowCaseTVCell = "HomeShowCaseTVCell"
    static let homeShowCaseCVCell = "HomeShowCaseCVCell"
    
    static let instoreListTVCell = "InstoreListTVCell"
    
    // MARK: Explore payback
    static let exploreFirstTVCell = "ExploreFirstTableViewCell"
    static let exploreSecondTVCell = "ExploreSecondTableViewCell"
    
    static let adTVCell  = "AdTVCell"
    
}

struct SegueIdentifier {
    static let baseOnlinePartners = "BaseOnlinePartners"
    static let surveyVC = "SurveyVC"
    static let reviewVC = "ReviewVC"
}
