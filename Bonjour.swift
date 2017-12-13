//
//  AppDelegate.swift
//  demo
//
//  Created by zhangxi on 12/25/15.
//  Copyright © 2015 http://zhangxi.me. All rights reserved.
//

import UIKit
import MultipeerConnectivity



let BonjourNotificationPeerKey           = "BonjourNotificationPeerKey"
let BonjourNotificationMessageKey        = "BonjourNotificationMessageKey"



protocol BonjourDelegate
{
    func didConnectPeer(peerID:MCPeerID)
    func didDisconnectPeer(peerID:MCPeerID)
    func didReceiveMessage(message:String,peerID:MCPeerID)
    func didLost(peerID:MCPeerID)
}



class Bonjour : NSObject,MCSessionDelegate,MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate
{
    var delegate:BonjourDelegate?
    
    
    var advertisier:MCNearbyServiceAdvertiser!
    var browser:MCNearbyServiceBrowser!
    var session:MCSession!
    
    
    var peerID : MCPeerID?
    let serviceType = "zx-bonjour"
    
    func bonjour(name:String? = nil)
    {
        
        if name == nil
        {
            peerID = MCPeerID(displayName: UIDevice.current.name)
        }else
        {
            peerID = MCPeerID(displayName: name!)
        }
        
        
        browser = MCNearbyServiceBrowser(peer: peerID!, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        
        advertisier  = MCNearbyServiceAdvertiser(peer: peerID!, discoveryInfo: nil, serviceType: serviceType)
        advertisier.delegate = self
        advertisier.startAdvertisingPeer()
        
        
        
        session = MCSession(peer: peerID!)
        session.delegate = self
    }
    
    func sendMessage(message:String,mode:MCSessionSendDataMode = MCSessionSendDataMode.reliable)
    {
        do {
            if let data = message.data(using: .utf8)
            {
                try session.send(data, toPeers: session.connectedPeers, with: mode)
            }
        }
        catch{}
    }

    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 20)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.didLost(peerID: peerID)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    
        invitationHandler(true,session)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let message = String(data: data, encoding: .utf8)
            {
                self.delegate?.didReceiveMessage(message: message, peerID: peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
    }

}


 /*
    
    //MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    {
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 20)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 20)
    }
    
    
    
    //MARK: - MCSessionDelegate
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState)
    {
        switch state
        {
        case .NotConnected:

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.delegate?.didDisconnectPeer?(peerID)
            }
        case .Connecting:
            break
        case .Connected:
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.delegate?.didConnectPeer?(peerID)
            }

        }
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
           
            if let message = String(data: data, encoding: NSUTF8StringEncoding)
            {
                self.delegate?.didReceiveMessage?(message, peerID: peerID)
            }
        }

    }

*/

