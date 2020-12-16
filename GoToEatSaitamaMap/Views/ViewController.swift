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
    let oomiyaButton = UIButton()
    
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
        
        oomiyaButton.setTitle("大宮区", for: .normal)
        oomiyaButton.addTarget(self, action:#selector(didPushOomiya), for: .touchUpInside)
        oomiyaButton.backgroundColor = .blue
//        view.addSubview(oomiyaButton)
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
        
        oomiyaButton.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top,
                                    width: 60, height: 40)
    }
    
    @objc private func didPushOomiya() {
        print("oomiya")
        shopRepository.fetch(area: .omiya) {
            print(self.shopRepository.shopList.first)
            print(self.shopRepository.shopList.last)
        }
    }
    
    private func setupMap() {
        var region = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        region.center = CLLocationCoordinate2D(latitude: CLLocationDegrees(35.867877), longitude: CLLocationDegrees(139.629316))
        mapView.setRegion(region,animated:false)
        
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
        let area = TyuoAreaBorder()
        let polygon = area.polygon()
        mapView.addOverlay(polygon)
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
        mapView.removeOverlays(mapView.overlays)
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
            renderer.fillColor = .red
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
