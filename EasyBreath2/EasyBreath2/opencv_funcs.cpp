//
//  opencv_funcs.cpp
//  EasyBreath2
//
//  Created by Mark Zolotas on 27/02/2016.
//  Copyright © 2016 Charitos Charitou. All rights reserved.
//

#include <stdio.h>
#include "opencv_funcs.h" // For our functions definitions
#include "CvMat.hpp" // For recover() & makePtr() functions
#include <opencv2/core.hpp> // OpenCV core
#include <opencv2/ml.hpp> // OpenCV machine learning
#include <opencv2/highgui.hpp> // OpenCV gui

cv::Mat setupTrainingData()
{
    // Set up training data required for SVM learning
    float labels[4] = {0.0, 0.0, 1.0, 1.0};
    cv::Mat labelsMat(4, 1, CV_32FC1, labels);
    
    float stressTrainingData[4][2] = { {81.52, 0.75}, {77.75, 0.79}, {92.59, 0.67}, {101.90, 0.60} };
    
    cv::Mat stressTrainingTable(4, 2, CV_32FC1, stressTrainingData);
    
    return stressTrainingTable;
}

void trainSVM()
{
    // Data for visual representation
    int width = 512, height = 512;
    cv::Mat image = cv::Mat::zeros(height, width, CV_8UC3);
    
    // Set up SVM's parameters:
    // Type --> C_SVC
    // Kernel --> Linear
    // TermCriterion --> Iter
   // cv::ml::SVM::setType(100);
    
   /* params.svm_type    = CvSVM::C_SVC;
    params.kernel_type = CvSVM::LINEAR;
    params.term_crit   = cvTermCriteria(CV_TERMCRIT_ITER, 100, 1e-6);*/
    

}

double computeAverageRed(const CvMatPtr mat)
{
    // Recover cv::Mat from CvMatPtr
    const cv::Mat& src = recoverMat(mat);
    
    // This computes the mean in every image channel
    cv::Scalar result = cv::mean(src);
    
    // Return the mean of the first channel
    return result[0];
}

/*CvMatPtr applySobel(const CvMatPtr mat){
    // Recover cv::Mat from CvMatPtr
    const cv::Mat& src = recoverMat(mat);
    
    // Temporary matrices
    cv::Mat src_gray;
    cv::Mat grad_x;
    cv::Mat grad_y;
    cv::Mat abs_grad_x;
    cv::Mat abs_grad_y;
    cv::Mat grad;
    
    // Result matrix, create with new!
    cv::Mat* result = new cv::Mat();
    
    // Convert to grayscale
    cv::cvtColor(src, src_gray, CV_RGBA2GRAY);
    
    // Apply Sobel horizontally
    cv::Sobel(src_gray, grad_x, CV_32F, 1, 0);
    // Apply Sobel vertically
    cv::Sobel(src_gray, grad_y, CV_32F, 0, 1);
    
    // Scale both matrices to the range [0-255]
    cv::convertScaleAbs(grad_x, abs_grad_x);
    cv::convertScaleAbs(grad_y, abs_grad_y);
    
    // Add a linear combination of horizontal
    // and vertical Sobel matrices.
    cv::addWeighted(
                    abs_grad_x, 0.5,
                    abs_grad_y, 0.5,
                    0, *result);
    
    return makePtr(result);
}*/