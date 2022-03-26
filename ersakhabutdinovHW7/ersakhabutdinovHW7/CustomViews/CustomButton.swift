//
//  CustomButton.swift
//  ersakhabutdinovHW7
//
//  Created by Эрнест Сахабутдинов on 24.03.2022.
//

import UIKit

class CustomButton: UIButton {
    
    init(text: String, color: UIColor, frame: CGRect) {
        super.init(frame: frame)
        setTitle(text, for: .normal)
        backgroundColor = color
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 10.0
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        let animationClosure = { [weak self] in
            guard let self = self else {
                return
            }
            self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            self.alpha = 0.8
           }
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: animationClosure) { _ in
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
