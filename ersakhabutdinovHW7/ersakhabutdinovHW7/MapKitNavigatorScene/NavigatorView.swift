import UIKit
import CoreLocation
import YandexMapsMobile

class NavigatorView: UIViewController {

    private let presenter: INavigatorPresenter
    
    private var cameraPosition = YMKCameraPosition()
    private var currentZoom: Float = 0
    var trafficLayer: YMKTrafficLayer!
    
    var shortestRoute: String?
    
    let mapView: YMKMapView = {
        let mapView = YMKMapView()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let startLocation: UITextField = {
        let control = UITextField()
        control.backgroundColor = UIColor.lightGray
        control.textColor = UIColor.black
        control.placeholder = "From"
        control.layer.cornerRadius = 2
        control.clipsToBounds = false
        control.font = UIFont.systemFont(ofSize: 15)
        control.borderStyle = UITextField.BorderStyle.roundedRect
        control.autocorrectionType = UITextAutocorrectionType.yes
        control.keyboardType = UIKeyboardType.default
        control.returnKeyType = UIReturnKeyType.done
        control.clearButtonMode =
            UITextField.ViewMode.whileEditing
        control.contentVerticalAlignment =
            UIControl.ContentVerticalAlignment.center
        return control
    }()
    
    let endLocation: UITextField = {
        let control = UITextField()
        control.backgroundColor = UIColor.lightGray
        control.textColor = UIColor.black
        control.placeholder = "To"
        control.layer.cornerRadius = 2
        control.clipsToBounds = false
        control.font = UIFont.systemFont(ofSize: 15)
        control.borderStyle = UITextField.BorderStyle.roundedRect
        control.autocorrectionType = UITextAutocorrectionType.yes
        control.keyboardType = UIKeyboardType.default
        control.returnKeyType = UIReturnKeyType.done
        control.clearButtonMode =
            UITextField.ViewMode.whileEditing
        control.contentVerticalAlignment =
            UIControl.ContentVerticalAlignment.center
        return control
    }()
    
    let distanceText: UITextView = {
        let text = UITextView()
        text.activate(anchors: [.height(NavigatorValues.buttonHeight)])
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 15)
        text.backgroundColor = .clear
        text.text = "help"
        text.alpha = 0
        return text
    }()
    
    lazy var textStackView: UIStackView = {
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 10
        [startLocation, endLocation].forEach { textField in
            textField.setHeight(to: NavigatorValues.buttonHeight)
            textField.delegate = self
            textStack.addArrangedSubview(textField)
        }
        textStack.addArrangedSubview(distanceText)
        return textStack
    }()
    
    let goButton: CustomButton = {
        let button = CustomButton(text: "Go", color: .cyan, frame: .zero)
        button.activate(anchors: [.height(NavigatorValues.buttonHeight)])
        button.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    let clearButton: CustomButton = {
        let button = CustomButton(text: "Clear", color: .white, frame: .zero)
        button.activate(anchors: [.height(NavigatorValues.buttonHeight)])
        button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    let zoomInButton: CustomButton = {
        let button = CustomButton(text: "+", color: .gray, frame: .zero)
        button.activate(anchors: [.height(NavigatorValues.buttonHeight)])
        button.addTarget(self, action: #selector(zoomInButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let zoomOutButton: CustomButton = {
        let button = CustomButton(text: "-", color: .gray, frame: .zero)
        button.activate(anchors: [.height(NavigatorValues.buttonHeight)])
        button.addTarget(self, action: #selector(zoomOutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var zoomStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [zoomInButton, zoomOutButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goButton, clearButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //mapView.delegate = self
        configureUI()
    }
    
    init(presenter: INavigatorPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    func configureUI() {
        view.addSubview(mapView)
        view.addSubview(textStackView)
        view.addSubview(textStackView)
        view.addSubview(buttonStackView, anchors: [.bottom(NavigatorValues.bottomConstraints),
                                                   .leading(NavigatorValues.leadingConstraints),
                                                   .trailing(NavigatorValues.trailingConstraints)])
        view.addSubview(zoomStackView, anchors: [.trailing(NavigatorValues.trailingConstraints),
                                                 .centerY(0)])
        mapView.pin(to: view)
        textStackView.pin(to: view, [.top: 50, .left: 10, .right: 10])
        trafficLayer = YMKMapKit.sharedInstance().createTrafficLayer(with: mapView.mapWindow)
        trafficLayer.addTrafficListener(withTrafficListener: self)
        mapView.mapWindow.map.addCameraListener(with: self)
        trafficLayer.setTrafficVisibleWithOn(true)
    }
    
    func changeTextAndButtonsState() {
        startLocation.text = ""
        endLocation.text = ""
        goButton.setTitleColor(.gray, for: .disabled)
        goButton.isEnabled = false
        clearButton.setTitleColor(.gray, for: .disabled)
        clearButton.isEnabled = false
    }
    
    func changeZoom(zoom: Float) {
        currentZoom += zoom
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: cameraPosition.target,
                                                        zoom: currentZoom, azimuth: 0, tilt: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigatorView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == endLocation && endLocation.hasText && startLocation.hasText) {
            presenter.goButtonWasPressed()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        clearButton.isEnabled = startLocation.text != "" || endLocation.text != ""
        goButton.isEnabled = startLocation.text != "" && endLocation.text != ""
    }
}

extension NavigatorView: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        self.cameraPosition = cameraPosition
        currentZoom = cameraPosition.zoom
    }
}

extension NavigatorView: YMKTrafficDelegate {
    func onTrafficLoading() {
        
    }
    
    func onTrafficExpired() {
        
    }
    
    func onTrafficChanged(with trafficLevel: YMKTrafficLevel?) {
        guard trafficLevel != nil else {
            return
        }
    }
}

//extension NavigatorView: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = UIColor.blue
//        return renderer
//    }
//}


extension NavigatorView {
    @objc
    func clearButtonPressed(_ sender: UIButton) {
        presenter.clearButtonWasPressed()
    }
    
    @objc
    func goButtonPressed(_ sender: UIButton) {
        presenter.goButtonWasPressed()
    }
    
    @objc
    func zoomInButtonPressed(_ sender: UIButton) {
        presenter.zoomButtonWasPressed(zoom: 1)
    }
    
    @objc
    func zoomOutButtonPressed(_ sender: UIButton) {
        presenter.zoomButtonWasPressed(zoom: -1)
    }
}
