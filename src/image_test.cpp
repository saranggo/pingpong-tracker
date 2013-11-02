#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <vector>
#include <algorithm>
#include <stdlib.h>
#include <string>

using namespace std;
using namespace cv;

#define min_h 115
#define min_s 126
#define min_v 106
#define max_h 125
#define max_s 244
#define max_v 255

int main(int argc, char **argv)
{

        Mat img, img_hsv, img_roi;     
        string img_name;
        //vector<pair<float, float> > all_centers;
        //vector<pair<int, int> > ball_region;
        //map<int, vector<pair<int,int> > > ball_region_in_frame;
        //map<int, pair<float,float>  > ball_center_in_frame;          
        
        for(int img_num=atoi(argv[1]); img_num<=atoi(argv[2]); img_num++)
        {
                stringstream ss; ss<<img_num; img_name = "trial_images/image_color/frame00" + ss.str()+".jpg";
                
                float cx_roi=0.0, cy_roi=0.0;
                int npts_inside_roi;
                
                img = imread(img_name, CV_LOAD_IMAGE_COLOR);
                cvtColor(img, img_hsv,CV_RGB2HSV);
                
                for(int m=0; m<img_hsv.rows; m++)
                {
                        for(int n=0; n<img_hsv.cols; n++)
                 {
                       
                      if(               ( img_hsv.at<Vec3b>(m,n)[0]>=min_h && img_hsv.at<Vec3b>(m,n)[0]<=max_h ) 
                        &&            ( img_hsv.at<Vec3b>(m,n)[1]>=min_s && img_hsv.at<Vec3b>(m,n)[1]<=max_s )  
                        &&            ( img_hsv.at<Vec3b>(m,n)[2]>=min_v && img_hsv.at<Vec3b>(m,n)[2]<=max_v )  
                        )                        
                                        {
                                             //cout<<m<<" "<<n<<endl;
                                             img_hsv.at<Vec3b>(m,n)[0] =0; img_hsv.at<Vec3b>(m,n)[1] =0; img_hsv.at<Vec3b>(m,n)[2] =0;
                                             cx_roi = cx_roi + m;
                                             cy_roi = cy_roi + n;                        
                                             npts_inside_roi++;
                                             //ball_region.push_back(make_pair(m,n));
                                             img_hsv.at<Vec3b>(m,n)[0] =0; img_hsv.at<Vec3b>(m,n)[1] =0; img_hsv.at<Vec3b>(m,n)[2] =0;                                              
                                         }
                       else                
                                   {
                                             img_hsv.at<Vec3b>(m,n)[0] =255; img_hsv.at<Vec3b>(m,n)[1] =255; img_hsv.at<Vec3b>(m,n)[2] =255; 
                                   }
  
                 }
         }
       
       //for(int p=10; p<img_hsv.rows)
        img_roi = img_hsv;
        
        medianBlur(img_hsv, img_roi, 11);
        
        GaussianBlur( img_hsv, img_roi, Size( 5, 5 ), 0, 0 );
       
       int dil=0;
       Mat element = getStructuringElement( MORPH_RECT,
                                       Size( 2*dil + 1, 2*dil+1 ),
                                       Point( dil, dil ) );
                                       cout<<element<<endl;
       dilate( img_hsv, img_roi, element );
        //dilate(img_hsv, img_roi, 0, (-1,1), 1);
        
        namedWindow( "Display img_hsv", CV_WINDOW_NORMAL);
        imshow( "Display img_hsv", img_roi);
        
        for(int m=0; m<img_roi.rows; m++)
                {
                        for(int n=0; n<img_roi.cols; n++)
                 {
                       
                      if(               ( img_roi.at<Vec3b>(m,n)[0]==0 ) 
                        &&            (  img_roi.at<Vec3b>(m,n)[1]==0 )  
                        &&            (  img_roi.at<Vec3b>(m,n)[2]==0 )  
                        )                        
                                        {
                                             cout<<m<<" "<<n<<endl;
                                      
                                         }

                 }
         }
        waitKey(0);
         //cx_roi=cx_roi/npts_inside_roi;
         //cy_roi=cy_roi/npts_inside_roi;
         //ball_region_in_frame[img_num] = ball_region;
         //ball_center_in_frame[img_num] = make_pair(cx_roi,cy_roi);         
  }               
        return 0;
}


