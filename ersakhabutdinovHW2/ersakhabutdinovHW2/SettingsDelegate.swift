//
//  SettingsDelegate.swift
//  ersakhabutdinovHW2
//
//  Created by Эрнест Сахабутдинов on 28.09.2021.
//

import UIKit
import CoreLocation

protocol SettingsDelegate: AnyObject {
    func changeToggleSettings(switchIsOn: Bool)
    func changeLocationSettings(_ sender: UISwitch)
    func changeSliderSettings(sliders: [UISlider])
}
