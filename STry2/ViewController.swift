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
    
    let configuration = ARWorldTrackingConfiguration()
    
    struct Images{
        var title: String
        var info: String
    }
    
    var imageArray: [Images] = []
    
    func getData() {
    let item1 = Images(title: "pika", info: "A pika")
    let item2 = Images(title: "dog", info: "A dog")
    imageArray.append(item1)
    imageArray.append(item2)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Detect the image
        guard let storedImages = ARReferenceImage.referenceImages(inGroupNamed:"AR Resources", bundle: nil) else{
            fatalError("Missing AR Resources images")
        }
        
        configuration.detectionImages = storedImages
        
        getData()
        
        sceneView.session.run(configuration)
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARImageAnchor{
            let movingImage = SCNText(string: "Moving Text", extrusionDepth: 0.1)
            movingImage.flatness = 0.1
            movingImage.font = UIFont.boldSystemFont(ofSize: 10)
            let titleNode = SCNNode()
            titleNode.geometry = movingImage
            titleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            titleNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            node.addChildNode(titleNode)
            print("Item recognized")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor)-> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        let planeNode = SCNNode()
        planeNode.geometry = plane
        let ninetyDegrees = GLKMathDegreesToRadians(-90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        
        switch imageAnchor.referenceImage.name {
        case "pika":
            let title = SCNText(string: imageArray[0].title, extrusionDepth: 0.1)
            title.flatness = 0.1
            title.font = UIFont.boldSystemFont(ofSize: 10)
            let titleNode = SCNNode()
            titleNode.geometry = title
            titleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            titleNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            titleNode.position.x = -Float(plane.width) / 2.2
            titleNode.position.y = -Float(plane.height) / 2.2
            planeNode.addChildNode(titleNode)
            let info = SCNText(string: imageArray[0].info, extrusionDepth: 0.1)
            info.flatness = 0.1
            info.font = UIFont.boldSystemFont(ofSize: 8)
            let infoNode = SCNNode()
            infoNode.geometry = info
            infoNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            infoNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            infoNode.position.x = -Float(plane.width) / 2.2
            infoNode.position.y = -Float(plane.height) / 1.8
            planeNode.addChildNode(infoNode)
            
            //play video
            guard let currentFrame = sceneView.session.currentFrame else { return nil }
            let videoNode = SKVideoNode(fileNamed: "pikaVideo.mov")
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 640, height: 480))
            videoScene.scaleMode = .aspectFit
            videoScene.addChild(videoNode)
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            let videoPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            videoPlane.firstMaterial?.diffuse.contents = videoScene
            videoPlane.firstMaterial?.isDoubleSided = true
            let tvPlaneNode = SCNNode(geometry: videoPlane)
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.0
            tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
            tvPlaneNode.eulerAngles = SCNVector3 (Double.pi, 0, 0)
            tvPlaneNode.position = SCNVector3(0,0,0)
            planeNode.addChildNode(tvPlaneNode)
            print(imageArray[0].title)
            print(imageArray[0].info)
            
        case "dog":
            let title = SCNText(string: imageArray[1].title, extrusionDepth: 0.1)
            title.flatness = 0.1
            title.font = UIFont.boldSystemFont(ofSize: 10)
            let titleNode = SCNNode()
            titleNode.geometry = title
            titleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            titleNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            titleNode.position.x = -Float(plane.width) / 2.2
            titleNode.position.y = -Float(plane.height) / 2.2
            planeNode.addChildNode(titleNode)
            let info = SCNText(string: imageArray[1].info, extrusionDepth: 0.1)
            info.flatness = 0.1
            info.font = UIFont.boldSystemFont(ofSize: 8)
            let infoNode = SCNNode()
            infoNode.geometry = info
            infoNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            infoNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            infoNode.position.x = -Float(plane.width) / 2.2
            infoNode.position.y = -Float(plane.height) / 1.8
            planeNode.addChildNode(infoNode)
            // play animation
            let item = SCNScene(named: "ship.scn")
                       //identify the parent or rootnode of
                       //the virtual object
            let itemNode = item?.rootNode.childNode (withName: "ship", recursively: true)
            let rotateMe = SCNAction.rotateBy(x: 0.5,y: 0.1, z: 0.2, duration: 1)
            let repeatMe = SCNAction.repeatForever(rotateMe)
            itemNode?.runAction(repeatMe)
            itemNode?.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y,anchor.transform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(itemNode!)
                   print(imageArray[1].title)
                   print(imageArray[1].info)
        default:
            print("Nothing found")
        }
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        return node
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
