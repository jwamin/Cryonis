//
//  ViewController.swift
//  Cryonis
//
//  Created by Joss Manger on 3/22/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let sceneInMemory:SCNScene! = SCNScene(named: "art.scnassets/ice.scn")!
    var aim:UIView!
    var thisIsAHit:Bool = false
    var pointerPosition:CGPoint = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //sceneInMemory
        let node = sceneInMemory.rootNode.childNode(withName: "box", recursively: true)
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        
       let rect = CGRect(origin: self.view.center, size: CGSize(width: 10, height: 10))
        aim = UIView(frame: rect)
        aim.backgroundColor = UIColor.red
        aim.autoresizingMask = [.flexibleBottomMargin,.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin]
        aim.layer.opacity = 0.5
        sceneView.addSubview(aim)
        
        let effect = UIBlurEffect(style: .regular)
        let buttonContainer = UIVisualEffectView(effect: effect)
        buttonContainer.frame = (CGRect(x: 0, y: 0, width: 60, height: 60))
        let label = UIButton(frame: buttonContainer.frame)
        label.setTitle("⭕️", for: .normal)
        buttonContainer.contentView.addSubview(label)
        label.autoresizingMask = [.flexibleBottomMargin,.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin]
        label.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        sceneView.addSubview(buttonContainer)
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([buttonContainer.widthAnchor.constraint(equalToConstant: 60),buttonContainer.heightAnchor.constraint(equalToConstant: 60)])
        
        let x = NSLayoutConstraint(item: sceneView, attribute: .trailing, relatedBy: .equal, toItem: buttonContainer, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        let y = NSLayoutConstraint(item: sceneView, attribute: .bottom, relatedBy: .equal, toItem: buttonContainer, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        
        
        NSLayoutConstraint.activate([x,y])
        
        
    }
    
    @objc func buttonPressed(_ sender:Any){
        print("buttonPressed")
        
        if(thisIsAHit){
            let gothit = sceneView.hitTest(pointerPosition, options: nil)
            print(gothit)
            if gothit.count == 0 {
                return
            }
            
            
            gothit.first!.node.removeFromParentNode()
            
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        // Run the view's session
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //print("err... will render?")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        print("err... scene detect")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        
        let mynode = sceneInMemory.rootNode.childNode(withName: "box", recursively: true)!.clone()
        print(mynode)
        mynode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
//
//        // `SCNPlane` is vertically oriented in its local coordinate space, so
//        // rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
//        planeNode.eulerAngles.x = -.pi / 2
//
//        // Make the plane visualization semitransparent to clearly show real-world placement.
//        planeNode.opacity = 0.25
        
        // Add the plane visualization to the ARKit-managed node so that it tracks
        // changes in the plane anchor as plane estimation continues.
        node.addChildNode(mynode)
        
        //mynode.runAction(mynode.action(forKey: "action 0x7f97cebea770 #155")!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if let positionThing = aim {
            DispatchQueue.main.async {
            let results = self.sceneView.hitTest(self.aim.center, options: nil)
            
            guard let result = results.first else {
             
                //pointerview.backgroundColor = UIColor.yellow;
                
                
                    
                    if(self.thisIsAHit != false){
                        self.thisIsAHit=false
                    }
                    
                    self.aim.backgroundColor = UIColor.red
                    
                
                
                
                return;
            }
            
            
           
            
            self.pointerPosition = self.aim.center
            if(self.thisIsAHit != true){
                self.thisIsAHit = true
            }
            
            
       
                self.aim.backgroundColor = UIColor.green
            
            
            }
        } else {
            print("no dot")
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
