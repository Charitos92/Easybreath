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

/**
 
 C header with functions required for the implementation of Swift's CvMat.
 
 Include this header in your bridging header or any header that may be included
 in your briding header.
 
 */

#ifndef CvMat_h
#define CvMat_h

#ifdef __cplusplus
extern "C"{
#endif
    
    /// Structure to pass OpenCV matrices between Swift and C++
    typedef struct { void* ptr; } CvMatPtr;
    
    /**
        Create a new OpenCV matrix with certain dimensions and several 8bit
        channels: one channel for grayscale, 4 for rgba.
     
        @param width matrix width.
        @param height matrix height.
        @param grayscale if true only one channel is used, otherwise 4 channels
        (RGBA) are used.
        @returns The newly allocated matrix in Swift-compatible format.
    */
    CvMatPtr initCvMat(int width, int height, bool grayscale);
    
    /**
        Create a new OpenCV matrix from a JPEG image buffer.
     
        @param buf pointer to data buffer where image is stored.
        @param numberOfBytes length of the buffer.
        @returns The newly allocated matrix in Swift-compatible format.
    */
    CvMatPtr initCvMatFromJPEGBuffer(const void* buf, int numberOfBytes);
    
    /**
        Create a new copy of an already existing OpenCV matrix.
     
        @param mat The matrix to be cloned (in Swift-compatible format).
        @returns The newly allocated matrix in Swift-compatible format.
    */
    
    CvMatPtr cloneCvMat(const CvMatPtr mat);
    /**
        Delete an existing OpenCV matrix.
        
        @param mat the matrix to be deleted in Swift-compatible format.
    */
    void deleteCvMat(const CvMatPtr mat);
    
    /**
        Check whether a matrix is grayscale or not.
     
        @param mat the matrix to check.
        @returns True if mat is grayscale, false otherwise.
    */
    bool isCvMatGrayscale(const CvMatPtr mat);
    
    /**
        Get the height of an OpenCV matrix.
     
        @param mat the matrix to check.
        @returns The number of rows in the matrix (ie. the height).
    */
    int getHeightFromCvMat(const CvMatPtr mat);
    
    /**
        Get the width of an OpenCV matrix.
     
        @param mat the matrix to check.
        @returns The number of columns in the matrix (ie. the width).
     */
    int getWidthFromCvMat(const CvMatPtr mat);
    
    /**
        Get the size of an OpenCV matrix's cell.
     
        @param mat the matrix to check.
        @returns The number of bytes in each cell (or pixel) of the matrix.
     */
    int getElemSizeFromCvMat(const CvMatPtr mat);
    
    /**
        Get the size of an OpenCV matrix's row.
        
        @param mat the matrix to check.
        @returns The number of bytes in each full row of the matrix.
        @note This is not always necessarily the same as elemSize*width.
    */
    int getStepFromCvMat(const CvMatPtr mat);
    
    /**
        Get a pointer to the raw data of an OpenCV matrix.
     
        @param mat The matrix from which the data will be obtained.
        @returns a void pointer to the underlying data.
        @warning Careless use of this function may cause data corruption and
        crashes.
    */
    void* getRawDataFromCvMat(CvMatPtr mat);
    
    
    
#ifdef __cplusplus
}
#endif

#endif /* CvMat_h */
