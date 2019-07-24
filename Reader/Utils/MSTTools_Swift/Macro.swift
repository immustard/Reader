//
// Created by 张宇豪 on 2019-07-05.
// Copyright (c) 2019 张宇豪. All rights reserved.
//

import UIKit

// MARK: - device
var kIsPhoneX: Bool {
    return MSTTools.isIphoneX()
}


// MARK: - screen
var kScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var kScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var kNavHeight: CGFloat {
    return kIsPhoneX ? 88 : 64
}

var kTabHeight: CGFloat {
    return kIsPhoneX ? 83 : 49
}

var kStatusHeight: CGFloat {
    return kIsPhoneX ? 44 : 20
}


// MARK: - color
var kBgColor: UIColor {
    return UIColor.mst_colorWithHexString("F3F4F5")
}

var kBgLightColor: UIColor {
    return UIColor.mst_colorWithHexString("FCFCFC")
}

var kColor333: UIColor {
    return UIColor.mst_colorWithHexString("333333")
}

var kColor666: UIColor {
    return UIColor.mst_colorWithHexString("666666")
}

var kColor999: UIColor {
    return UIColor.mst_colorWithHexString("999999")
}

var kColorCCC: UIColor {
    return UIColor.mst_colorWithHexString("cccccc")
}

var kColorRandom: UIColor {
    return UIColor.mst_random();
}
