//
//  FollowMeViewController.swift
//  SalusMea
//
//  Created by Viking on 2020. 10. 19..
//

import UIKit
import Mapbox
import Proximiio
//import ProximiioMapbox

@objc class FollowMeViewController: BaseViewController {

    static let GET_POSITION_URL = "\(HOME_URL)/getposition.php"
    
    @IBOutlet weak var mapContainer: UIView!
    
    private var mapView: MGLMapView?
//    private var mapBoxHelper: ProximiioMapbox?
    
    private var annotation: MGLPointAnnotation?
    private var mapSource: MGLShapeSource?
    private var mapLayer: MGLSymbolStyleLayer?
    private var circleLayer: MGLCircleStyleLayer?
    
    private var first = true
    private var timer: Timer?
    
    @objc public var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem.init(image: UIImage.init(named: "icon_back.png"),
                                              style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = backButton
        
        let mapView = MGLMapView(frame: mapContainer.bounds)
        mapView.delegate = self
        mapContainer.insertSubview(mapView, at: 0)
        self.mapView = mapView
        
//        let configuration = ProximiioMapboxConfiguration(token: Proximiio.sharedInstance()?.token() ?? "")
//        configuration.showUserLocation = false
        
//        mapBoxHelper = ProximiioMapbox.init()
//        mapBoxHelper?.setup(mapView: mapView, configuration: configuration)
//        mapBoxHelper?.followingUser = false
//        mapBoxHelper?.initialize({ (result) in
//            print(result)
//        })
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
            self.refresh()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView?.frame = mapContainer.bounds
    }
    
    private func refresh() {
        let url = FollowMeViewController.GET_POSITION_URL.appendingFormat("?id=%@&userid=%@", userId,userId)
        MobileInterface.getJsonObject(url) { (result, error) in
            if let result = result {
                let latitude = result["latitude"] as? String
                let longitude = result["longitude"] as? String
                let accuracy = result["accuracy"] as? String
                if let latitude = Double(latitude ?? ""), let longitude = Double(longitude ?? "") {
                    OperationQueue.main.addOperation {

                        if let circleLayer = self.circleLayer {
                            self.mapView?.style?.removeLayer(circleLayer)
                        }
                        if let mapLayer = self.mapLayer, let mapSource = self.mapSource {
                            self.mapView?.style?.removeLayer(mapLayer)
                            self.mapView?.style?.removeSource(mapSource)
                        }
                        
                        let point = MGLPointAnnotation()
                        
                        let location = CLLocationCoordinate2DMake(latitude, longitude)
                        point.coordinate = location

                        // Create a data source to hold the point data
                        self.mapSource = MGLShapeSource(identifier: "marker-source", shape: point, options: nil)
                         
                        // Create a style layer for the symbol
                        self.mapLayer = MGLSymbolStyleLayer(identifier: "marker-style", source: self.mapSource!)
                         
                        // Add the image to the style's sprite
                        if let image = UIImage(named: "follow_me_icon_active") {
                            self.mapView?.style?.setImage(image, forName: "home-symbol")
                        }
                         
                        // Tell the layer to use the image in the sprite
                        self.mapLayer?.iconImageName = NSExpression(forConstantValue: "home-symbol")

                        // Add the source and style layer to the map
                        self.mapView?.style?.addSource(self.mapSource!)
                        self.mapView?.style?.addLayer(self.mapLayer!)
                        
                        self.annotation = point
                        
                        if let accuracy = Double(accuracy ?? "") {
                            let pixelRadius = (accuracy + 10) / 0.072 / cos(latitude * Double.pi / 180)
                            let layer = MGLCircleStyleLayer(identifier: "circles", source: self.mapSource!)
                            let fillColor = UIColor.init(red: 0.0, green: 131.0/255.0, blue: 255.0/255.0, alpha: 0.2)
                            layer.circleColor = NSExpression(forConstantValue: fillColor)
                            layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 2.0, %@)",
                                                              [12: 2,
                                                               22: pixelRadius])
                            let strokeColor = UIColor.init(red: 0.0, green: 131.0/255.0, blue: 255.0/255.0, alpha: 0.5)
                            layer.circleStrokeColor = NSExpression(forConstantValue: strokeColor)
                            layer.circleStrokeWidth = NSExpression(forConstantValue: 1.0)
                            self.mapView?.style?.addLayer(layer)
                            self.circleLayer = layer
                        }
                        
                        if self.first {
                            self.first = false
                            self.mapView?.setCenter(location, zoomLevel: 14, direction: 0, animated: false)
                        }
                    }
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
                OperationQueue.main.addOperation {
                    if let image = UIImage(named: "follow_me_icon_canceled") {
                        self.mapView?.style?.setImage(image, forName: "home-symbol")
                    }
                }
            }
        }
    }

    @IBAction func centerPosition(_ sender: Any) {
        if let annotation = annotation {
            mapView?.setCenter(annotation.coordinate, animated: true)
        }
    }
}

extension FollowMeViewController : MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        refresh()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            OperationQueue.main.addOperation {
                if let layers = self.mapView?.style?.layers {
                    if layers.count > 0 {
                        timer.invalidate()
                        for layer in layers {
                            layer.isVisible = true
                        }
                    }
                }
            }
        }
    }
}
