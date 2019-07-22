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
    private lazy var _batteryLabel: UILabel = {
        let label = UILabel()
        label.textColor = ReadConfig.default.fontColor
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    private lazy var _timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = ReadConfig.default.fontColor
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    // MARK: - Initial Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(_batteryLabel)
        _batteryLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(kIsPhoneX ? -40 : -15)
            make.centerY.equalTo(self)
        }
        
        addSubview(_timeLabel)
        _timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(kIsPhoneX ? 40 : 15)
            make.centerY.equalTo(self)
        }

        // 电量监控
        UIDevice.current.isBatteryMonitoringEnabled = true
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(p_batteryDidChanged(_:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        _batteryLabel.text = "\(Int(UIDevice.current.batteryLevel*100))%"
        
        p_refreshTime()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        p_refreshTime()
    }
    
    // MARK - Private Methods
    private func p_refreshTime() {
        _timeLabel.text = MSTTools.formatTimeRightNow(format: "hh:mm")
    }
    
    // MARK: - Actions
    @objc private func p_batteryDidChanged(_ noti: Notification) {
        let device = noti.object as! UIDevice
        _batteryLabel.text = "\(Int(device.batteryLevel*100))%"
    }
    
}
