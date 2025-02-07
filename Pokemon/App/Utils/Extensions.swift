//
//  Extensions.swift
//  Pokemon
//
//  Created by Diggo Silva on 02/06/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach({ addSubview($0.self) })
    }
    
    func buildImageLogo() -> UIImageView {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "logo")
        img.contentMode = .scaleAspectFit
        return img
    }
    
    func buildTextField(placeholder: String, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = placeholder
        tf.clearButtonMode = .whileEditing
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = keyboardType
        tf.isSecureTextEntry = isSecureTextEntry
        return tf
    }
    
    func buildButton(title: String, color: UIColor, selector: Selector) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .dynamic
        
        let btn = UIButton(configuration: configuration)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    
    func buildButtonWith2Texts(title1: String,title2: String, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: title1, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.link])
        attributedTitle.append(NSAttributedString(string: title2, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.link]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    func buildSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        return spinner
    }
}
