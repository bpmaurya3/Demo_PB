//
//  DeliveryAddressRequestModel.swift
//  PayBack
//
//  Created by Mohsin Surani on 16/11/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct DeliveryAddressRequestModel: Codable {
    var ViewDeliveryAddressRequest: ViewDeliveryAddressRequest
    init(viewDeliveryAddressRequest: ViewDeliveryAddressRequest) {
        self.ViewDeliveryAddressRequest = viewDeliveryAddressRequest
    }
    struct ViewDeliveryAddressRequest: Codable {
        var userid: String
        init(userid: String) {
            self.userid = userid
        }
    }
}

struct InsertDeliveryAddressRequestModel: Codable {
    var CreateDeliveryAddressRequest: CreateDeliveryAddressRequest

    init(createDeliveryAddressRequest: CreateDeliveryAddressRequest) {
        self.CreateDeliveryAddressRequest = createDeliveryAddressRequest
    }
    
    struct CreateDeliveryAddressRequest: Codable {
        var userid: String
        var address: [AddressSplitCellModel]
        
        init(userid: String, address: AddressSplitCellModel) {
            self.userid = userid
            self.address = [address]
        }
    }
}

struct UpdateDeliveryAddressRequestModel: Codable {
    var UpdateDeliveryAddressRequest: UpdateDeliveryAddressRequest
    
    init(updateDeliveryAddressRequest: UpdateDeliveryAddressRequest) {
        self.UpdateDeliveryAddressRequest = updateDeliveryAddressRequest
    }
    
    struct UpdateDeliveryAddressRequest: Codable {
        var userid: String
        var address: [AddressSplitCellModel]
        
        init(userid: String, address: AddressSplitCellModel) {
            self.userid = userid
            self.address = [address]
        }
    }
}

struct DeleteDeliveryAddressRequestModel: Codable {
    var DeleteDeliveryAddressRequest: DeleteDeliveryAddressRequest
    init(deleteDeliveryAddressRequest: DeleteDeliveryAddressRequest) {
        self.DeleteDeliveryAddressRequest = deleteDeliveryAddressRequest
    }
    struct DeleteDeliveryAddressRequest: Codable {
        var userid: String
        var id: String
        
        init(userid: String, id: String) {
            self.userid = userid
            self.id = id
        }
    }
}
