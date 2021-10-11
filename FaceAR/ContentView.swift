//
//  ContentView.swift
//  FaceAR
//
//  Created by YURY PROSVIRNIN on 22.09.2021.
//
import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        //Checking face tracking is supported
        guard ARFaceTrackingConfiguration.isSupported else {
            return arView
        }
        
        let configuration = ARFaceTrackingConfiguration()
        //configuration.isLightEstimationEnabled = true
        
        arView.session.run(configuration, options: [])
        
        let anchor = AnchorEntity(.face)
        arView.scene.anchors.append(anchor)
        
        arView.setupGestures()
        arView.addGoggles()
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView{
    //adds tap gesture
    func setupGestures() {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.detectSwipeGesture(sender:)))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func detectSwipeGesture(sender: UITapGestureRecognizer) {
        self.addGoggles()
    }
    
    //clears existing entity and adds a random one
    func addGoggles()  {
        
        guard let anchor = self.scene.anchors.first else { return }
            
        let index = [1,2,3,4,5].randomElement()!
        guard let googles = loadFoodGoggles(index) else { return }
        
        anchor.children.removeAll()
        anchor.addChild(googles)

        }
    }
    
    //loads entities from realityKit file
    func loadFoodGoggles(_ index: Int) -> Entity? {
        switch index {
        case 1:
            return try? Goggles.loadFoodGoggles1()
        case 2:
            return try? Goggles.loadFoodGoggles2()
        case 3:
            return try? Goggles.loadFoodGoggles3()
        case 4:
            return try? Goggles.loadFoodGoggles4()
        case 5:
            return try? Goggles.loadFoodGoggles5()
        default:
            return nil

    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
