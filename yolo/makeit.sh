#!/bin/bash

python3 yolo_to_onnx.py -m yolov3-288
python3 yolo_to_onnx.py -m yolov3-416
python3 yolo_to_onnx.py -m yolov3-608
python3 onnx_to_tensorrt.py -m yolov3-288
python3 onnx_to_tensorrt.py -m yolov3-416
python3 onnx_to_tensorrt.py -m yolov3-608

set -e

models="yolov3-288 yolov3-416 yolov3-608"

# make sure all needed files are present
for m in ${models}; do
  if [[ ! -f ${m}.cfg ]]; then
    echo "ERROR: cannot find the file ${m}.cfg"
    exit 1
  fi
  if [[ ! -f ${m}.onnx ]]; then
    echo "ERROR: cannot find the file ${m}.onnx"
    exit 1
  fi
done

# create symbolic links to cfg and onnx files
for m in ${models}; do
  m_head=${m%-*}
  m_tail=${m##*-}
  ln -sf ${m}.cfg  ${m_head}-int8-${m_tail}.cfg
  ln -sf ${m}.onnx ${m_head}-int8-${m_tail}.onnx
done

# build TensorRT engines
for m in ${models}; do
  m_head=${m%-*}
  m_tail=${m##*-}
  echo ; echo === ${m_head}-int8-${m_tail} === ; echo
  python3 onnx_to_tensorrt.py --int8 -m ${m_head}-int8-${m_tail}
done

# create symbolic links to cfg and onnx files
for m in ${models}; do
  m_head=${m%-*}
  m_tail=${m##*-}
  ln -sf ${m}.cfg  ${m_head}-dla0-${m_tail}.cfg
  ln -sf ${m}.onnx ${m_head}-dla0-${m_tail}.onnx
  ln -sf ${m}.cfg  ${m_head}-dla1-${m_tail}.cfg
  ln -sf ${m}.onnx ${m_head}-dla1-${m_tail}.onnx
done

# build TensorRT engines
for m in ${models}; do
  m_head=${m%-*}
  m_tail=${m##*-}
  echo ; echo === ${m_head}-dla0-${m_tail} === ; echo
  python3 onnx_to_tensorrt.py --dla_core 0 -m ${m_head}-dla0-${m_tail}
  echo ; echo === ${m_head}-dla1-${m_tail} === ; echo
  python3 onnx_to_tensorrt.py --int8 --dla_core 1 -m ${m_head}-dla1-${m_tail}
done

echo
echo "Done."


