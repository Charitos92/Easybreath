/*
* Copyright (c) 2015, 2016 Miguel Sarabia
* Imperial College London
*
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import UIKit

/// Swift wrapper class for OpenCV matrices.
class CvMat {
    
    /// Matrix width (read-only property).
    var width : Int {
        get{
            return Int( getWidthFromCvMat(mat) )
        }
    }
    /// Matrix height (read-only property).
    var height : Int {
        get{
            return Int( getHeightFromCvMat(mat) )
        }
    }
    
    /// Read-only property which is true if matrix was created with one channel.
    var grayscale : Bool{
        get{
            return isCvMatGrayscale(mat)
        }
    }
    
    /// The orientation of the matrix (iOS will rotate it automatically).
    let orientation : UIImageOrientation
    
    /// Private handle to CvMatPtr
    private let mat: CvMatPtr
    
    /// Bitmap information for UIImage conversion
    private static let bitmapInfo =
        CGImageAlphaInfo.NoneSkipLast.rawValue | CGBitmapInfo.ByteOrderDefault.rawValue

    /**
        Designated, failable initialiser.
        
        - parameters:
            - handle: The CvMatPtr that this class will manage.
            - orientation: The orientation of the matrix (`Up` by default).
        
        - returns: The newly initialised CvMat; unless CvMatPtr is `nil`, in
        which case `nil` will be returned.
        
        - warning: CvMat takes ownership of the handle and will deallocate it on
        deinitialisation. Any other CvMat holding the same CvMatPtr may lead to
        a memory error.
    */
    init?(handle: CvMatPtr, orientation: UIImageOrientation = .Up){
        self.mat = handle
        self.orientation = orientation
        
        if handle.ptr == nil{
            return nil
        }
    }
    
    /**
        Convenience initialiser from factory method.
     
        - parameter factory: a function that takes no arguments and returns a
        valid CvMatPtr.
        
        - returns: The newly initialised CvMat, unless factory returns `nil`, in
        which case `nil` will be returned.
     
        - note: the factory function may be written in C/C++.
    */
    convenience init?(factory: (Void)->CvMatPtr){
        self.init(handle: factory())
    }
    
    /**
        Convenience initialiser from buffer of JPEG data.

        - parameters:
            - jpegData: the buffer containing the raw JPEG image data.
            - orientation: the orientation of the image (`Up` by default).
     
        - returns: The newly initialised CvMat.
    */
    convenience init?(jpegData: NSData, orientation: UIImageOrientation = .Up){
        let mat = initCvMatFromJPEGBuffer(jpegData.bytes, Int32(jpegData.length))
        self.init(handle:mat, orientation: orientation)
    }
    
    /**
        Convenience initialiser from iOS's UIImage.
        
        - parameter image: the image from which to initialise this matrix.
        - returns: the newly initialised CvMat.
    */
    convenience init?(image: UIImage){
        //Get image properties
        let colorSpace = CGImageGetColorSpace(image.CGImage)
        let grayscale = CGColorSpaceGetModel(colorSpace) == .Monochrome
        
        let orientation = image.imageOrientation
        let rotated = orientation == .Left || orientation == .LeftMirrored || orientation == .Right || orientation == .RightMirrored
        
        let width = (rotated) ? image.size.height : image.size.width
        let height = (rotated) ? image.size.width : image.size.height
        
        
        //Allocate cv mat
        let mat = initCvMat(Int32(width), Int32(height), grayscale)
        
        //Draw picture into raw array of data
        let context = CGBitmapContextCreate(
            getRawDataFromCvMat(mat),   // Pointer to  data
            Int(width),                 // Width of bitmap
            Int(height),                // Width of bitmap
            8,                          // Bits per component
            Int(getStepFromCvMat(mat)), // Bytes per row
            colorSpace,                 // Colorspace
            CvMat.bitmapInfo)
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage)
        
        self.init(handle: mat, orientation: orientation)
    }
    
    /// Deinitialiser: it deallocates CvMatPtr
    deinit{
        deleteCvMat(mat)
    }
    
    /**
        Create a copy of this CvMat.
     
        - returns: cloned copy of this object.
    */
    func clone()->CvMat{
        // We can force unwrap as it is our own function
        return apply(cloneCvMat)!
    }
    
    /**
        Convert CvMat to iOS' `UIImage`.
     
        - returns: newly initialised iOS' image with same pixels and
        orientation. Should CoreGraphics drawing function fail, this function
        will return `nil` instead.
    */
    func toUIImage() -> UIImage? {
        let width  = Int(getWidthFromCvMat(mat))
        let height = Int(getHeightFromCvMat(mat))
        let elemSize = Int(getElemSizeFromCvMat(mat))
        let step = Int(getStepFromCvMat(mat))
        
        let data  = NSData(bytes: getRawDataFromCvMat(mat), length: width*height*elemSize)
        
        let colorSpace = ( isCvMatGrayscale(mat) ) ?
            CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
        
        let provider = CGDataProviderCreateWithCFData(data);
        
        if let image = CGImageCreate(
            width,
            height,
            8, //bits per component
            8 * elemSize, //bits per pixel
            step, //bytes per row
            colorSpace,
            CGBitmapInfo(rawValue: CvMat.bitmapInfo),
            provider,
            nil, //decode
            false, //should interpolate
            CGColorRenderingIntent.RenderingIntentDefault){
        
            return UIImage(CGImage: image, scale: 1, orientation:orientation)
        }
        return nil
    }
    
    /**
        Apply a function to this CvMat and return new CvMat with result.
        
        - parameter filterFunc: a function that takes a CvMatPtr and returns
        a modified CvMatPtr.
     
        - returns: a new CvMat with the result, or `nil` if filterFunc failed to
        return a valid CvMatPtr.
     
        - note: the filterFunc function may be written in C/C++.
    */
    func apply(filterFunc: (CvMatPtr) -> CvMatPtr) -> CvMat?{
        return CvMat(handle: filterFunc(mat), orientation: self.orientation)
    }
    
    
    /**
        Apply a computation to this CvMat and return (usually numeric) result.
     
        - parameter filterFunc: a function that takes a CvMatPtr and returns the
        result of the desired computation (usually a number).
     
        - returns: the result of the filterFunc execution.
     
        - note: the filterFunc function may be written in C/C++.
    */
    func compute<T>(filterFunc: (CvMatPtr) -> T ) -> T{
        return filterFunc(mat)
    }
}