
import QuartzCore
import SceneKit
import UIKit

class ABScene: UIView {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      backgroundColor = UIColor.redColor()
      setup()
   }
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   var sceneKitView:SCNView!
   let mainNode = SCNNode()
   var box:SCNGeometry!
   var shapeNode:SCNNode!
      let scene = SCNScene()
   //   let ambientLight = SCNLight()
   //   let diffuseLight = SCNLight()
   //   let reflectiveMaterial = SCNMaterial()
   //
   //
   
   
   func changeShape(param: CGFloat) {
      //  box.chamferRadius = param;
   }
   
   
   
   func setup() {
      
      //
      //
      
      box = SCNBox(width: 30, height: 30, length: 30, chamferRadius: 5)
      shapeNode = SCNNode(geometry:box)
      //
      //      let ambientLightNode = SCNNode()
      //      ambientLight.type = SCNLightTypeAmbient
      //      ambientLight.color = UIColor.greenColor()
      //      ambientLightNode.light = ambientLight
      //
      //
      //      let diffuseLightNode = SCNNode()
      //      diffuseLight.type = SCNLightTypeOmni;
      //      diffuseLightNode.light = diffuseLight;
      //      diffuseLightNode.position = SCNVector3(x:0, y:300, z:0);
      //
      //
      //      reflectiveMaterial.diffuse.contents = UIColor.blueColor()
      //      reflectiveMaterial.specular.contents = UIColor.redColor()
      //      reflectiveMaterial.shininess = 5.0
      //
            scene.rootNode.addChildNode(mainNode)
      
//            scene.rootNode.addChildNode(ambientLightNode)
//            scene.rootNode.addChildNode(diffuseLightNode)
//      
//            box.materials = [reflectiveMaterial]
      
      //
            shapeNode.position = SCNVector3(x:0, y:0, z:100)

            mainNode.addChildNode(shapeNode)
      //
      //      let animation = CABasicAnimation(keyPath:"rotation")
      //      animation.byValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 0, z: 3, w: 2*Float(M_PI)))
      //      animation.duration = 3.0
      //      animation.repeatCount = 100000
      //
      //      //shapeNode.addAnimation(animation, forKey:"transform")
      //
      //
      sceneKitView = SCNView(frame:bounds, options:nil)
            sceneKitView.autoenablesDefaultLighting = true
            sceneKitView.allowsCameraControl = true
            sceneKitView.scene = scene
      sceneKitView.backgroundColor = UIColor.blackColor()
      //
            self.addSubview(sceneKitView)
      //
   }
   
   
   override func layoutSubviews() {
      sceneKitView.frame = bounds;
   }
}




