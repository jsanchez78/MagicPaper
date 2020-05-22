//
//  ViewController.swift
//  MagicPaper
//
//  Created by Jacob Sanchez on 5/21/20.
//  Copyright © 2020 Jacob Sanchez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Make Newspaper Image recognizable
        let configuration = ARImageTrackingConfiguration()
        
        //Track images within this bundle
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewspaperImages", bundle: Bundle.main){
            
            configuration.trackingImages = trackedImages
            
            configuration.maximumNumberOfTrackedImages = 1
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
        // Create plane for newspaper
        
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let videoNode = SKVideoNode(fileNamed: "Newspaper.mp4")
            
            videoNode.play()
            
            // Display Spritekit element via SceneKit
            
            let videoScene = SKScene(size: CGSize(width: 240, height: 180)) //Height varies by resolution of video
            
            videoNode.position = CGPoint(x: videoNode.size.width / 2, y: videoNode.size.height / 2)
            
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2    //Gif will be parallel to newspaper
            
            node.addChildNode(planeNode)
        }
        return node
    }
}
