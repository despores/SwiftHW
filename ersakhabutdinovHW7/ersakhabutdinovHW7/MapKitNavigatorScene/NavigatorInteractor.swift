import Foundation
import YandexMapsMobile
import MapKit

protocol INavigatorInteractor: AnyObject {
    func pathQuery(view: NavigatorView)
    func clearMap(view: NavigatorView)
}

class NavigatorInteractor: INavigatorInteractor {
    
    let presenter: INavigatorPresenter
    
    var drivingSession: YMKDrivingSession?
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    init(presenter: INavigatorPresenter) {
        self.presenter = presenter
    }
    
    func pathQuery(view: NavigatorView) {
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
        
        if coordinates.count < 2 {
            return
        }
        
        let sourcePoint = YMKPoint(latitude: coordinates[0].latitude, longitude: coordinates[0].longitude)
        let destinationPoint = YMKPoint(latitude: coordinates[1].latitude, longitude: coordinates[1].longitude)
        
        let cameraTarget = YMKPoint(latitude: (coordinates[0].latitude + coordinates[1].latitude) / 2,
                                    longitude: (coordinates[0].longitude + coordinates[1].longitude) / 2)
        
        coordinates.removeAll()
        
        view.mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: cameraTarget, zoom: 4, azimuth: 0, tilt: 0))
                
        let requestPoints : [YMKRequestPoint] = [
                    YMKRequestPoint(point: sourcePoint, type: .waypoint, pointContext: nil),
                    YMKRequestPoint(point: destinationPoint, type: .waypoint, pointContext: nil),
        ]
                
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
                if let routes = routesResponse {
                    self.onRoutesReceived(routes, view)
                } else {
                    self.onRoutesError(error!, view)
                }
            }
                
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
    }
    
    func clearMap(view: NavigatorView) {
        view.mapView.mapWindow.map.mapObjects.clear()
        view.distanceText.alpha = 0
    }
    
    
    private func onRoutesReceived(_ routes: [YMKDrivingRoute], _ view: NavigatorView) {
        clearMap(view: view)
        let mapObjects = view.mapView.mapWindow.map.mapObjects
        var distance = "big"
        for route in routes {
            let polyline = mapObjects.addColoredPolyline(with: route.geometry)
            YMKRouteHelper.updatePolyline(withPolyline: polyline, route: route, style: YMKRouteHelper.createDefaultJamStyle())
            distance = min(route.metadata.weight.distance.text, distance)
        }
        changeDistanceValue(distance: distance, view)
    }
    
    private func changeDistanceValue(distance: String, _ view: NavigatorView) {
        let meters = String(distance.dropLast(3)).replacingOccurrences(of: ",", with: "")
        view.distanceText.text = "Shortest route: " + String(format: "%.1f", Double(meters)! * 1609.344)
                                  + " meters"
        view.distanceText.alpha = 1
    }
        
    private func onRoutesError(_ error: Error, _ view: NavigatorView) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
            
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
        view.present(alert, animated: true, completion: nil)
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
