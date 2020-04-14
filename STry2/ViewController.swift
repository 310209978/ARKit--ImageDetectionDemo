//
//  ViewController.swift
//  STry2
//
//  Created by elaine on 2020/4/14.
//  Copyright © 2020 yuri. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var realPoints = [SCNNode]()
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.session.run(configuration)
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapResponse(sender: UITapGestureRecognizer) {
        let scene = sender.view as! ARSCNView
        let location = scene.center
        let hitTestResults = scene.hitTest(location, types: .featurePoint)
        if hitTestResults.isEmpty == false {
            guard let hitTestResults = hitTestResults.first
            else { return }
            let sphereNode = SCNNode()
            sphereNode.geometry = SCNSphere(radius: 0.003)
            sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            sphereNode.position = SCNVector3(hitTestResults.worldTransform.columns.3.x, hitTestResults.worldTransform.columns.3.y, hitTestResults.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(sphereNode)
            realPoints.append(sphereNode)
            if realPoints.count == 2 {
            let pointOne = realPoints.first!
            let pointTwo = realPoints.last!
            let x = pointTwo.position.x - pointOne.position.x
            let y = pointTwo.position.y - pointOne.position.y
            let z = pointTwo.position.z - pointOne.position.z
            let position = SCNVector3(x, y, z)
            let distance = sqrt(position.x * position.x +
            position.y * position.y + position.z * position.z)
            let x1 = (pointOne.position.x + pointTwo.position.x) / 2
            let y1 = pointOne.position.y + pointTwo.position.y
            let z1 = pointOne.position.z + pointTwo.position.z
            let centerPosition = SCNVector3(x1, y1, z1)
            displayText(answer: distance, position: centerPosition)
                    }
            }
        
    }
    func displayText(answer: Float, position: SCNVector3) {
        let textDisplay = SCNText(string: "\(answer) meters", extrusionDepth: 0.5)
        textDisplay.firstMaterial?.diffuse.contents = UIColor.yellow
        let textNode = SCNNode()
        textNode.geometry = textDisplay
        textNode.position = position
        textNode.scale = SCNVector3(0.003, 0.003, 0.003)
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
