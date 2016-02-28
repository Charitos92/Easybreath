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

 C++ Header with helper functions for the CvImage wrapper.
 Include this header in your C++ code with the OpenCV operations to perform.
 
*/

#ifndef CvMat_hpp
#define CvMat_hpp

#include "CvMat.h"

namespace cv
{
    struct Mat;
}

/**
    Recovers a (C++ based) cv::Mat from the Swift compatible CvMatPtr.

    @param mat: the pointer that Swift code will pass to C++.
    @returns: a fully-fledged OpenCV matrix.
*/
cv::Mat& recoverMat(CvMatPtr& mat);

/**
    Recovers a (C++ based) cv::Mat from the Swift compatible constant CvMatPtr.
 
    @param mat the constant pointer that Swift code will pass to C++.
    @returns a constant OpenCV matrix.
 */
const cv::Mat& recoverMat(const CvMatPtr& mat);


/**
    Create a (Swift compatible) CvMatPtr from a (C++ based) cv::Mat
*/
CvMatPtr makePtr(cv::Mat* mat);

#endif /* CvMat_hpp */
