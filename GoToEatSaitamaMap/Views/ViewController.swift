//
//  ViewController.swift
//  GoToEatSaitamaMap
//
//  Created by 齋藤健悟 on 2020/12/03.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let mapView = MKMapView()
    let shopView = ShopView(frame: .zero)
    let shopClusterListView = ShopClusterListView()
    
    let locationManager = CLLocationManager()
    var isFirstSetCenter = true
    let shopRepository = ShopRepository()
    let coordinateLoader = CoordinateLoader()
    
    override func loadView() {
        super.loadView()
        
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    private func setupSubviews() {
        view.addSubview(mapView)
        view.addSubview(shopView)
        shopView.isHidden = true
        view.addSubview(shopClusterListView)
        shopClusterListView.isHidden = true
        shopClusterListView.listViewDelegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let mainFrame = UIScreen.main.bounds
        mapView.frame = CGRect(x: 0, y: 0, width: mainFrame.width, height: mainFrame.height)
        
        let bottomMargin = CGFloat(60)
        let subviewWidth = mainFrame.width - 32
        shopView.frame.size.width = subviewWidth
        shopView.sizeToFit()
        shopView.frame.origin = CGPoint(x: 16, y: mainFrame.maxY - shopView.frame.size.height - bottomMargin)
        
        let listViewHeight = CGFloat(120)
        shopClusterListView.frame = CGRect(x: 16, y: mainFrame.maxY - listViewHeight - bottomMargin,
                                           width: mainFrame.width - 32, height: listViewHeight)
    }
    
    private func setupMap() {
        let boundary = MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.061104,
                                                                                                                    longitude: 139.2787508),
                                                                                     span: MKCoordinateSpan(latitudeDelta: 0.3,
                                                                                                            longitudeDelta: 1)))
        mapView.setCameraBoundary(boundary, animated: false)
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 50 * 1000), animated: false)
        
        let regionCenter = CLLocationCoordinate2D(latitude: 35.867877, longitude: 139.629316)
        let region = MKCoordinateRegion(center: regionCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated:false)

        mapView.showsUserLocation = true
        
        showShopAnnotations()
        showOverlayTyuoArea()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        registerAnnotationViewClasses()
        setupMap()
    }
    
    private func showShopAnnotations() {
        let shopList = shopRepository.shopList
        shopList.forEach {
            let pin = ShopAnnotaion(shop: $0)
            mapView.addAnnotation(pin)
        }
    }
    
    private func showOverlayTyuoArea() {
        let tyuoArea = TyuoAreaBorder()
        let tyuoPolygon = tyuoArea.polygon()
        let overallArea = [
            CLLocationCoordinate2D(latitude: 35.7926364, longitude: 139.9048961),
            CLLocationCoordinate2D(latitude: 36.2841001, longitude: 139.8764339),
            CLLocationCoordinate2D(latitude: 36.2977199, longitude: 138.6847137),
            CLLocationCoordinate2D(latitude: 35.8108062, longitude: 138.6762004)
        ]
        let overallAreaPolygon = MKPolygon(coordinates: overallArea, count: overallArea.count, interiorPolygons: [tyuoPolygon])
        mapView.addOverlay(overallAreaPolygon)
    }
    
    private func registerAnnotationViewClasses() {
        mapView.register(ShopAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func routeSearch(s: CLLocationCoordinate2D, g: CLLocationCoordinate2D) {
        let directionRequest = MKDirections.Request()
        let sPlace = MKPlacemark(coordinate: s)
        let gPlace = MKPlacemark(coordinate: g)
        directionRequest.source = MKMapItem(placemark: sPlace)
        directionRequest.destination = MKMapItem(placemark: gPlace)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            //　ルートを追加
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.shopView.updateTravelTime(route.expectedTravelTime)
        }
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last,
           isFirstSetCenter {
            mapView.setCenter(location.coordinate, animated: true)
            isFirstSetCenter = false
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is ShopAnnotaion {
            return ShopAnnotationView(annotation: annotation, reuseIdentifier: ShopAnnotationView.ReuseID)
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        /** リスト */
        if let cluster = view.annotation as? MKClusterAnnotation {
            let shopNames = cluster.memberAnnotations.compactMap { $0.title }.compactMap { $0 }
            let shopList = shopNames.compactMap {
                shopRepository.select(from: $0)
            }
            shopClusterListView.shopList = shopList
            shopClusterListView.isHidden = false
            return
        }
        
        /** 一つの店舗情報 */
        if let annotation = view.annotation,
           let title = annotation.title,
           let name = title,
           let shop = shopRepository.select(from: name) {
            shopView.isHidden = false
            shopView.selectedShop(shop)
            shopView.sizeToFit()
            if let s = locationManager.location?.coordinate {
                routeSearch(s: s, g: shop.coordinate2D)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        didDeselect()
    }
    
    private func didDeselect() {
        shopView.isHidden = true
        shopClusterListView.isHidden = true
        let polylines = mapView.overlays.filter {$0 is MKPolyline}
        mapView.removeOverlays(polylines)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            return renderer
        }
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = .black
            renderer.alpha = 0.1
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}

extension ViewController: ShopClusterListViewDelegate {
    func didSelectShop(_ view: ShopClusterListView, shop: Shop) {
        // ズームする
        var region = mapView.region
        region.span.latitudeDelta = 0.002
        region.span.longitudeDelta = 0.002
        region.center = shop.coordinate2D
        mapView.setRegion(region,animated:false)
    }
}
