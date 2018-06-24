//
//  RequestBody.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 10/24/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation
import JWT

final internal class RequestBody {
    
    static func getBurnProductList(params: BurnProductParamsModel) -> Data {
        
        let requestBody = ProductListRequestModel.BurnProductList(data: BurnProductListData(skip: params.skip, limit: params.limit, searchText: params.searchText, categoryPath: params.categoryPath, minPoints: params.minPoints, maxPoints: params.maxPoints, brand: params.brand, sort: params.sort))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("getBurnProductList \(params.categoryPath):\(json)")
            }
            return encodedData
        }
        return Data()
        
    }
    
    static func getWhatsYourWish() -> Data {
        let requestBody = CategoryRequestModel(type: "rewardsCategory", searchType: "burn")
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("GetWhatsYourWish: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Auto Search

extension RequestBody {
    static func getAutoSearch(searchType: String, searchText: String) -> Data {
        let searchRequest = SearchRequestModel(type: "autosearch", searchType: searchType, data: SearchRequestModel.Data(searchText: searchText))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(searchRequest) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Auto Search Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Authentication

extension RequestBody {
    static func getAuthentication(alias: String, aliasType: String, secret: String) -> Data {
        let auth = AuthenticationModel(authenticationRequest: AuthenticateRequestStruct(authentiction: AuthenticationStruct(identity: IdentificationStruct(alias: alias, aliasType: aliasType), security: SecurityStruct(secret: secret, secretType: "4"))))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(auth) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Authentication Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Change PIN
extension RequestBody {
    static func changePin(oldSecretPin: String, newSecretPin: String) -> Data {
        let authToken = UserProfileUtilities.getAuthenticationToken()
        let pinData = ChangePinModel(changePasswordRequest: ChangePinModel.ChangePasswordRequest(consumerIdentification: ChangePinModel.ChangePasswordRequest.ConsumerIdentification(principal: "?", credential: "?"), authentication: ChangePinModel.ChangePasswordRequest.Authentication(token: authToken), OldSecret: ChangePinModel.ChangePasswordRequest.OldSecret(secretType: "4", secret: oldSecretPin), NewSecret: ChangePinModel.ChangePasswordRequest.NewSecret(secretType: "4", secret: newSecretPin)))
      let jsonEncoder = JSONEncoder()
        if let encodeData = try? jsonEncoder.encode(pinData) {
            if let json = String(data: encodeData, encoding: .utf8) {
                print("Encoded Json \(json)")
            }
            return encodeData
        }
        return Data()
    }
    static func generateOTP(aliasNumber: String) -> Data {
        let params = GenerateOTPRequestModel(generateOTPForPIN: .init(aliasNumber: aliasNumber))
        let jsonEncoder = JSONEncoder()
        if let encodeData = try? jsonEncoder.encode(params) {
            if let json = String(data: encodeData, encoding: .utf8) {
                print("Encoded Json \(json)")
            }
            return encodeData
        }
        return Data()
    }
    static func forgotPin(otp: String, alisaNumber: String, dateOfBirth: String) -> Data {
        let params = ForgotPINRequestModel(forgotPinRequest: .init(otp: otp, alisaNumber: alisaNumber, dateOfBirth: dateOfBirth))
        let jsonEncoder = JSONEncoder()
        if let encodeData = try? jsonEncoder.encode(params) {
            if let json = String(data: encodeData, encoding: .utf8) {
                print("Encoded Json \(json)")
            }
            return encodeData
        }
        return Data()
    }
    static func linkMobile(mobileNo: String, otp: String, token: String) -> Data {
        let params = LinkMobileRequestModel(linkMobileRequest: .init(consumerIdentification: ConsumerIdentification(), authentication: .init(token: token), otp: otp, mobileNumber: mobileNo))
        let jsonEncoder = JSONEncoder()
        if let encodeData = try? jsonEncoder.encode(params) {
            if let json = String(data: encodeData, encoding: .utf8) {
                print("Encoded Json \(json)")
            }
            return encodeData
        }
        return Data()
    }
    static func generateOTPForLinkMobile(mobileNo: String, token: String) -> Data {
        let params = GenrateOTPForLinkMobileRequestModel(generateOTPRequest: .init(consumerIdentification: ConsumerIdentification(), authentication:.init(token: token), mobileNumber: mobileNo))
        let jsonEncoder = JSONEncoder()
        if let encodeData = try? jsonEncoder.encode(params) {
            if let json = String(data: encodeData, encoding: .utf8) {
                print("Encoded Json \(json)")
            }
            return encodeData
        }
        return Data()
    }
}

// MARK: Get Member Dashboard

extension RequestBody {
    static func getMemberDashboard() -> Data {
         let authToken = UserProfileUtilities.getAuthenticationToken()
        let auth = GetMemberDashboardModel(getMemberDashboardRequest: GetMemberDashboardModel.GetMemberDashboardRequest(authentication: GetMemberDashboardModel.GetMemberDashboardRequest.Authentication(token: authToken), sendEnrollmentDetails: "YES"))
        let jsonEncoder = JSONEncoder()
        if let jsonEncodeData = try? jsonEncoder.encode(auth) {
            if let json = String(data: jsonEncodeData, encoding: .utf8) {
                print("MemberDashboard Encoded Json: \(json)")
            }
            return jsonEncodeData
            }
        return Data()
    }
}

// MARK: Update Memeber
// swiftlint:disable function_parameter_count
extension RequestBody {
    static func updateMemberDetails(params: UserProfileModel) -> Data {
        let userDetails = UserProfileUtilities.getUserDetails()
        
        let authToken = UserProfileUtilities.getAuthenticationToken()
        let firstName = params.FirstName ?? ""
        let lastName = params.LastName ?? ""
        let dob = params.DateOfBirth ?? ""
        let zipCode = params.ZipCode ?? ""
        let mobileNo = params.MobileNumber ?? ""
        let email = params.EmailAddress ?? ""
        let salutation = userDetails?.Salutation
        let city = params.addressSplitModel?.city ?? ""
        let region = params.addressSplitModel?.state ?? ""
        let address1 = params.addressSplitModel?.address1 ?? ""
        let address2 = params.addressSplitModel?.address2 ?? ""
        let extraAddress = ""
        
        let memberDetails = UpdateMemberModel(updateMemberRequest: UpdateMemberModel.UpdateMemberRequest(ConsumerIdentification: UpdateMemberModel.UpdateMemberRequest.ConsumerIdentification(consumerAuthentication: UpdateMemberModel.UpdateMemberRequest.ConsumerIdentification.ConsumerAuthentication(principal: "?", credential: "?"), deviceID: "0100"), Authentication: UpdateMemberModel.UpdateMemberRequest.Authentication(token: authToken), MasterInfo: UpdateMemberModel.UpdateMemberRequest.MasterInfo(salutation: salutation ?? "", firstName: firstName, lastName: lastName, dateOfBirth: dob), PostalAddress: UpdateMemberModel.UpdateMemberRequest.PostalAddress(zipCode: zipCode, city: city, region: region, additionalAddress1: address1, additionalAddress2: address2, extraAddress1: extraAddress), ContactInfo: UpdateMemberModel.UpdateMemberRequest.ContactInfo(MobileNumber: UpdateMemberModel.UpdateMemberRequest.ContactInfo.MobileNumber(number: mobileNo), EmailAddress: UpdateMemberModel.UpdateMemberRequest.ContactInfo.EmailAddress(address: email)), AddressValidation: UpdateMemberModel.UpdateMemberRequest.AddressValidation(postalAddressValidation: "2")))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(memberDetails) {
            
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Update Member Details Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// swiftlint:enable function_parameter_count

// MARK: Sign Out

extension RequestBody {
    static func getSignOut() -> Data {
        let authToken = UserProfileUtilities.getAuthenticationToken()
        if authToken == "" {
            return Data()
        }
        let auth = SignOutRequestModel(logoutRequest: SignOutRequestModel.LogoutRequest(authtoken: authToken))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(auth) {
            
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Sign Out Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: Keyboard Serach Pressed

extension RequestBody {
    
    static func getEarnMobileSearch(searchText: String, page: String, per_page: String, filter: [String: String], sortBy: String) -> Data {
        let mobileSearch = ProductListRequestModel.MobileSearch(data: .init(searchText: searchText, page: page, per_page: per_page, sortby: sortBy, filters: filter))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(mobileSearch) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Mobile Search Encoded Json: \(json)")
            }
            
            return encodedData
        }
        return Data()
    }
}

// MARK: My Order - Details

extension RequestBody {
    static func getMyOrder(token: String) -> Data {
        
        let requestBody = MyOrderRequestModel(getOrderListRequest: MyOrderRequestModel.GetOrderListRequest(memberAuthentication: MemberAuthentication(authenticationNumber: token, associationType: "TOKEN")))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("MyOrder Encoded Json: \(json)")
            }
            
            return encodedData
        }
        
        return Data()
    }
    static func getMyOrderDetails(orderBatchId: String, orderId: String) -> Data {
        let authToken = UserProfileUtilities.getAuthenticationToken()
        
        let requestBody = GetOrderDetailsRequestModel(GetOrderDetailsRequest: GetOrderDetailsRequestModel.GetOrderDetailsRequest(memberAuthentication: MemberAuthentication(authenticationNumber: authToken, associationType: "TOKEN"), lmsOrderDetails: LMSOrderDetails(orderBatchId: orderBatchId, OrderId: orderId), redeemChannel: "WEB"))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("MyOrder Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    
    static func getMyOrderStatus(orderBatchId: String, orderId: String) -> Data {
        let authToken = UserProfileUtilities.getAuthenticationToken()
        
        let requestBody = CheckOrderStatusRequestModel(checkOrderStatusRequest: CheckOrderStatusRequestModel.CheckOrderStatusRequest(memberAuthentication: MemberAuthentication(authenticationNumber: authToken, associationType: "TOKEN"), lmsOrderDetails: LMSOrderDetails(orderBatchId: orderBatchId, OrderId: orderId), redeemChannel: "WEB"))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("MyOrder Status Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: My Transaction
typealias TransactionFilerTuple = (brand: String, type: String, fromDate: String, toDate: String)
extension RequestBody {
    static func getMyTransaction(page: String, pageSize: String, filter: TransactionFilerTuple) -> Data {
       let authToken = UserProfileUtilities.getAuthenticationToken() 
        let requestBody = MyTransactionsRequestModel(filter: .init(partnerBrand: filter.brand, transactionType: filter.type, fromDate: filter.fromDate, toDate: filter.toDate), getAccountTransactionsRequest: MyTransactionsRequestModel.GetAccountTransactionsRequest(consumerIdentification: MyTransactionsRequestModel.GetAccountTransactionsRequest.ConsumerIdentification(consumerAuthentication: MyTransactionsRequestModel.GetAccountTransactionsRequest.ConsumerIdentification.ConsumerAuthentication(principal: "?", credential: "?")), authentication: MyTransactionsRequestModel.GetAccountTransactionsRequest.Authentication(token: authToken), pagination: MyTransactionsRequestModel.GetAccountTransactionsRequest.Pagination(page: page, pageSize: pageSize)))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("getMyTransaction Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Burn Product Details
extension RequestBody {
    static func getBurnProductDetails(productID: String) -> Data {
        
        let requestBody = BurnProductDetailsRequestModel(type: "rewardsProductDetails", searchType: "burn", data: BurnProductDetailsRequestModel.Data(skip: "0", limit: "10", productId: productID))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("getBurnProductDetails Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Earn Product Details
extension RequestBody {
    static func getEarnProductDetails(productID: String) -> Data {
        
        let requestBody = EarnProductDetailsRequestModel(type: "ProductDetails", data: EarnProductDetailsRequestModel.Data(id: productID))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("getEarnProductDetails Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: check PinCode
extension RequestBody {
    static func checkPinCode(pinCode: String, productId: String) -> Data {
        let requestBody = PinCodeCheckRequestModel(type: "rewardsPinCheck", data: PinCodeCheckRequestModel.Data(productID: productId, pincode: pinCode))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("checkPinCode Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: Stock check Count
extension RequestBody {
    static func stockCheck(productId: String) -> Data {
        let requestBody = StockCheckRequestModel(type: "rewardsStockcheck", productID: productId)
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Stock Check Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Delivery Address
extension RequestBody {
    static func getDeliveryAddress(userid: String) -> Data {
        let requestBody = DeliveryAddressRequestModel(viewDeliveryAddressRequest: .init(userid: userid))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("delivery address Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    
    static func addDeliveryAddress(userid: String, data: AddressSplitCellModel) -> Data {
        let requestBody = InsertDeliveryAddressRequestModel(createDeliveryAddressRequest: .init(userid: userid, address: data))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("delivery address Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    
    static func updateDeliveryAddress(userid: String, data: AddressSplitCellModel) -> Data {
        let requestBody = UpdateDeliveryAddressRequestModel(updateDeliveryAddressRequest: .init(userid: userid, address: data))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("delivery address Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    
    static func deleteDeliveryAddress(userid: String, id: String) -> Data {
        let requestBody = DeleteDeliveryAddressRequestModel(deleteDeliveryAddressRequest: .init(userid: userid, id: id))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("delivery address Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: ShopOnline - TopTrend

extension RequestBody {
    static func getTopTrendParams(params: ShopOnlineProductParamsModel) -> Data {
        let requestBody = TopTrendRequestModel(type: "ActiveDeals", data: .init(type: "trending", page: params.page, per_page: params.per_page, sortby: params.sortBy, filters: params.filter))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Top Trend Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func getShopOnlineCategoriesProductList(params: ShopOnlineProductParamsModel) -> Data {
        let requestBody = TopTrendRequestModel(type: "ShoponlineProductListByCategory", data: .init(id: params.id, page: params.page, per_page: params.per_page, sortby: params.sortBy, filters: params.filter))
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("ShopOnlineCategories Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// Create Order
extension RequestBody {
    static func getCreateOrder(shipmentInfo: AddressSplitCellModel, productInfo: CreateOrderProductInfoModel) -> Data {
        let userId = UserProfileUtilities.getUserID()
        let sessionId = "\(NSDate())"
        let randomNumberFourteenDigit = Utilities.generateRandom_FourteenDigits()
        let randomNumberFourDigit = Utilities.generateRandom_FourDigits()
        
        let partnerOrderBatchId = "1101-" + "\(randomNumberFourteenDigit)"
        let partnerId = partnerOrderBatchId + "_\(randomNumberFourDigit)"
        
        let authToken = UserProfileUtilities.getAuthenticationToken()
        
        var totalPoints = ""
        var point = ""
        var unitPrice = ""
        if let unitprice = productInfo.UnitPrice {
            unitPrice = "\(unitprice)"
            totalPoints = "\(unitprice * productInfo.Quantity)"
        } else if let points = productInfo.points {
            point = "\(points)"
            totalPoints = "\(points * productInfo.Quantity)"
        }
        
        let orderItem = [OrderItem(PartnerOrderId: partnerId, ItemId: productInfo.ItemId, ItemName: productInfo.ItemName, Quantity: "\(productInfo.Quantity)", UnitPrice: unitPrice, Points: point, OrderStatus: productInfo.OrderStatus, ItemType: productInfo.ItemType, SkuCode: productInfo.SkuCode)]
        
        let shipmentInfo = ShipmentInfo(ShipmentSenderName: shipmentInfo.name ?? "", Email: shipmentInfo.emailid ?? "", Mobile: shipmentInfo.mobile ?? "", AddressLine1: shipmentInfo.address1 ?? "", AddressLine2: shipmentInfo.address2 ?? "", City: shipmentInfo.city ?? "", State: shipmentInfo.state ?? "", ZipCode: shipmentInfo.pin ?? "")
        
        let requestBody = CreateOrderRequestModel(orderRequest: .init(MemberAuthentication: MemberAuthentication(authenticationNumber: authToken), PartnerOrderBatchId: partnerOrderBatchId, OrderItem: orderItem, TotalCashAmount: "0", TotalPoints: totalPoints, TotalValue: "0", ShipmentInfo: shipmentInfo, SourceIPAddress: ""), userId: userId, sessionId: sessionId)
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Create Order Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: Notification
extension RequestBody {
    static func getNotification(userId: String) -> Data {
        let requestBody = NotificationRequestModel(viewUserNotification: .init(userId: userId))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("Notification Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: Cart
extension RequestBody {
    static func getAddToCart(quantity: String, productId: String) -> Data {
        let userId = UserProfileUtilities.getUserID()
        
        let requestBody = AddToCartRequestModel(type: "AddorUpdateCart", cartId: userId, data: .init(productId: productId, quantity: quantity, amexEmail: "", amexMobile: ""))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("AddToCart Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: Cart
extension RequestBody {
    static func getShopOnlineCategory() -> Data {
        let params = ["type": "ShoponlineCategoryList"]
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(params) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("ShopOnlineCategory Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: Wish List
extension RequestBody {
    static func addWishListForShopOnline(userEmail: String, productInfo: ProductInfo) -> Data {
        let requestBody = WishListAddRequestModel(data: .init(withEmail: userEmail, productInfo: productInfo))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("AddWishListForShopOnline Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func addWishListForRewards(requestBody: RewardsAddWishListRequestModel) -> Data {
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("AddWishListForRewards Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func getCombineWishList(userEmail: String, userId: String) -> Data {
        let requestBody = WishListRequestModel(data: .init(withEmail: userEmail, userId: userId))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("getWishListForShopOnline Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func deleteWishListForShopOnline(userEmail: String, productId: String) -> Data {
        let requestBody = WishListDeleteRequestModel(data: .init(withEmail: userEmail, productId: productId))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("deleteWishListForShopOnline Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func deleteWishListForRewards(userId: String, wishlistId: String) -> Data {
        let requestBody = RewardsWishListDeleteRequestModel(data: .init(withWishListId: wishlistId, userId: userId))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("deleteWishListForReward Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
// MARK: Online Offers
extension RequestBody {
    static func onlineOffers(page: String, per_page: String = "10", filer: [String: String]) -> Data {
         let requestBody = TopTrendRequestModel(type: "OfferZone", data: .init(page: page, per_page: per_page, sortby: "", filters: filer))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("onlineOffers Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func couponsCategory() -> Data {
        let requestBody = ["type": "couponCategories"]
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("couponsCategory Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
    static func coupons(page: String, per_page: String = "10", filer: [String: String]) -> Data {
        let requestBody = CouponsRequestModel(type: "AllCoupons", data: .init(page: page, per_page: per_page, filters: filer))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("coupons Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}

// MARK: InStore List
extension RequestBody {
    static func instoreList(type: String, data: InStoreListRequestModel.Data ) -> Data {
        
        let requestBody = InStoreListRequestModel(type: type, data: .init(latitude: data.latitude, longitude: data.longitude, category: data.category, partner: data.partner, city: data.city))
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("InStoreList Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
extension RequestBody {
    static fileprivate func encrypt(body: Data) -> Data {
        if let personDictionary = try? JSONSerialization.jsonObject(with: body, options: .allowFragments) as? [String: Any] {
            let secret = "secret"
            let algorithmName = "HS256"
            let algorithm = JWTAlgorithmFactory.algorithm(byName: algorithmName)
            let result = JWTBuilder.encodePayload(personDictionary).secret(secret)?.algorithm(algorithm)?.encode
            
            let payLoad = ["payloadbody": result]
            let jsonEncoder = JSONEncoder()
            if let encodedData = try? jsonEncoder.encode(payLoad) {
                if let json = String(data: encodedData, encoding: .utf8) {
                    print("Encoded Json: \(json)")
                }
                return encodedData
            }
        }
        return Data()
    }
}

// MARK: Voucher World
extension RequestBody {
    static func getVoucherWorld(token: String) -> Data {
        let requestBody = VoucherWorldRequestModel(authToken: token)
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(requestBody) {
            if let json = String(data: encodedData, encoding: .utf8) {
                print("MyOrder Encoded Json: \(json)")
            }
            return encodedData
        }
        return Data()
    }
}
