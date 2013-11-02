#include <stdio.h>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

int main(int argc, char **argv)
{                
                Mat img = imread(argv[1], CV_LOAD_IMAGE_COLOR), img_roi;
                cvtColor(img, img_roi,CV_RGB2HSV);
                
                int max_h=0, max_s=0, max_v=0, min_h=260, min_s=260, min_v=260;
                
                for(int m=0; m<img_roi.rows; m++)
                {
                    for(int n=0; n<img_roi.cols; n++)
                    {
                        int p=m-7; int q=n-7;
                        if((p*p)+(q*q)<49)
                        {
                                        //cout<<m<<" "<<n<<endl;
                                        if(img_roi.at<Vec3b>(m,n)[0]>max_h)      max_h=img_roi.at<Vec3b>(m,n)[0];
                                        if(img_roi.at<Vec3b>(m,n)[0]<min_h)      min_h=img_roi.at<Vec3b>(m,n)[0];
                                 
                                        if(img_roi.at<Vec3b>(m,n)[1]>max_s)      max_s=img_roi.at<Vec3b>(m,n)[1];
                                        if(img_roi.at<Vec3b>(m,n)[1]<min_s)      min_s=img_roi.at<Vec3b>(m,n)[1];
                                
                                        if(img_roi.at<Vec3b>(m,n)[2]>max_v)      max_v=img_roi.at<Vec3b>(m,n)[2];
                                        if(img_roi.at<Vec3b>(m,n)[2]<min_v)      min_v=img_roi.at<Vec3b>(m,n)[2];
                                
                                        img_roi.at<Vec3b>(m,n)[0]=0; img_roi.at<Vec3b>(m,n)[1]=0; img_roi.at<Vec3b>(m,n)[2]=0;
                       }
              
                       else                
                       {
                                       img_roi.at<Vec3b>(m,n)[0] =255; img_roi.at<Vec3b>(m,n)[1] =255; img_roi.at<Vec3b>(m,n)[2] =255; 
                       } 
                 }
               }
        cout<<max_h<<" "<<max_s<<" "<<max_v<<endl<<min_h<<" "<<min_s<<" "<<min_v<<endl;
        
        namedWindow( "ROI Image", CV_WINDOW_NORMAL);
        imshow( "ROI Image", img_roi);
        
        waitKey(0);        
        return 0;
}

