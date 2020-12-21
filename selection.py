import shutil
import glob
import random

dest="/path/to/yolov3_tensor/yolo/calib_images" #destination folder
to_be_moved = random.sample(glob.glob("/path_to/val2014/*.jpg"), 600)

for f in to_be_moved:
	shutil.copy(f, dest)
