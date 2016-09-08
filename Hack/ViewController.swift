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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var client: MQTTClient = {
        let mqttConfig = MQTTConfig(clientId: "test", host: "192.168.1.107", port: 1883, keepAlive: 60)
        mqttConfig.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }
        mqttConfig.onConnectCallback = {
            print("Connected:", $0)
        }
        mqttConfig.onDisconnectCallback = {
            print("Disconnected:", $0)
        }
        
        
        // create new MQTT Connection
        return MQTT.newConnection(mqttConfig)
    }()
    
    func updateWheels() {
        let command = "{\"Left\":\(wheelSpeed.left), \"Right\":\(wheelSpeed.right)}"
        client.publishString(command, topic: "command/wheel_speed", qos: 0, retain: true)
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
        switch recognizer.state {
        case .Ended: wheelSpeed.left = 0
        case .Changed:
            let y = recognizer.locationInView(recognizer.view).y
            let value = (y / recognizer.view!.bounds.height * 2) - 1
            wheelSpeed.left = Int(value * -8000)

        default: break }
    }
    
    @IBAction func udpateRightWheel(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Ended: wheelSpeed.right = 0
        case .Changed:
            let y = recognizer.locationInView(recognizer.view).y
            let value = (y / recognizer.view!.bounds.height * 2) - 1
            wheelSpeed.right = Int(value * -8000)
            
        default: break }
    }
}

