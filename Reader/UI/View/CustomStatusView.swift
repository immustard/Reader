//
//  CustomStatusView.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/19.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class CustomStatusView: UIView {

    // MARK: - Properties
    lazy var _batteryLabel: UILabel = {
        let label = UILabel()
        label.textColor = ReadConfig.default.fontColor
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    // MARK: - Initial Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        addSubview(_batteryLabel)
        _batteryLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(-40)
            make.centerY.equalTo(self)
        }

        // 电量监控
        UIDevice.current.isBatteryMonitoringEnabled = true
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(p_batteryDidChanged(_:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        _batteryLabel.text = "\(Int(UIDevice.current.batteryLevel*100))%"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func p_batteryDidChanged(_ noti: Notification) {
        let device = noti.object as! UIDevice
        _batteryLabel.text = "\(Int(device.batteryLevel*100))%"

    }
    
}
