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
}
