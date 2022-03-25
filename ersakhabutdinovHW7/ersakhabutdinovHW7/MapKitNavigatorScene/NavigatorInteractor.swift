//
//  MapKitNavigatorInteractor.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import Foundation
import MapKit

protocol INavigatorInteractor {
    
}

class NavigatorInteractor: INavigatorInteractor {
    
    let view: NavigatorView
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    init(view: NavigatorView) {
        self.view = view
       // self.view.mapView.delegate = view
    }
    
    func pathQuery() {
        guard
            let first = view.startLocation.text,
            let second = view.endLocation.text,
            first != second
        else {
            return
        }
        
        let group = DispatchGroup()
        
        group.enter()
        getCoordinateFrom(address: first, completion: { [weak
        self] coords, _ in
            if let coords = coords {
                self?.coordinates.append(coords)
            }
            group.leave()
        })
        
        group.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                self?.buildPath()
            }
        }
    }
    
    private func buildPath() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[0], addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[1], addressDictionary: nil))
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                view.mapView.addOverlay(route.polyline)
                view.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    private func getCoordinateFrom(address: String, completion:
                @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?)
                -> () ) {
        DispatchQueue.global(qos: .background).async {
            CLGeocoder().geocodeAddressString(address)
            { completion($0?.first?.location?.coordinate, $1) }
        }
    }
}
