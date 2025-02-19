//
//  ShowPositionViewController.swift
//  SalusMea
//
//  Created by Viking on 2020. 10. 19..
//

import UIKit
import Mapbox
import Proximiio
//import ProximiioMapbox

class MyAnnotation: MGLPointAnnotation {
    var online = false
}

@objc class ShowPositionViewController: BaseViewController {

    static let LAST_POSITION_URL = "\(HOME_URL)/wss/lastposition.php"
    
    @IBOutlet weak var mapContainer: UIView!
    
    private var mapView: MGLMapView?
//    private var mapBoxHelper: ProximiioMapbox?
    
    private var annotation: MyAnnotation?
    
    private var first = true
    private var timer: Timer?
    
    @objc public var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("FOLLOW_ME_FOLLOWER", comment: "") + " " + (contact?.name ?? "")
        
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
        if let phone = AlertyDBMgr.internationalizeNumber(contact?.phone) {
            let url = ShowPositionViewController.LAST_POSITION_URL.appendingFormat("?phone=%@", phone)
            MobileInterface.getJsonObject(url) { (result, error) in
                if let result = result {
                    let latitude = result["latitude"] as? String
                    let longitude = result["longitude"] as? String
                    let ago = result["ago"] as? String
                    let active = result["active"] as? String
                    let positionDate = result["position_date"] as? String
                    //let accuracy = result["accuracy"] as? String
                    if let latitude = Double(latitude ?? ""), let longitude = Double(longitude ?? "") {
                        OperationQueue.main.addOperation {

                            var selected = false
                            if let annotation = self.annotation {
                                if let selectedAnnotations = self.mapView?.selectedAnnotations {
                                    for selectedAnnotation in selectedAnnotations {
                                        if selectedAnnotation.isEqual(annotation) {
                                            selected = true
                                            break
                                        }
                                    }
                                }
                                self.mapView?.removeAnnotation(annotation)
                            }
                            
                            let point = MyAnnotation()
                            point.title = "Offline"
                            point.subtitle = positionDate
                            
                            let location = CLLocationCoordinate2DMake(latitude, longitude)
                            point.coordinate = location
                             
                            // Add the image to the style's sprite
                            if let ago = Double(ago ?? ""), let active = Double(active ?? "") {
                                if ago < 310 {
                                    point.online = true
                                    if active == 1 {
                                        point.title = "Active"
                                    } else {
                                        point.title = "Standby"
                                    }
                                }
                            }
                                                       
                            self.annotation = point
                            
                            self.mapView?.addAnnotation(point)
                            if selected {
                                self.mapView?.selectAnnotation(point, animated: false, completionHandler: nil)
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
    }

    @IBAction func centerPosition(_ sender: Any) {
        if let annotation = annotation {
            mapView?.setCenter(annotation.coordinate, animated: true)
        }
    }
}

extension ShowPositionViewController : MGLMapViewDelegate {
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
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let annotation = annotation as? MyAnnotation {
            let id = annotation.online ? "follow_me_icon_active" : "follow_me_icon_canceled"
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: id)
            if annotationImage == nil {
                let image = UIImage(named: id)
                guard let imageWrap = image else { return nil }
                annotationImage = MGLAnnotationImage(image: imageWrap, reuseIdentifier: id)
            }
            return annotationImage
        }
        return nil
    }
}
