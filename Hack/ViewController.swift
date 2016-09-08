//
//  ViewController.swift
//  Hack
//
//  Created by Alexey Demedetskii on 9/8/16.
//  Copyright © 2016 thebestteamevermade. All rights reserved.
//

import UIKit
import Moscapsule

class ViewController: UIViewController {

    @IBOutlet var backCameraView: UIView!
    @IBOutlet var frontCameraView : UIView!
    
    var queue = NSOperationQueue()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let frontImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        frontImageView.layer.anchorPoint =
            CGPoint(x: 382.0 / 640.0, y: 239.0 / 480.0)
        frontImageView.frame.origin = CGPoint(x: -382 + 100, y: -280)
        frontCameraView.addSubview(frontImageView)
        
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        backImageView.layer.anchorPoint =
            CGPoint(x: 382.0 / 640.0, y: 239.0 / 480.0)
        backImageView.transform = CGAffineTransformMakeRotation(.init(M_PI))
        backImageView.frame.origin = CGPoint(x: -382 + 100, y: -280)
        backCameraView.addSubview(backImageView)
        
        let alert = UIAlertController(
            title: "Connect",
            message: "Enter IP Adress",
            preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler {
            $0.text = "192.168.1.100"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in
            guard let text = alert.textFields?.first?.text else { fatalError() }
            
            let mqttConfig = MQTTConfig(clientId: "test", host: text, port: 1883, keepAlive: 60)
            self.client = MQTT.newConnection(mqttConfig)
            
            let op = FeedQueueOperation(address: text) { image in
                dispatch_async(dispatch_get_main_queue(), {
                    frontImageView.image = image
                    backImageView.image = image
                })
            }
            
            self.queue.addOperation(op)
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    var client: MQTTClient?
   
    func updateWheels() {
        let command = "{\"Left\":\(wheelSpeed.left), \"Right\":\(wheelSpeed.right)}"
        client?.publishString(command, topic: "command/wheel_speed", qos: 0, retain: true)
    }
    
    @IBOutlet var leftWheelLabel: UILabel! {
        didSet { leftWheelLabel.text = String(wheelSpeed.left) }
    }
    
    @IBOutlet var rightWheelLabel: UILabel! {
        didSet { rightWheelLabel.text = String(wheelSpeed.right) }
    }
    
    struct Wheel {
        var left = 0, right = 0
    }
    
    var wheelSpeed = Wheel() {
        didSet {
            leftWheelLabel.text = String(wheelSpeed.left)
            rightWheelLabel.text = String(wheelSpeed.right)
            
            updateWheels()
        }
    }
    
    @IBAction func updateLeftWheel(recognizer: UIPanGestureRecognizer) {
        
        guard case .Changed = recognizer.state else { return wheelSpeed.left = 0 }
        
        let y = recognizer.locationInView(recognizer.view).y
        let value = (y / recognizer.view!.bounds.height * 2) - 1
        wheelSpeed.left = Int(value * -5000)
    }
    
    @IBAction func udpateRightWheel(recognizer: UIPanGestureRecognizer) {

        guard case .Changed = recognizer.state else { return wheelSpeed.right = 0 }
        
        let y = recognizer.locationInView(recognizer.view).y
        let value = (y / recognizer.view!.bounds.height * 2) - 1
        wheelSpeed.right = Int(value * -5000)
    }
}

