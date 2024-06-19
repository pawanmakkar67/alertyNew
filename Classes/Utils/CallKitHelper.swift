//
//  CallKitHelper.swift
//  Alerty
//
//  Created by Viking on 2021. 08. 30..
//

import UIKit
import CallKit

@objc class CallKitHelper: NSObject {

    private var callController = CXCallController()
    private var provider: CXProvider?
    private var uuid: UUID?
    private static var _instance: CallKitHelper?
    
    @objc static var instance: CallKitHelper {
        if _instance == nil {
            _instance = CallKitHelper()
        }
        return _instance!
    }
        
    @objc func startOutgoingAlert() {
        
        let config = CXProviderConfiguration(localizedName: "Alerty")
        provider = CXProvider.init(configuration: config)
        provider?.setDelegate(self, queue: nil)
        
        let handle = CXHandle(type: .generic, value: "Larmportal")
        uuid = UUID()
        let startCallAction = CXStartCallAction(call: uuid!, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    @objc func reportOutgoingCallConnected() {
        if let uuid = uuid {
            provider?.reportOutgoingCall(with: uuid, connectedAt: nil)
        }
    }
    
    @objc func reportOutgoingCallEnded() {
        /*if let uuid = uuid {
            provider?.reportCall(with: uuid, endedAt: Date(), reason: .answeredElsewhere)
        }*/
        provider?.invalidate()
        uuid = nil
    }
    
}

extension CallKitHelper: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        /**
         Configure the audio session, but do not start call audio here, since it must be done once
         the audio session has been activated by the system after having its priority elevated.
         */
        //CallAudio.configureAudioSession()
        action.fulfill()
    }
}
