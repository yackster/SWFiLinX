//
//  ExtUIImage.swift
//  iLinX
//
//  Created by Vikas Ninawe on 23/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//  Purpose: This is used to extend the functionality of UIImage.

import UIKit

extension UIImage{

    func correctImageOrientation0() -> UIImage?{
        var rotatedImage = UIImage();
        switch self.imageOrientation
        {
        case UIImage.Orientation.right:
            rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1, orientation:UIImage.Orientation.down);
            
        case UIImage.Orientation.down:
            rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1, orientation:UIImage.Orientation.left);
            
        case UIImage.Orientation.left:
            rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1, orientation:UIImage.Orientation.up);
            
        default:
            rotatedImage = UIImage(cgImage:self.cgImage!, scale: 1, orientation:UIImage.Orientation.right);
            
        }
        return rotatedImage;
    }
    
    func correctImageOrientation1() -> UIImage{
        if self.imageOrientation == UIImage.Orientation.up
        {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x:0, y:0, width:self.size.width, height:self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
    
    func correctImageOrientation() -> UIImage?{
        
        guard let cgImage = self.cgImage else{
            return nil
        }
        
        if self.imageOrientation == UIImage.Orientation.up{
            return self
        }
        
        let width  = self.size.width
        let height = self.size.height
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation{
            case .down, .downMirrored:
                transform = transform.translatedBy(x: width, y: height)
                transform = transform.rotated(by: CGFloat.pi)
            
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: width, y: 0)
                transform = transform.rotated(by: 0.5*CGFloat.pi)
            
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: height)
                transform = transform.rotated(by: -0.5*CGFloat.pi)
            
            case .up, .upMirrored:break
        }
        
        switch self.imageOrientation{
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            
            default:break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let colorSpace = cgImage.colorSpace else{
            return nil
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            ) else {
                return nil
        }
        
        context.concatenate(transform);
        
        switch self.imageOrientation{
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
            
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let newCGImg = context.makeImage() else{
            return nil
        }
        
        let img = UIImage(cgImage: newCGImg)
        
        return img;
    }


}
