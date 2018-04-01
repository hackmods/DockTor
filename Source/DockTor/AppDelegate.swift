//
//  AppDelegate.swift
//  DockTor
//
//  Created by Ryan Morris on 2018-03-31.
//  Copyright © 2018 Hackmods. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var ToggleButton: NSButton!
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var lblStatus: NSTextField!
    
    var isStaticOnly = false;
    let PurpleColour = NSColor(red: 0.5, green: 0, blue: 1.0, alpha: 1.0)
    let PinkColour = NSColor(red: 1, green: 0.3, blue: 1.0, alpha: 1.0)
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NSApplication.shared().terminate(self)
    }
    
    func windowShouldClose(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let task = Process()
        task.launchPath = "/usr/bin/env"
        
        task.arguments = ["bash", "-c", "defaults read com.apple.dock static-only"]
        //0 all the icons
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        task.suspend()
        if(output! == "0\n")
        {
            SetDisabled()
            isStaticOnly = false
            //print("set false correctly")
        }
        else
        {
            SetEnabled()
            isStaticOnly = true
        }
    }

    @IBAction func ToggleDockButton(_ sender: NSButton) {
    
        let task = Process()
        
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", "defaults read com.apple.dock static-only"]
        
        if(isStaticOnly)
        {
            //turn dock off
            task.arguments  = ["bash", "-c", "defaults write com.apple.dock static-only -bool false; killall Dock"]
            SetDisabled()
        }
        else{
            task.arguments  = ["bash", "-c", "defaults write com.apple.dock static-only -bool true; killall Dock"]
            SetEnabled()
        }
        
        sender.isEnabled = false
        
        //let pipe = Pipe()
        //task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        //let data = pipe.fileHandleForReading.readDataToEndOfFile()
        //let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //print(output!)
        
        isStaticOnly = !isStaticOnly;

        sender.isEnabled = true
    }
    
    func SetEnabled () {
        ToggleButton.title = "Disable"
        lblStatus.textColor = PurpleColour
       // lblStatus.backgroundColor = PinkColour
        lblStatus.stringValue = "🔥ENABLED🔥"

    }

    func SetDisabled () {
        ToggleButton.title = "Enable"
        lblStatus.textColor = PinkColour
       // lblStatus.backgroundColor = PurpleColour
        lblStatus.stringValue = "⚡️DISABLED⚡️"
    }
}
