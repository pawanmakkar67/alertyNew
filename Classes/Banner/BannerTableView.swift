//
//  BannerTableView.swift
//  SalusMea
//
//  Created by Viking on 2021. 02. 10..
//

import UIKit

@objc enum BannerType: Int {
    case Network
    case Mandown
    case HomeAlarm
    case Timer
    case FollowMe
    case FollowMeAccepted
    case Alert
    case FollowMeReceived
}

@objc protocol BannerTableViewDelegate {
    func showFollowing()
    func cancelFollowMe()
}

class BannerTableView: UITableView {

    class Banner: NSObject {
        var type: BannerType?
        var title: String?
        var alertInfo: AlertInfo?
    }
    
    private var banners = [Banner]()
    @objc var bannerDelegate: BannerTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        register(UINib.init(nibName: "BannerCell", bundle: nil), forCellReuseIdentifier: "BannerCell")
        delegate = self
        dataSource = self
    }
    
    @objc func setBannerVisible(type: BannerType, visible: Bool, title: String?) {
        
        if visible {
            for banner in banners {
                if banner.type == type {
                    return
                }
            }
            isHidden = false
            let banner = Banner.init()
            banner.type = type
            banner.title = title
            banners.insert(banner, at: 0)
            invalidateIntrinsicContentSize()
            beginUpdates()
            insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
            endUpdates()
            
        } else {
            
            for i in 0..<banners.count {
                let banner = banners[i]
                if banner.type == type {
                    banners.remove(at: i)
                    beginUpdates()
                    deleteRows(at: [IndexPath.init(row: i, section: 0)], with: .fade)
                    endUpdates()
                    //[self performSelector:@selector(updateBannerHeight) withObject:nil afterDelay:1.0];
                    invalidateIntrinsicContentSize()
                    break
                }
            }
        }
    }
    
    @objc func addAlarmBanner(alertInfo: AlertInfo, title: String?) {
        isHidden = false
        let banner = Banner.init()
        banner.type = .Alert
        banner.alertInfo = alertInfo
        banner.title = title
        banners.insert(banner, at: 0)
        invalidateIntrinsicContentSize()
        beginUpdates()
        insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
        endUpdates()
    }
    
    @objc func removeAlarmBanner(alertId: Int) {
        for i in 0..<banners.count {
            let banner = banners[i]
            if banner.type == .Alert {
                if alertId == banner.alertInfo?.alertId {
                    banners.remove(at: i)
                    beginUpdates()
                    deleteRows(at: [IndexPath.init(row: i, section: 0)], with: .fade)
                    endUpdates()
                    //[self performSelector:@selector(updateBannerHeight) withObject:nil afterDelay:1.0];
                    invalidateIntrinsicContentSize()
                    break
                }
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: 100, height: self.banners.count * 44)
        //self.bannerTableView.hidden = !self.banners.count;
    }
    
    @objc func updateTimer() {
        let date = AlertySettingsMgr.timer()
        setBannerVisible(type: .Timer, visible:(date != nil && date!.timeIntervalSinceNow > 0), title: nil)
    }
    @objc func updateHomeTimer() {
        let date = AlertySettingsMgr.homeTimer()
        setBannerVisible(type: .HomeAlarm, visible:(date != nil) , title: nil)
    }
    
    @objc func closeTimer() {
        AlertySettingsMgr.setTimer(nil)
        updateTimer()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        AlertyAppDelegate.shared()?.mainController?.addTimer(nil)
    }
    @objc func closeHomeTimer() {
//        AlertySettingsMgr.sethomeTimer(nil)
        updateHomeTimer()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        AlertyAppDelegate.shared()?.mainController?.addTimer(nil)
    }
    @objc func closeAlert() {
//        AlertySettingsMgr.sethomeTimer(nil)
        updateHomeTimer()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        AlertyAppDelegate.shared()?.mainController?.addTimer(nil)
    }

}

extension BannerTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let banner = banners[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.alertText = banner.title
        cell.type = banner.type
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let banner = banners[indexPath.row]
        if banner.type == .Alert {
            AlertyAppDelegate.shared()?.showAlert(banner.alertInfo!, openAlert: true)
        } else if banner.type == .FollowMeReceived {
            bannerDelegate?.showFollowing()
        }
    }
}

extension BannerTableView: BannerCellDelegate {
    
    func closePressed(type: BannerType?) {
        if type == .Timer {
            closeTimer()
        } 
        if type == .HomeAlarm {
            closeHomeTimer()
        }
        if type == .Alert {
//            closeHomeTimer()
        }
        else if type == .Mandown {
            AlertyAppDelegate.shared()?.stopManDown()
        } else if type == .FollowMe || type == .FollowMeAccepted {
            bannerDelegate?.cancelFollowMe()
        }
    }
}
