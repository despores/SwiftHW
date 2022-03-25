//
//  ButtonStackView.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit

class ButtonStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        setupStackView()
    }
    
    func setupStackView() {
        let goButton = CustomButton(text: "Go", color: .blue, frame: .zero)
        let clearButton = CustomButton(text: "Clear", color: .gray, frame: .zero)
        self.addArrangedSubview(goButton)
        self.addArrangedSubview(clearButton)
        //goButton.pinLeft(to: self)
        //clearButton.pinRight(to: self)
        self.axis = .horizontal
        self.spacing = 16.0
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
