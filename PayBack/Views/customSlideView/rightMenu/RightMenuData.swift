//
//  RightMenuData.swift
//  PayBack
//
//  Created by Dinakaran M on 01/09/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
// MARK: - Section Data Structure
public struct RightMenuItem {
    var name: String?
    var icon: String?
    var itemId: String?
    public init(name: String, icon: String, itemID: String) {
        self.name = name
        self.icon = icon
        self.itemId = itemID
    }
}
public struct RightMenuSection {
    var name: String
    var items: [RightMenuItem]
    var collapsed: Bool
    public init(name: String, items: [RightMenuItem], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
public var rightMenuSectionData: [RightMenuSection] = [
    RightMenuSection(name: "User Prifile1", items: [
                                                    RightMenuItem(name: "My Account", icon: "myaccount", itemID: RightMenuSections.myAccount.rawValue),
                                                    RightMenuItem(name: "My Transactions", icon: "mytransactions", itemID: RightMenuSections.myTransactions.rawValue),
                                                    RightMenuItem(name: "My Orders", icon: "myorders", itemID: RightMenuSections.myOrders.rawValue),
                                                    RightMenuItem(name: "My Whishlist", icon: "mywishlist", itemID: RightMenuSections.myWishlist.rawValue)
//                                                    RightMenuItem(name: "Upgrade to PAYBACK PLUS", icon: "upgradetopaypackplus", itemID: RightMenuSections.upgradetoPayBackPlus.rawValue)
                                                    ]),
    RightMenuSection(name: "User Prifile2", items: [
                                                    RightMenuItem(name: "Notification", icon: "notification", itemID: RightMenuSections.notification.rawValue),
                                                    RightMenuItem(name: "Store Locator", icon: "storelocator", itemID: RightMenuSections.storeLocator.rawValue),
                                                    //RightMenuItem(name: "Refer a Friend", icon: "referafriend2", itemID: RightMenuSections.referaFriend.rawValue),
                                                    RightMenuItem(name: "Rate Us", icon: "rateus", itemID: RightMenuSections.reteUs.rawValue)]),
    RightMenuSection(name: "User Prifile3", items: [
                                                    RightMenuItem(name: "Help Centre", icon: "helpcentre", itemID: RightMenuSections.helpCentre.rawValue),
                                                    RightMenuItem(name: "Policies", icon: "policies", itemID: RightMenuSections.policies.rawValue),
                                                    RightMenuItem(name: "Terms & Conditions", icon: "terms_and_conditions", itemID: RightMenuSections.termsAndConditions.rawValue)])
]
