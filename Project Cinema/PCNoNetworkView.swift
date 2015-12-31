//
//  PCNoNetworkView.swift
//  Project Cinema
//
//  Created by Dino Praso on 31.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCNoNetworkView {
    
    class func getView(width: CGFloat) -> UIView {
        
        let connectionBanner = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        connectionBanner.backgroundColor = UIColor.redColor()
        
        let connectionBannerLabel = UILabel(frame: connectionBanner.frame)
        connectionBannerLabel.textColor = UIColor.blueColor()
        connectionBannerLabel.textAlignment = .Center
        
        connectionBannerLabel.attributedText = NSAttributedString(string: "No Internet Connection", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)])
        
        return connectionBannerLabel
    
    }

}
