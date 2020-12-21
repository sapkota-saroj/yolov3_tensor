************************** README ******************************
1. clone the repository
2. cd yolov3_tensor
3. install protobuf and pycuda if previously not installed
4. sudo pip3 install onnx==1.4.1
5. cd ${HOME}/yolov3_tensor/plugins
   $ make
6. cd ${HOME}/yolov3_tensor/yolo => downloads required cfg and weight files with different width and height
   $ ./download_yolo.sh
7. $ python3 yolo_to_onnx.py -m yolov3-416
8. $ python3 onnx_to_tensorrt.py -m yolov3-416
9. cd ../
   $ python3 trt_yolo.py -m yolov3-416 --video <video.mp4>
10. for real time detection::: 
   $ python3 trt_yolo.py -m yolov3-416 --usb 0


Int8 and DLA operation:::::::::::::::
1. Download Coco Data set and select randomly around 1000 images from val2014 for calibration. For this simply run selection.py
2. cd ${HOME}/yolov3_tensor/yolo 
   Now, Build the INT8 TensorRT engin. Here we will use yolov3-416 as reference:
3. Create link file for int-8 cfg and onnx as:
 $ ln -s yolov3-416.cfg yolov3-int8-416.cfg
 $ ln -s yolov3-416.onnx yolov3-int8-416.onnx
4. Creating trt Engine as:::
 $ python3 onnx_to_tensorrt.py -v --int8 -m yolov3-int8-608
5. For running video and webcam :: cd ../ & 
  $ python3 trt_yolo.py -m yolov3-int8-416 --video <video.mp4>
  $ python3 trt_yolo.py -m yolov3-int8-416 --usb 0

6. Creating DLA Enigne. Here we will use yolov3-416 as refrence:::
 $ ln -s yolov3-416.cfg yolov3-dla0-416.cfg
 $ ln -s yolov3-416.onnx yolov3-dla0-416.onnx
7. Creating DLA enabled engine:::
 for int8::
 $ python3 onnx_to_tensorrt.py -v --int8 --dla_core 0 -m yolov3-dla0-416
 for fp16::
 $ python3 onnx_to_tensorrt.py -v --dla_core 0 -m yolov3-dla0-416

8. For running video and webcam :: cd ../ & 
  $ python3 trt_yolo.py -m yolov3-dla0-416 --video <video.mp4>
  $ python3 trt_yolo.py -m yolov3-dla0-416 --usb 0
