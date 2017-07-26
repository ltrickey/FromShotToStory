//
//  insetLabel.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/26/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit

class insetLabel: UILabel {

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
    }
}

