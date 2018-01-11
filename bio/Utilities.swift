//
//  Utilities.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import Foundation
import Imaginary

class ResizeImageProcessor: ImageProcessor {

    var size: CGSize!

    init(size: CGSize) {
        self.size = size
    }

    func process(image: Image) -> Image {
        return image.resize(toSize: self.size)
    }
}

class SimpleImageViewDisplayer: ImageDisplayer {

    func display(placeholder: Image, onto view: View) {
        guard let imageView = view as? ImageView else { return }
        imageView.image = placeholder
    }

    func display(image: Image, onto view: View) {
        guard let imageView = view as? ImageView else { return }
        imageView.image = image
    }
}
