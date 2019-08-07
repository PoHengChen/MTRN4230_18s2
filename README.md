# Robotics-UNSW-MTRN4230
mtrn4230 2018-S2 Coursepack

## 1. Image pre-process (obtain mask)
  ### 1.1 Adjust YCbCr

## 2. Split connected blocks (obtain [x,y,theta])

  ### 2.1 Boundary
  ### 2.2 DouglasPeucker
  *[DouglasPeucker](https://au.mathworks.com/matlabcentral/fileexchange/61046-douglas-peucker-algorithm)
  ### 2.3 Corner
  ### 2.4 Center
  ### 2.5 Store & Cut
## 3. classify blocks information (obtain [color, shape, letter, reachability])


-> data for CNN training
mannually crop the block data from sample images, classify the cropped
Shape: using neural network
Color: using neural network
Character: using MATLAB built-in function OCR(Optical Character Recognition) to classify letters
Block angle:
  -  shape block:
  - letter block:
