
#ifndef __PROJECT_CONFIG__
#define __PROJECT_CONFIG__

#define DBG
#define IMG_PATH "H:\\Private\\Fall 13\\Project\\pingpong-tracker\\trunk\\trial_images2"
#define USE_TEST_IMAGES
#define _g_ 9.81
#define CAMERA_MATRIX_RGB { {525, 0, 319.5},  {0, 525, 239.5},  {0, 0, 1}}
#define CAMERA_MATRIX_DEPTH {{575.8175, 0, 314.5},  {0, 575.8175, 325.06},  {0, 0, 1}}
#define RGB_TO_DEPTH {{1, 0, 0, -0.025},  {0, 1, 0, 0},  {0, 0, 1, 0}}
#define IMAGE_RECT Rect(0,0,640,480)

#endif
