//
//  NumericDial.swift
//  GPB-Klangraum
//
//  Created by Alex on 02.10.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//

import UIKit

class NumericDial: UIControl
{
    let minimumValue = 0.0
    let maximumValue = 1.0
    let trackLayer = NumericDialTrack()
    let background = NumericDialBackground()
    let label = UILabel();
    let titleLabel = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        background.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(background)
        
        trackLayer.numericDial = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.blueColor()
        label.font = UIFont.systemFontOfSize(24)
        label.numberOfLines = 0
        self.addSubview(label)
        
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blueColor()
        
        self.addSubview(titleLabel)
        
        drawTrack()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        setCurrentValueFromLocation(touch.locationInView(self))
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        setCurrentValueFromLocation(touch.locationInView(self))
        
        return true
    }
    
    private func setCurrentValueFromLocation(location : CGPoint)
    {
        let angle = atan2(location.x - (frame.width / 2), location.y - (frame.height / 2)) * 180/CGFloat(M_PI)
        let distance = hypot(location.x - (frame.width / 2), location.y - (frame.height / 2))
        
        if distance > (frame.width / 2.0 * 0.6) && distance < frame.width / 2 && ((angle < -45 && angle > -180) || (angle < 180 && angle > 45))
        {
            currentValue = Float(getValueFromAngle(angle))
        }
        else if distance > (frame.width / 2.0 * 0.6) && distance < frame.width / 2 && (angle > -45 && angle < -35)
        {
            currentValue = 0
        }
        else if distance > (frame.width / 2.0 * 0.6) && distance < frame.width / 2 && (angle < 45 && angle > 35)
        {
            currentValue = 1
        }
    }
    
    var currentValue : Float = 0.0
        {
        didSet
        {
            currentValue = currentValue < 0 ? 0 : currentValue
            currentValue = currentValue > 1 ? 1 : currentValue
            
            sendActionsForControlEvents(.ValueChanged)
            drawTrack()
        }
    }
    
    var labelFunction : (Float) -> String = NumericDial.defaultLabelFunction
        {
        didSet
        {
            label.text = labelFunction(currentValue)
        }
    }
    
    var title : String = ""
        {
        didSet
        {
            titleLabel.text = title
        }
    }
    
    func drawTrack()
    {
        label.frame = bounds.insetBy(dx: 0, dy: 0)
        label.text = labelFunction(currentValue)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: 0.0)
        trackLayer.drawValueCurve()
    }
    
    override var frame: CGRect
        {
        didSet
        {
            background.frame = bounds.insetBy(dx: 0.0, dy: 0.0)
            background.drawBackgroundCurve()
            
            titleLabel.frame = CGRect(x: 0, y: frame.height - 23, width: frame.width, height: 20)
            
            drawTrack()
        }
    }
    
    final func getValueFromAngle(value : CGFloat) -> CGFloat
    {
        var returnNumber : CGFloat;
        
        if (value < 0)
        {
            returnNumber = (abs(value + 45) / 135) / 2;
        }
        else
        {
            returnNumber = 0.5 + (((181 - value) / 135) / 2) ;
        }
        
        return returnNumber;
    }
    
    class func defaultLabelFunction(value : Float) -> String
    {
        return NSString(format: "%.4f", value) as String
    }
}

class NumericDialTrack: CAShapeLayer
{
    weak var numericDial: NumericDial?
    
    final func drawValueCurve()
    {
        if let value = numericDial?.currentValue
        {
            strokeColor = UIColor.blueColor().CGColor
            lineWidth = 30
            fillColor = nil
            self.lineCap = "round"
            
            let angle : CGFloat = -135 + 270 * CGFloat(value)
            let centre = min(frame.width, frame.height) / 2.0
            let radius = centre - 20
            
            let valuePath = UIBezierPath(arcCenter: CGPoint(x: centre, y: centre), radius: radius, startAngle: 135 * CGFloat(M_PI)/180, endAngle: (angle - 90) * CGFloat(M_PI)/180, clockwise: true)
            
            path = valuePath.CGPath
            
        }
    }
}

class NumericDialBackground: CAShapeLayer
{
    
    final func drawBackgroundCurve()
    {
        strokeColor = UIColor.lightGrayColor().CGColor
        lineWidth = 40
        fillColor = nil
        self.lineCap = "round"
        
        let centre = min(frame.width, frame.height) / 2.0
        let radius = centre - 20
        
        let valuePath = UIBezierPath(arcCenter: CGPoint(x: centre, y: centre), radius: radius, startAngle: 135 * CGFloat(M_PI)/180, endAngle: 45 * CGFloat(M_PI)/180, clockwise: true)
        
        path = valuePath.CGPath
    }
}