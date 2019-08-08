# Robotics-UNSW-MTRN4230
mtrn4230 2018-S2 Coursepack

# Assignemnt 1 - Image Processing & Computer Vision
## 1. Image pre-process (obtain mask)
  ### 1.1 Adjust YCbCr

## 2. Split connected blocks (obtain [x,y,theta])

  ### 2.1 Boundary
  * Store the boundary coordinate
  
  ![image](https://github.com/PoHengChen/Robotics-UNSW-MTRN4230/blob/master/123.jpg)
  ### 2.2 DouglasPeucker
  * [DouglasPeucker](https://au.mathworks.com/matlabcentral/fileexchange/61046-douglas-peucker-algorithm) - DouglasPeucker Algorithm  decimates a curve composed of line segments to a similar curve with fewer points.
  * Green dots are the result of DouglasPeucker algo
  
  ![image](https://github.com/PoHengChen/Robotics-UNSW-MTRN4230/blob/master/DP.jpg)
  ### 2.3 Corner
  * to find the corner, check pixel between two adjacent pixel have angle around 90 degree
  * Green dots with blue cross are the corner
  
  ![image](https://github.com/PoHengChen/Robotics-UNSW-MTRN4230/blob/master/Corner.jpg)
  ### 2.4 Center
  * use corner pixels and vector to find block's center
  * pink dots represent the processed block center
  * yellow line represent the vector of corner and center
  
  ![image](https://github.com/PoHengChen/Robotics-UNSW-MTRN4230/blob/master/Store%26Cut.jpg)
  ### 2.5 Store & Cut
  * store the current batch block data and eliminate the processed area on the mask
  
  ![image](https://github.com/PoHengChen/Robotics-UNSW-MTRN4230/blob/master/current%20target.jpg)
  ![image](https://github.com/PoHengChen/Robotics-UNSW-MTRN4230/blob/master/residual%20area.jpg)
  
  * normally, if the block mask have connection, surrounding blocks will be processed first
  * some blocks in current target area that could not be processed in current batch will be keep to following batch
  * interior blocks's corner will be easier to find after surrounding blocks are eliminated
## 3. classify blocks information (obtain [color, shape, letter, reachability])


-> data for CNN training
mannually crop the block data from sample images, classify the cropped
Shape: using neural network
Color: using neural network
Character: using MATLAB built-in function OCR(Optical Character Recognition) to classify letters
Block angle:
  -  shape block:
  - letter block:

# Assignemnt 2 - Robot System Integration

# Assignemnt 3 - Full System Demo
