//
//  ViewController.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit
import CoreLocation
import MapKit

class NavigatorView: UIViewController {

    private let presenter: INavigatorPresenter
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
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
    
    lazy var textStackView: UIStackView = {
        let textStack = UIStackView()
        textStack.axis = .vertical
        view.addSubview(textStack)
        textStack.spacing = 10
        [startLocation, endLocation].forEach { textField in
            textField.setHeight(to: NavigatorValues.buttonHeight)
            textField.delegate = self
            textStack.addArrangedSubview(textField)
        }
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
        
        mapView.delegate = self
        
        configureUI()
    }
    
    init(presenter: INavigatorPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    func configureUI() {
        view.addSubview(mapView)
        view.addSubview(textStackView)
        view.addSubview(buttonStackView, anchors: [.bottom(NavigatorValues.bottomConstraints),
                                                                  .leading(NavigatorValues.leadingConstraints),
                                                                  .trailing(NavigatorValues.trailingConstraints)])
        mapView.pin(to: view)
        textStackView.pin(to: view, [.top: 50, .left: 10, .right: 10])
    }
    
    func changeTextAndButtonsState() {
        startLocation.text = ""
        endLocation.text = ""
        goButton.setTitleColor(.gray, for: .disabled)
        goButton.isEnabled = false
        clearButton.setTitleColor(.gray, for: .disabled)
        clearButton.isEnabled = false
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

extension NavigatorView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
}

extension NavigatorView {
    @objc
    func clearButtonPressed(_ sender: UIButton) {
        presenter.clearButtonWasPressed()
    }
    
    @objc
    func goButtonPressed(_ sender: UIButton) {
        presenter.goButtonWasPressed()
    }
}
