//
//  AlertManager.swift
//  Alerty
//
//  Created by Viking on 2021. 04. 12..
//

import Foundation

@objc protocol AlertManagerPresenter {
    func addAlarmBanner(alertInfo: AlertInfo)
    func removeAlarmBanner(alertInfo: AlertInfo)
}

class AlertInfo: NSObject {
    
    @objc var alertId: Int
    @objc var alertUserId: String?
    @objc var userName: String?
    @objc var message: String?
    @objc var roomName: String?
    @objc var token: String?
    
    init(alertId: Int, alertUserId: String?, userName: String?, message: String?, roomName: String?, token: String?) {
        self.alertId = alertId
        self.alertUserId = alertUserId
        self.userName = userName
        self.message = message
        self.roomName = roomName
        self.token = token
    }
}

class AlertManager: NSObject {
    
    private var alerts = [AlertInfo]()
    private var timer: Timer?
    private var timerIndex = 0
    
    @objc var delegate: AlertManagerPresenter?
    
    @discardableResult
    @objc func addAlert(alertId: Int, alertUserId: String?, userName: String?, message: String?, roomName: String?, token: String?) -> AlertInfo? {
        if let alertInfo = getAlert(alertId: alertId) {
            return alertInfo
        } else {
            let alert = AlertInfo(alertId: alertId, alertUserId: alertUserId, userName: userName, message: message, roomName: roomName, token: token)
            alerts.append(alert)
            delegate?.addAlarmBanner(alertInfo: alert)
            
            if timer == nil {
                timerIndex = 0
                timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkAlert(timer:)), userInfo: nil, repeats: true)
            }
            return alert
        }
    }
    
    func getAlert(alertId: Int) -> AlertInfo? {
        for alertInfo in alerts {
            if alertInfo.alertId == alertId {
                return alertInfo
            }
        }
        return nil
    }
    
    func hasAlert(alertId: Int) -> Bool {
        for alertInfo in alerts {
            if alertInfo.alertId == alertId {
                return true
            }
        }
        return false
    }
    
    @objc func checkAlert(timer: Timer) {

        let alertInfo = alerts[timerIndex]
        MobileInterface.post(ALERTINFOCALL_URL, body: ["id": alertInfo.alertId]) { (result, errorMessage) in
            
            if let info = result?["alertinfo"] as? [String: Any] {
                if let closed = info["closed"] as? String {
                    if closed.count > 0 {
                        
                        OperationQueue.main.addOperation {
                            self.delegate?.removeAlarmBanner(alertInfo: alertInfo)
                        }
                        self.alerts.remove(at: self.timerIndex)
                        
                        if self.alerts.count == 0 {
                            self.timer?.invalidate()
                            self.timer = nil
                        } else {
                            self.timerIndex = 0
                        }
                        return
                    }
                }
            }
            self.timerIndex = (self.timerIndex + 1) % self.alerts.count
        }
    }
    
}
