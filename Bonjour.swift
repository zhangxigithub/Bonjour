//
//  AppDelegate.swift
//  demo
//
//  Created by zhangxi on 12/25/15.
//  Copyright © 2015 http://zhangxi.me. All rights reserved.
//

import UIKit
import MultipeerConnectivity



let BonjourDidConnectPeerNotification    = "BonjourDidConnectPeerNotification"
let BonjourDidDisconnectPeerNotification = "BonjourDidDisconnectPeerNotification"
let BonjourDidReceiveMessageNotification = "BonjourDidReceiveMessageNotification"

let BonjourNotificationPeerKey           = "BonjourNotificationPeerKey"
let BonjourNotificationMessageKey        = "BonjourNotificationMessageKey"



@objc protocol BonjourDelegate
{
    optional func didConnectPeer(peerID:MCPeerID)
    optional func didDisconnectPeer(peerID:MCPeerID)
    optional func didReceiveMessage(message:String,peerID:MCPeerID)
}



class Bonjour: NSObject,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate{
    
    
    static let sharedBonjour: Bonjour = {
        return Bonjour()
    }()
    
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
            peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
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
    
    func sendMessage(message:String,mode:MCSessionSendDataMode = MCSessionSendDataMode.Reliable)
    {
        do {
            let data = message.dataUsingEncoding(NSUTF8StringEncoding)!
            try session.sendData(data, toPeers:session.connectedPeers, withMode: mode)
        }
        catch
        {
        }
    }

    

    //MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void)
    {
        invitationHandler(true,session)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError)
    {
    }
    
    
    
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
                NSNotificationCenter.defaultCenter().postNotificationName(BonjourDidDisconnectPeerNotification, object: nil, userInfo: [BonjourNotificationPeerKey : peerID])
            }
        case .Connecting:
            break
        case .Connected:
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.delegate?.didConnectPeer?(peerID)
                NSNotificationCenter.defaultCenter().postNotificationName(BonjourDidConnectPeerNotification, object: nil, userInfo: [BonjourNotificationPeerKey : peerID])
            }

        }
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID)
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
           
            if let message = String(data: data, encoding: NSUTF8StringEncoding)
            {
                self.delegate?.didReceiveMessage?(message, peerID: peerID)
                NSNotificationCenter.defaultCenter().postNotificationName(BonjourDidConnectPeerNotification, object: nil, userInfo: [BonjourNotificationPeerKey : peerID,BonjourNotificationMessageKey:message])
            }
        }

    }
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress)
    {
    }
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?)
    {
    }

}
