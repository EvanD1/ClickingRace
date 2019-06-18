//
//  ViewController.swift
//  ClickingRace
//
//  Created by Evan Dalton on 2019-06-06.
//  Copyright © 2019 Phidgets. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {
    
    let button0 = DigitalInput()
    let button1 = DigitalInput()
    
    let led1 = DigitalOutput()
    let led2 = DigitalOutput()
    
    
    var buttonPressed = "none"
    var outOne = "none"
    var outTwo = "none"
    var points1 = 0
    var points2 = 0
    
    func attach_handler(sender: Phidget){
        do{
            if(try sender.getHubPort() == 2){
                print("Button 0 Attached")
            }
            else{
                print("Button 1 Attached")
            }
        } catch let err as PhidgetError {
            print("phidget Error" + err.description)
        } catch {
            //catch other errors here
        }
    }
    
    func state_change_button0(sender: DigitalInput, state:Bool){
        do{
        if(state == true){
            print("Button 0 Pressed")
            updateP1()
            try led1.setState(true)
        }
        else{
            print("Button 0 Not Pressed")
            try led1.setState(false)
        }
        hundered()
        } catch let err as PhidgetError{
            print("PhidgetError" + err.description)
        } catch{
            
        }
    }
    
    
    
    func state_change_button1(sender: DigitalInput, state:Bool){
        do{
        if (state == true){
            print("Button 1 Pressed")
            updateP2()
            try led2.setState(true)
        }
        else{
            print("Button 1 Not Pressed")
            try led2.setState(false)
        }
        hundered()
        } catch let err as PhidgetError{
            print("PhidgetError" + err.description)
        } catch{
            
        }
}
    @IBOutlet weak var Player1Score: UILabel!
    @IBOutlet weak var Player2Score: UILabel!
    @IBOutlet weak var TextW: UILabel!
    
    func uiUpdateP1(){
        DispatchQueue.main.async {
            self.Player1Score.text = "\(self.points1)"
        }
    }
    func uiUpdateP2(){
        DispatchQueue.main.async {
        self.Player2Score.text = "\(self.points2)"
        }
    }
    func updateP1(){
        points1 += 1
        uiUpdateP1()
        update()
    }
    func updateP2(){
        points2 += 1
        uiUpdateP2()
    }
    func update(){
        DispatchQueue.main.async {
            self.TextW.text = "First To 1000"
        }
    }
    func restart(){
        if points1 == 105{
            points1 = 0
            points2 = 0
        } else if points2 == 105{
            points2 = 0
            points1 = 0
        }
    }
    
    func hundered(){
        do{
        if points1 >= 100{
            
            DispatchQueue.main.async {
                self.Player1Score.text = "Winner"
                
            }
            try led1.setState(true)
            restart()
        } else if points2 >= 100{
            DispatchQueue.main.async {
                self.Player2Score.text = "Winner"
                
            }
            try led2.setState(true)
            restart()
        }
        } catch let err as PhidgetError{
            print("PhidgetError" + err.description)
        } catch{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            
            //enable server discovery
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //adress objects
            try button0.setDeviceSerialNumber(528022)
            try button0.setHubPort(1)
            try button0.setIsHubPortDevice(true)
            
            try button1.setDeviceSerialNumber(528022)
            try button1.setHubPort(0)
            try button1.setIsHubPortDevice(true)
            
            //add attach handlers
            let _ = button0.attach.addHandler(attach_handler)
            let _ = button1.attach.addHandler(attach_handler)
            
            //add state change handlers
            let _ = button0.stateChange.addHandler(state_change_button0)
            let _ = button1.stateChange.addHandler(state_change_button1)
            
            //open objects
            try button0.open()
            try button1.open()
            
            //leds
            try led1.setDeviceSerialNumber(528022)
            try led1.setHubPort(3)
            try led1.setIsHubPortDevice(true)
            
            try led2.setDeviceSerialNumber(528022)
            try led2.setHubPort(2)
            try led2.setIsHubPortDevice(true)
            
            let _ = led1.attach.addHandler(attach_handler)
            let _ = led2.attach.addHandler(attach_handler)
            
            try led1.open()
            try led2.open()
            
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //catch other errors here
        }
        
    }


}

