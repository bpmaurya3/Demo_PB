//
//  Enum.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 9/21/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

enum NoCartCell: Int {
    case NoCartUpperTVCell = 0
    case NoCartLowerTVCell
}

enum MyCartCellType {
    case noCartCell
    case myCartCell
    case myOrderCell
    case whishListCell
    case none
}

enum OnlinePartnerType {
    case otherOnlinePartner
    case earnPartner
    case burnOnlinePartner
    case signupPartner
    case bankingService
    case carporateRewards
}

enum ProductCategoryType: Int {
    case compare = 0, specify, review
}

enum BurnProductCategoryType: Int {
    case specify = 0, review, refund
}

enum OfferOrInsuranceType: Int {
    case rechargeOffers = 0, insuranceCategory
}

enum ShopOrInsuranceType: Int {
    case shop
    case insurance
}

enum ProductType: String {
    case earnProduct = "earn"
    case burnProduct = "burn"
    case offerProduct = "offer"
    case bankingService = "BankingService"
    case carporateRewards = "CarporateRewards"
    case none
}
enum ProductCategory {
    case mobileSearch
    case topTrend
    case shopOnlineCategory
    case bestFashion
    case burn
    case none
}

enum ProductListRequestModelType: String {
    case mobileSearch = "MobileSearch"
    case rewardsSearch = "RewardsSearch"
    case rewardsSearchCategoryPath = "RewardsSearchCategoryPath"
    case none
}

enum WriteUsViewHide: Int {
    case hide = 0, show
}

enum ShopOnlineCellType {
    case heroCarouselTVCell
    case shopClickTVCell
    case categoriesTVCell
    case topTrendTVCell
    case middleAdWithBannerTVCell
    case showCaseCategoryTVCell
    case adWithBannerTVCell
}

enum OnlinePartnerCellType {
    case carouselCVCell
    case onlinePartnerCell
}

enum SortBy: String {
    case Burn_LowTOHigh = "Low To High"
    case Burn_HighToLow = "High To Low"
    case Burn_Popularity = "Popularity"
    case Earn_LowTOHigh = "pricelow"
    case Earn_HighToLow = "pricehigh"
    case Earn_Popularity = "latest"
    case None
}

enum StoreLocaterSortBy: String {
    case LowTOHigh = "Low To High"
    case HighToLow = "High To Low"
    case None
}

enum StoreLocaterFilterKey: String {
    case category = "Category"
    case city = "City"
    case partner = "Partner"
}
enum CategoryType: Int {
    case inStoreOffer
    case onlineOffer
    case recharge
    case coupans
    case helpCentre
    case insuranceDetail
    case none
}
enum ImageType {
    case banner
    case carousel
    case offerTiles
    case homeTiles
    case none
}

enum StaticWebContentType {
    case policies
    case voucherWorld
    case termsAndConditions
    case reviews
    case none
}

enum RightMenuSections: String {
    case myAccount = "MyAccountVC"
    case myTransactions = "MyTransactionsVC"
    case myOrders = "MyOrdersVC"
    case myWishlist = "MyWhishlistVC"
    case upgradetoPayBackPlus = "UpGradePayBackPlusVC"
    case notification = "NotificationVC"
    case storeLocator = "InStorePartnersVC"
    case referaFriend = "PBReferViewController"
    case reteUs = "RateUsVC"
    case helpCentre = "PBHelpCentreViewController"
    case policies = "PoliciesVC"
    case termsAndConditions = "Terms and Conditions"
    case none
}
enum LeftMenuSections: String {
    case eInstoreBrandsVC = "Earn_InstoreBrandsVC"
    case eOnlineBrandsVC = "Earn_OnlineBrandsVC"
    case eShopOnlineViaPaybackVC = "Earn_ShopOnlineViaPaybackVC"
    case eOtherOnlinepartnersVC = "Earn_OtherOnlinepartnersVC"
    case eBankingServicesVC = "Earn_BankingServicesVC"
    case eInstantVouchers = "Earn_InstantVouchersVC"
    case eWriteReviewVC = "Earn_WriteReviewVC"
    case eTakeSurveysVC = "Earn_TakeSurveysVC"
    case rInstantVouchersVC = "Redeem_InstantVouchersVC"
    case rRewardsCatalogueVC = "Redeem_RewardsCatalogueVC"
    case rOnlineBrandsVC = "Redeem_OnlineBrandsVC"
    case rInStoreBrandsVC = "Redeem_InStoreBrandsVC"
    case oNearbuyOffersVC = "OfferInStore_NearbuyOffersVC"
    case oOnlineOffersVC = "OfferOnline_OnlineOffersVC"
    case oRechargeOffersVC = "OfferRecharge_RechargeVC"
    case oCouponsVC = "OfferCoupon_RechargeVC"
    case exPaybackPlusVC = "Explore_UpGradePayBackPlusVC"
    case exInsuranceVC = "Explore_InsuranceVC"
    case exCorporateRewardsVC = "Explore_CorporateRewardsVC"
    case exKnowAboutPAYBACKVC = "Explore_KnowAboutPAYBACKVC"
}
enum OrderStatus: String {
    case ORDER_APPROVED = "ORDER APPROVED"
    case ORDER_REQUEST_SENT_TO_VENDOR = "ORDER REQUEST SENT TO VENDOR"
    case ORDER_PROCESSING_COMPLETED = "ORDER PROCESSING COMPLETED"
    case ORDER_SHIPPED = "shipped"
    case ORDER_DELIVERED = "ORDER DELIVERED"
    case ORDER_CANCELLED_BY_MEMBER = "ORDER CANCELLED BY MEMBER"
}

enum TransactionPointsInfo: String {
    case totalPoints = "This is your total eligible point balance."
    case expiringPoints = "These points are expiring shortly. \n We recommend redemption."
    case pointsInProcess = "These points are in blocked state & will be \n available for redemption subject to fullfillment \n of all conditions of your transaction."
    case redeemablePoints = "These points are available for redemption."
}

enum TransactionRedeemNavType: String {
    case RewardsCatalogue = "Rewards_Catalogue"
    case VoucherWorld = "Voucher_World"
}
