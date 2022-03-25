//
//  MapKitNavigatorInteractor.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import Foundation
import MapKit

protocol INavigatorInteractor: AnyObject {
    func pathQuery(view: NavigatorView)
}

class NavigatorInteractor: INavigatorInteractor {
    
    let presenter: INavigatorPresenter
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    init(presenter: INavigatorPresenter) {
        self.presenter = presenter
    }
    
    func pathQuery(view: NavigatorView) {
        //exit(0)
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
        
        group.enter()
        getCoordinateFrom(address: second, completion: { [weak
        self] coords, _ in
            if let coords = coords {
                self?.coordinates.append(coords)
            }
            group.leave()
        })
        
        group.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                self?.buildPath(view: view)
            }
        }
    }
    
    private func buildPath(view: NavigatorView) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[0], addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[1], addressDictionary: nil))
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned view] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                view.mapView.addOverlay(route.polyline)
                view.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
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
