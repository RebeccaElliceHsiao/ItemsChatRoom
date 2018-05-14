//
//  ImageView.swift
//  omni
//
//  Created by Rebecca Hsiao on 2018/05/06.
//  Copyright © 2018年 Rebecca Hsiao. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    func configure(with url: String) {
        let imageUrl:URL = URL(string: url)!
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData:NSData = NSData(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.image = image
                }
            } else {
                self.image = nil
            }
        }
    }

}
