#include <opencv2/opencv.hpp>
#include "config.h"

using namespace cv;
using namespace std;

Rect getWindow(Rect original, float multiplier, float offset, Rect limit = Rect()) {
	Rect newWindow;

	float maxHW = MAX(original.width, original.height);
	newWindow.x = MAX(limit.x, original.x - maxHW * multiplier / 2 - offset);
	newWindow.width = maxHW * multiplier + 2 * offset;
	newWindow.width = MIN(newWindow.width + newWindow.x, limit.x + limit.width) - newWindow.x;
	newWindow.y = MAX(limit.y, original.y - maxHW * multiplier / 2 - offset);
	newWindow.height = maxHW * multiplier + 2 * offset;
	newWindow.height = MIN(newWindow.height + newWindow.y, limit.y + limit.height) - newWindow.y;

	return newWindow;
}
