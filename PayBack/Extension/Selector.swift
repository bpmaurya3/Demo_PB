//
//  Selector.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 6/20/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import UIKit

extension Selector {
    static let tapGestureActionForAlertCouponPopUp =
        #selector(AlertCouponPopUp.tapGestureAction(sender:))
    static let tapGestureActionForAlertPopUp =
        #selector(AlertPopUp.tapGestureAction(sender:))
    static let tapGestureActionForFeedBackAlertPopUp = #selector(FeedBackAlertPopUp.tapGestureAction(sender:))
    static let tapGestureActionForPasswordPopUp = #selector(PasswordPopUp.tapGestureAction(sender:))
    static let editingChangeActionForPasswordPopUp = #selector(PasswordPopUp.editingChangeAction(_:))
    static let tappedTextViewForPasswordPopUp = #selector(PasswordPopUp.tappedTextView(tapGesture:))
    static let doneClickForPasswordPopUp = #selector(PasswordPopUp.doneClick)
    static let datePickerValueChangedForPasswordPopUp = #selector(PasswordPopUp.datePickerValueChanged)
    static let checkUncheckForForSortByTVCell = #selector(SortByTVCell.checkUncheck(_:))
    static let backClickedForDesignableNav = #selector(DesignableNav.backClicked)
    static let hideKeyboardForUITableView = #selector(UITableView.hideKeyboard)
    static let viewAllForHomeShowCaseTVCell = #selector(HomeShowCaseTVCell.viewAllClicked)
    static let viewAllForShowCaseCategoryTVCell = #selector(ShowCaseCategoryTVCell.viewAllClicked)
    static let viewAllForShopClickTVCell = #selector(ShopClickTVCell.viewAllClicked)
    static let viewAllForTopTrendTVCell = #selector(TopTrendTVCell.viewAllClicked)
    static let addCollectionViewLayerForTopTrend = #selector(TopTrendTVCell.addColectionViewLayer)

}
