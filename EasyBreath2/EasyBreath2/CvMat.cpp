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

#include "CvMat.hpp"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

// MARK: C++ HELPER METHODS

cv::Mat& recoverMat(CvMatPtr& mat)
{
    return *static_cast<cv::Mat*>(mat.ptr);
}

const cv::Mat& recoverMat(const CvMatPtr& mat)
{
    return *static_cast<const cv::Mat*>(mat.ptr);
}

CvMatPtr makePtr(cv::Mat* mat){
    return {mat};
}


// MARK: C INTERFACE

CvMatPtr initCvMat(int width, int height, bool grayscale)
{
    int flags = (grayscale) ? CV_8UC1 : CV_8UC4;
    return makePtr(new cv::Mat(height, width, flags) );
}

CvMatPtr initCvMatFromJPEGBuffer(const void* buf, int numberOfBytes)
{
    // This does NOT copy data
    // Note that we're not allowed to modify the underlying buffer!
    // Even if we cast away the buffer const-ness, we make the whole Mat const.
    const cv::Mat buffer(1, numberOfBytes, CV_8UC1, const_cast<void*>(buf) );
    
    auto result = new cv::Mat();
    cv::imdecode(buffer, cv::IMREAD_UNCHANGED, result);
    
    return makePtr(result);
    
}

CvMatPtr cloneCvMat(const CvMatPtr mat)
{
    // Clone and then copy into a pointer to a cv::Mat
    const auto& src = recoverMat(mat);
    return makePtr( new cv::Mat( src.clone() ));
}
void deleteCvMat(const CvMatPtr mat)
{
    delete static_cast<cv::Mat*>(mat.ptr);
}

bool isCvMatGrayscale(const CvMatPtr mat){
    return recoverMat(mat).channels() == 1;
}

int getHeightFromCvMat(const CvMatPtr mat){
    return recoverMat(mat).rows;
}

int getWidthFromCvMat(const CvMatPtr mat){
    return recoverMat(mat).cols;
}

int getElemSizeFromCvMat(const CvMatPtr mat){
    return static_cast<int>(recoverMat(mat).elemSize());
}

int getStepFromCvMat(const CvMatPtr mat){
    return static_cast<int>(recoverMat(mat).step[0]);
}

void* getRawDataFromCvMat(const CvMatPtr mat){
    return recoverMat(mat).data;
}