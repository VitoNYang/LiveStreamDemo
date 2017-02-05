//
//  Extension.swift
//  LiveStreamDemo
//
//  Created by hao Mac Mini on 2017/2/4.
//  Copyright © 2017年 Vito.Yang. All rights reserved.
//

import UIKit

extension UIColor {
    func createImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
}
