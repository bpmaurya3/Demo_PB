//
//  WishListRequestModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 1/29/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct WishListRequestModel: Encodable {
    let type: String
    let vendorCode: String
    let data: WishListData
    
    init(type: String = "combineWishList", data: WishListData) {
        self.type = type
        self.vendorCode = StringConstant.vendorCode
        self.data = data
    }
    
    struct WishListData: Encodable {
        let email: String
        let userId: String
        
        init(withEmail email: String, userId: String) {
            self.email = email
            self.userId = userId
        }
    }
}
// Delete
struct WishListDeleteRequestModel: Encodable {
    let type: String
    let data: WishListData
    
    init(type: String = "ShopOnlineDeleteWishList", data: WishListData) {
        self.type = type
        self.data = data
    }
    
    struct WishListData: Encodable {
        let email: String
        let product_id: String
        
        init(withEmail email: String, productId: String) {
            self.email = email
            self.product_id = productId
        }
    }
}
struct RewardsWishListDeleteRequestModel: Encodable {
    let type: String
    let vendorCode: String
    let data: WishListData
    
    init(type: String = "RemoveWishList", data: WishListData) {
        self.type = type
        self.vendorCode = StringConstant.vendorCode
        self.data = data
    }
    
    struct WishListData: Encodable {
        let wishListId: String
        let userId: String
        
        init(withWishListId wishListId: String, userId: String) {
            self.wishListId = wishListId
            self.userId = userId
        }
    }
}
typealias ProductInfo = (id: String, name: String, url: String, userAction: String, inStock: String)
// Add
struct WishListAddRequestModel: Encodable {
    let type: String
    let data: AddWishListData
    
    init(type: String = "ShopOnlineAddWishList", data: AddWishListData) {
        self.type = type
        self.data = data
    }
    
    struct AddWishListData: Encodable {
        let email: String
        let product_id: String
        let product_name: String
        let product_url: String
        let user_action: String
        let instock: String
        
        init(withEmail email: String, productInfo: ProductInfo) {
            self.email = email
            self.product_id = productInfo.id
            self.product_name = productInfo.name
            self.product_url = productInfo.url
            self.user_action = productInfo.userAction
            self.instock = productInfo.inStock
        }
    }
}

struct RewardsAddWishListRequestModel: Encodable {
    let type: String
    let vendorCode: String
    let data: WishListData
    
    init(type: String = "AddWishList", data: WishListData) {
        self.type = type
        self.vendorCode = StringConstant.vendorCode
        self.data = data
    }
    
    struct WishListData: Encodable {
        let productId: String
        let skuCode: String
        let qty: String
        let totalPoint: String
        let userId: String
    }
}
