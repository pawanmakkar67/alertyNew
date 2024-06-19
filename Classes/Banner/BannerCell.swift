//
//  BannerCell.swift
//  SalusMea
//
//  Created by Viking on 2021. 02. 10..
//

import Foundation
import UIKit

protocol BannerCellDelegate {
    func closePressed(type: BannerType?)
}

class BannerCell: UITableViewCell {
    
    @IBOutlet weak var bannerIcon: UIImageView!
    @IBOutlet weak var bannerText: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var type: BannerType? {
        didSet {
            counterLabel.text = ""
            timer?.invalidate()
            timer = nil
            if type == .Mandown {
                bannerIcon.image = UIImage.init(named: "banner_mandown")
                bannerText.text = NSLocalizedString("Man down is enabled", comment: "")
                selectionStyle = .none
            } else if type == .FollowMe {
                bannerIcon.image = UIImage.init(named: "banner_mandown")
                if let alertText = alertText {
                    bannerText.text = NSLocalizedString("FOLLOW_ME_WAITING", comment: "") + alertText
                } else {
                    bannerText.text = NSLocalizedString("Follow me is active", comment: "Follow me is active")
                }
                selectionStyle = .none
            } else if type == .FollowMeAccepted {
                bannerIcon.image = UIImage.init(named: "banner_mandown")
                if alertText != nil && alertText!.count > 0 {
                    bannerText.text = alertText! + NSLocalizedString("FOLLOW_ME_FOLLOWING", comment:"")
                } else {
                    bannerText.text = NSLocalizedString("Follow me has a follower!", comment: "Follow me has a follower!")
                }
            } else if type == .FollowMeReceived {
                bannerText.text = NSLocalizedString("FOLLOW_ME_FOLLOWER", comment: "") + (alertText != nil ? alertText! : "")
                selectionStyle = .default
                closeButton.isHidden = true
            } 
            
            else if type == .Timer {
                bannerIcon.image = UIImage.init(named: "banner_timer")
                bannerText.text = NSLocalizedString("Timer is active!", comment: "")
                selectionStyle = .none
                updateTime()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            }
            else if type == .HomeAlarm {
                bannerIcon.image = UIImage.init(named: "banner_timer")
                bannerText.text = NSLocalizedString("Home Alarm is active!", comment: "")
                selectionStyle = .none
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "HH:mm"

                let newDateString = outputFormatter.string(from: AlertySettingsMgr.homeTimer() ?? Date())
                closeButton.isHidden = true
                counterLabel.text = newDateString
            }
            else if type == .Network {
                bannerIcon.image = nil
                bannerText.text = NSLocalizedString("Network is not available!", comment: "") + (alertText != nil ? alertText! : "")
                selectionStyle = .none
            } else if type == .Alert {
                bannerIcon.image = nil;
                bannerText.text = alertText
                selectionStyle = .default
                closeButton.isHidden = true
                
                let labelSize = bannerText.sizeThatFits(CGSize.init(width: 1000, height: 1000))
                if labelSize.width > UIScreen.main.bounds.size.width - 20 {
                    perform(#selector(animateRight), with: nil, afterDelay: 2.0)
                }
            }
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    var alertText: String?
    var delegate: BannerCellDelegate?
    
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        delegate?.closePressed(type: type)
    }
    
    @objc func updateTime() {
        var seconds = Int(AlertySettingsMgr.timer()?.timeIntervalSinceNow ?? 0)
        if seconds < 0 {
            timer?.invalidate()
            timer = nil
        } else {
            var minutes = seconds / 60
            let hours = minutes / 60
            minutes = minutes % 60
            seconds = seconds % 60
            if hours > 0 {
                counterLabel.text = String.init(format: "%02d:%02d", hours, minutes)
            } else {
                counterLabel.text = String.init(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
    
    @objc func animateRight() {
        OperationQueue.main.addOperation {
            let labelSize = self.bannerText.sizeThatFits(CGSize.init(width: 1000, height: 1000))
            self.scrollView.setContentOffset(CGPoint(x: labelSize.width - UIScreen.main.bounds.size.width + 30, y: 0), animated: true)
        }
        perform(#selector(animateLeft), with: nil, afterDelay: 3.0)
     }
    
    @objc func animateLeft() {
        OperationQueue.main.addOperation {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        perform(#selector(animateRight), with: nil, afterDelay: 3.0)
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        closeButton.isHidden = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(animateLeft), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(animateRight), object: nil)
        timer?.invalidate()
        timer = nil
    }
}
