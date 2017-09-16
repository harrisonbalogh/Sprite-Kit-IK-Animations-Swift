//
//  PhysicsEnvironmentViewController.swift
//  Harxer
//
//  Created by Harrison Balogh on 8/12/15.
//  Copyright (c) 2015 Harxer. All rights reserved.
//

import UIKit
import SpriteKit

class PhysicsEnvironmentViewController: UIViewController {

    
    @IBOutlet weak var environmentView: SKView!
    
    @IBOutlet weak var icon_buildMode: UIImageView!
    @IBOutlet weak var icon_testMode: UIImageView!
    
    @IBOutlet weak var button_menu: UIButton!
    @IBOutlet weak var button_respawn: UIButton!
//    @IBOutlet weak var button_tap_left: UIButton!
//    @IBOutlet weak var button_tap_right: UIButton!
    
//    @IBOutlet weak var overlay_screen: UIView!
    @IBOutlet weak var overlay_menu: UIImageView!
    
    @IBOutlet weak var menu_dividers: UIImageView!
    @IBOutlet weak var menu_button_close: UIButton!
    @IBOutlet weak var menu_button_back: UIButton!
    @IBOutlet weak var menu_button_returnMenu: UIButton!
    @IBOutlet weak var menu_button_settings: UIButton!
    @IBOutlet weak var menu_toggle_build_off: UIButton!
    @IBOutlet weak var menu_toggle_build_on: UIButton!
    @IBOutlet weak var menu_toggle_test_off: UIButton!
    @IBOutlet weak var menu_toggle_test_on: UIButton!
    
    var buildMode = false
    var testMode = false
    
    var environmentScene: TestScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize environment scene
        if let scene = TestScene(fileNamed:"TestScene") {
            environmentScene = scene
            // Configure the view.
            let skView = self.environmentView as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            scene.name = "SKScene_O"
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Open menu functionality for button.
    @IBAction func button_openMenu(_ sender: UIButton) {
        // TO-DO: put these UI menu items into container, just hide container
        button_menu.isHidden = true
        button_respawn.isHidden = true
//        button_tap_left.isHidden = true
//        button_tap_right.isHidden = true
        icon_buildMode.isHidden = true
        icon_testMode.isHidden = true
        
//        overlay_screen.isHidden = false
        overlay_menu.isHidden = false
        menu_dividers.isHidden = false
        menu_button_returnMenu.isHidden = false
        menu_button_settings.isHidden = false
        menu_button_close.isHidden = false
    }
    /// Respawn button functionality.
    @IBAction func button_respawn(_ sender: UIButton) {
        environmentScene.spawnEntity(EntityID.DUMMY, atPoint: nil)
    }
    /// Close menu functionality
    @IBAction func button_close(_ sender: UIButton) {
        button_menu.isHidden = false
        button_respawn.isHidden = false
//        button_tap_left.isHidden = false
//        button_tap_right.isHidden = false
        
//        overlay_screen.isHidden = true
        overlay_menu.isHidden = true
        menu_dividers.isHidden = true
        menu_button_returnMenu.isHidden = true
        menu_button_settings.isHidden = true
        menu_button_close.isHidden = true
        
        if testMode {
            icon_testMode.isHidden = false
        } else {
            icon_testMode.isHidden = true
        }
        
        if buildMode {
            icon_buildMode.isHidden = false
        } else {
            icon_buildMode.isHidden = true
        }
    }
    @IBAction func button_back(_ sender: UIButton) {
        menu_button_returnMenu.isHidden = false
        menu_button_settings.isHidden = false
        menu_button_close.isHidden = false
        
        menu_toggle_build_off.isHidden = true
        menu_toggle_test_off.isHidden = true
        menu_toggle_build_on.isHidden = true
        menu_toggle_test_on.isHidden = true
        menu_button_back.isHidden = true
    }
    @IBAction func button_returnMenu(_ sender: UIButton) {
        dismiss(animated: true, completion: {})
    }
    @IBAction func button_settings(_ sender: UIButton) {
        menu_button_returnMenu.isHidden = true
        menu_button_settings.isHidden = true
        menu_button_close.isHidden = true
        
        if testMode {
            menu_toggle_test_on.isHidden = false
        } else {
            menu_toggle_test_off.isHidden = false
        }
        
        if buildMode {
            menu_toggle_build_on.isHidden = false
        } else {
            menu_toggle_build_off.isHidden = false
        }
        menu_button_back.isHidden = false
    }
    @IBAction func toggle_build_off(_ sender: UIButton) {
        buildMode = true
        environmentScene.mode_build = true
        menu_toggle_build_off.isHidden = true
        menu_toggle_build_on.isHidden = false
    }
    @IBAction func toggle_build_on(_ sender: UIButton) {
        buildMode = false
        environmentScene.mode_build = false
        menu_toggle_build_off.isHidden = false
        menu_toggle_build_on.isHidden = true
    }
    @IBAction func toggle_test_off(_ sender: UIButton) {
        testMode = true
        environmentScene.mode_debug = true
        environmentScene.character.updateDebugMode()
        menu_toggle_test_off.isHidden = true
        menu_toggle_test_on.isHidden = false
    }
    @IBAction func toggle_test_on(_ sender: UIButton) {
        testMode = false
        environmentScene.mode_debug = false
        environmentScene.character.updateDebugMode()
        menu_toggle_test_off.isHidden = false
        menu_toggle_test_on.isHidden = true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft,UIInterfaceOrientationMask.landscapeRight]
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        print("Bump")
    }

}
