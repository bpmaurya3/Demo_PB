//
//  LeftMenuData.swift
//  PayBack
//
//  Created by Dinakaran M on 31/08/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
// MARK: - Section Data Structure
public struct Item {
    var name: String?
    var icon: String?
    var ItemID: String?
    public init(name: String, icon: String, itemID: String) {
        self.name = name
        self.icon = icon
        self.ItemID = itemID
    }
}
public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    public init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
public struct SectionList {
    var section: [Section]
    init(sectionArray: [Section]) {
        self.section = sectionArray
    }
}
public var sectionData: [Section] = [
    Section(name: "EARN POINTS", items: [
                                         Item(name: "In-store Brands", icon: "instore", itemID: LeftMenuSections.eInstoreBrandsVC.rawValue),
                                         Item(name: "Online Brands", icon: "onlinepartners", itemID: LeftMenuSections.eOnlineBrandsVC.rawValue),
//                                         Item(name: "Shop Online Via PAYBACK", icon: "shoponline", itemID: LeftMenuSections.eShopOnlineViaPaybackVC.rawValue),
//                                         Item(name: "Other Online Partners", icon: "otheronline", itemID: LeftMenuSections.eOtherOnlinepartnersVC.rawValue),
                                         Item(name: "Banking Services", icon: "banking_services", itemID: LeftMenuSections.eBankingServicesVC.rawValue),
                                         Item(name: "Instant Vouchers", icon: "vouchergram", itemID: LeftMenuSections.eInstantVouchers.rawValue),
                                         Item(name: "Write Reviews", icon: "reviews", itemID: LeftMenuSections.eWriteReviewVC.rawValue)
                                         //Item(name: "Take Surveys", icon: "surveys", itemID: LeftMenuSections.eTakeSurveysVC.rawValue)
                                            ], collapsed:false),
    Section(name: "REDEEM POINTS", items: [
                                           Item(name: "Instant Vouchers", icon: "vouchergram", itemID: LeftMenuSections.rInstantVouchersVC.rawValue),
                                           Item(name: "Rewards Catalogue", icon: "rewardscatalogue", itemID: LeftMenuSections.rRewardsCatalogueVC.rawValue),
                                           Item(name: "Online Brands", icon: "onlinepartners", itemID: LeftMenuSections.rOnlineBrandsVC.rawValue),
                                           Item(name: "In-store Brands", icon: "instore", itemID: LeftMenuSections.rInStoreBrandsVC.rawValue)], collapsed:true),
    Section(name: "OFFER ZONE", items: [Item(name: "Nearby", icon: "in_storeoffer", itemID: LeftMenuSections.oNearbuyOffersVC.rawValue),
                                        Item(name: "Online Offers", icon: "onlineoffers", itemID: LeftMenuSections.oOnlineOffersVC.rawValue),
                                        Item(name: "Recharge Offers", icon: "rechargeoffers", itemID: LeftMenuSections.oRechargeOffersVC.rawValue),
                                        Item(name: "Coupons", icon: "coupons", itemID: LeftMenuSections.oCouponsVC.rawValue)], collapsed:true),
    Section(name: "EXPLORE", items: [Item(name: "PAYBACK Plus", icon: "paybackplus", itemID: LeftMenuSections.exPaybackPlusVC.rawValue),
                                     Item(name: "Insurance", icon: "insurance", itemID: LeftMenuSections.exInsuranceVC.rawValue),
                                     Item(name: "Corporate Rewards", icon: "corporate_rewards", itemID: LeftMenuSections.exCorporateRewardsVC.rawValue),
                                     Item(name: "Know about PAYBACK", icon: "know_about_payback", itemID: LeftMenuSections.exKnowAboutPAYBACKVC.rawValue)
                                    ], collapsed:true)
    
]
