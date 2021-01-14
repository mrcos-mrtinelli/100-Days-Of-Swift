//
//  ViewController.swift
//  Project18
//
//  Created by Marcos Martinelli on 1/14/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* DEBUGGING TECHINIQUES: */
        
        // 1. print() - not the best, but it works
        print("viewDidLoad() has been triggered")
        print("viewDidLoad()", "has", "been", "triggered")
        print("viewDidLoad()", "has", "been", "triggered", terminator: "") // no new line, "" instead
        print("viewDidLoad()", "has", "been", "triggered", separator: "->")
        
        // 2. Assetion with assert() - will crash your program before any harm is done
        //    such as losing use data
        assert(1 == 1, "Math failure") // will not trigger b/c 1 does equal 1
        assert(1 == 2, "Math failure") // this will fail, and will crash your app
        // *** assert() will not appear in release code! this can be used liberally!
        // *** it will be removed when the code is built for the app store!
        assert(reallySlowFunction() == true, "The reallySlowFunction failed!")
        
        // 3. Breakpoints
        for i in 1...100 {
            print("got number \(i)") // click line number to activate, re-click to deactivate, right click to delete
            // fn+F6 to STEP-OVER line by line
            // CMD+Ctrl+Y to CONTINUE until the next breakpoint
            
            // (lldb) is a command line
            
            // DRAG the green Thread breakpoint
            
            // CONDITIONAL BREAKPOINTS!!!!
            // - pause the breakpoint
            
            // 4. View Debugging to capture your view hierarchy
            // for autolayout!
        }
    }
    func reallySlowFunction() -> Bool {
        // this is just so the example above doesn't throw a compiler error
        return true
    }
}

