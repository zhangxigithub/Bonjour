//
//  ViewController.swift
//  demo
//
//  Created by zhangxi on 12/25/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController,UITextFieldDelegate,BonjourDelegate {

    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Bonjour.sharedBonjour.delegate = self
        Bonjour.sharedBonjour.bonjour()
        
        
        addMessage("我是\(UIDevice.currentDevice().name)")
        
        

        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification:NSNotification) -> Void in
            
            if let endRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            {
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.bottomConstraint.constant = self.view.frame.size.height - endRect.origin.y + 8

                    self.view.layoutIfNeeded()
                })
            }
            
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification:NSNotification) -> Void in
            
            if let endRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            {
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.bottomConstraint.constant =  self.view.frame.size.height - endRect.origin.y + 8
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField.text != nil
        {
            addMessage("[我]:\(textField.text!)")
            Bonjour.sharedBonjour.sendMessage(textField.text!)
            textField.text = ""
        }

        return true
    }
    
    
    func didReceiveMessage(message: String,peerID:MCPeerID) {
        addMessage("[\(peerID.displayName)]:\(message)")
    }
    func didConnectPeer(peerID: MCPeerID) {
        addMessage("连接到 \(peerID.displayName)")
    }
    func didDisconnectPeer(peerID: MCPeerID) {
        addMessage("失去连接 \(peerID.displayName)")
    }
    
    
    
    
    
    func addMessage(message:String)
    {
        self.textView.text =  self.textView.text.stringByAppendingFormat("%@\n", message)
    }
}

