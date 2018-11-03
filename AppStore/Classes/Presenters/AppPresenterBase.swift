//
//  AppDetailPresenter.swift
//  AppStore
//
//  Created by Damien Bivaud on 02/11/2018.
//  Copyright © 2018 Damien Bivaud. All rights reserved.
//

import Foundation

struct AppDetailViewData
{
    let icon : String?
    let title : String?
    let description : String?
    let price : String?
    let appStoreURL : String?
    let inapps : Bool?
}

class AppPresenterBase
{
    internal func _createAppDetailViewData(app : AppDetails) -> AppDetailViewData?
    {
        var appViewData : AppDetailViewData?
        if let icon = app.storeInfo?.icon, let title = app.storeInfo?.title, let description = app.storeInfo?.description, let in_apps = app.storeInfo?.features?[AppDetails.StoreInfo.Feature.in_apps]
        {
            var appStoreURL : String?
            if let locale = Locale.current.regionCode, let slug = app.storeInfo?.slug, let app_id = app.application_id
            {
                appStoreURL = getAppStoreAppURL(country: locale, name: slug, id: String(app_id))
            }
            appViewData = AppDetailViewData(icon: icon, title: title, description: description, price: app.storeInfo?.price, appStoreURL: appStoreURL, inapps: in_apps)
        }
        return appViewData
    }
}
