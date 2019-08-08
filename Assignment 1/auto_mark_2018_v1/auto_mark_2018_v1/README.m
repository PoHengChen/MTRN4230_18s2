MTRN4230_Assignment_1_Auto_Mark(...
'./training_set/', './student_submissions/', './student_results/',...
'./training_labels/', './student_marks/', 600);

% The structure of the auto marker is as follows:
% 
% - auto_mark_updated
% 	- student_marks
% 	- student_results
% 	- student_submissions
% 		- PUT YOUR z0000000_MTRN4230_ASST1 folder in here
% 			- PUT YOUR z0000000_MTRN4230_ASST1.m file and any other files in here
% 	- training_labels
% 		- Contains the result of the test images
% 	- training_set
% 		- Contains the test images
% 
% You can run it as follows:
% 
% MTRN4230_Assignment_1_Auto_Mark('./training_set/', './student_submissions/', './student_results/', './training_labels/', './student_marks/', 600);
% 
% Once this has finished running, you can view the results in the student_marks folder. You do not need to run the chocolate_score script. Note that the final variable passed into this function is the time allowed for your processing to run in seconds.
% 
% Due to the way the auto-marking is set up, your code will not be running from within the directory that it is in. As a result, your function must follow the template which has been uploaded.
% 
% The variable program_folder will be the folder that your program is in. This will allow you to open files such as your template images from within this folder.
% 
% Please be very careful about what you name your folder and function. They MUST be:
% 
% z0000000_MTRN4230_ASST1
% 
% and:
% 
% z0000000_MTRN4230_ASST1.m
% 
% Where 0000000 is your student number.