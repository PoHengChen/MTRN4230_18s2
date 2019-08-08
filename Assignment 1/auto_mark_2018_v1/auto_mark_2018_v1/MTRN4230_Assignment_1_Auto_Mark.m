% Z.Zhang 06/08/2017: Ignore '.' and '..' folder.
% Z.Zhang 06/08/2017: Ignore error if output folder already exist.
% Z.Zhang 06/08/2017: Changed assignment file format to _ASST1.
% Z.Zhang 06/08/2017: Add end to function.
% Z.Zhang 06/08/2017; Change chocolate_score to block_score.
% Z.Zhang 06.08/2017: Change name to MTRN4230_Assignment_1_Auto_Mark
%

function MTRN4230_Assignment_1_Auto_Mark(OFFICIAL_image_dir, ...
        OFFICIAL_student_submissions_dir, OFFICIAL_student_output_dir, ...
        OFFICIAL_ground_truth_dir, OFFICIAL_mark_output_dir, ...
        OFFICIAL_max_time_seconds)
    
    fprintf('This is version 1 of the MTRN4230 auto-marking software\n');
    
    OFFICIAL_image_files = jpg_files_in_dir(OFFICIAL_image_dir);
    
    OFFICIAL_student_submissions = dir([OFFICIAL_student_submissions_dir '/z*']);
    
    OFFICIAL_student_number_strs = {};
    OFFICIAL_student_run_times = [];
    
    % Iterate over all of the student's submissions.
    for OFFICIAL_student_I = 1:size(OFFICIAL_student_submissions, 1)
        
        % Student's submissions must be in their own directory.
        if (OFFICIAL_student_submissions(OFFICIAL_student_I).isdir)
            
            % Get the student number.
            OFFICIAL_student_folder = OFFICIAL_student_submissions(OFFICIAL_student_I).name;
            OFFICIAL_student_number_str = student_number_str_from_dir(OFFICIAL_student_folder);
            
            if numel(OFFICIAL_student_number_str) == 0
                fprintf([OFFICIAL_student_folder, ' is not a valid directory name, it must be of the form zXXXXXXX_MTRN4230_ASST1\n']);
                continue;
            end
            
            % Add the current student number to the list of student numbers.
            OFFICIAL_student_number_strs{size(OFFICIAL_student_number_strs,1)+1, 1} = ...
                OFFICIAL_student_number_str; %#ok<AGROW>
            
            % Get a handle to the student's function.
            OFFICIAL_student_func = ...
                str2func(['z', OFFICIAL_student_number_str, '_MTRN4230_ASST1']);
            
            % Make the student's output folder.
            OFFICIAL_student_output_folder = ...
                [OFFICIAL_student_output_dir, OFFICIAL_student_folder, '_marks'];
            [status, msg, msgID] = mkdir(OFFICIAL_student_output_folder);
            
            % Add the student's folder to the path.
            addpath([OFFICIAL_student_submissions_dir, OFFICIAL_student_folder]);
            
            % Record the start time.
            OFFICIAL_start_time = tic;
            OFFICIAL_run_time = toc(OFFICIAL_start_time);
            
            % Iterate over all the images in the image directory.
            for OFFICIAL_image_I = 1:size(OFFICIAL_image_files, 1)
                
                % Stop if we have reached the time limit.
                if OFFICIAL_run_time > OFFICIAL_max_time_seconds
                    break;
                end
                
                % Call the student's function.
                try
                    fprintf(['Assessing student <', OFFICIAL_student_number_str, ...
                        '> on file <', OFFICIAL_image_files{OFFICIAL_image_I}, ...
                        '> with current run time <%f>\n'], OFFICIAL_run_time);
                    OFFICIAL_student_func([OFFICIAL_image_dir, OFFICIAL_image_files{OFFICIAL_image_I}], ...
                        OFFICIAL_image_files{OFFICIAL_image_I}, ...
                        [OFFICIAL_student_output_folder, '/', jpg_to_txt(OFFICIAL_image_files{OFFICIAL_image_I})], ...
                        [OFFICIAL_student_submissions_dir, OFFICIAL_student_folder, '/']);
                catch OFFICIAL_error
                    fprintf(['Caught error <', OFFICIAL_error.message, ...
                        '> for student <', OFFICIAL_student_number_str, ...
                        '> when evaluating file <', OFFICIAL_image_files{OFFICIAL_image_I}, '>\n']);
                end
                
                % Record the current time.
                OFFICIAL_run_time = toc(OFFICIAL_start_time);
                
            end
            
            OFFICIAL_student_run_times = [OFFICIAL_student_run_times; ...
                OFFICIAL_run_time]; %#ok<AGROW>
            
            % Remove the student's folder to the path.
            rmpath([OFFICIAL_student_submissions_dir, OFFICIAL_student_folder]);
            
            % Clear all of the student's variables.
            clear -regexp ^(?!OFFICIAL_).+
            
            % Close all files in case students don't.
            fclose all;
            
            % Close any plots the students may have drawn;
            close all;
            
        end
        
    end
    
    OFFICIAL_student_mark_folders = dir(OFFICIAL_student_output_dir);
    
    OFFICIAL_all_marks_fid = fopen([OFFICIAL_mark_output_dir, ...
        'all_marks.txt'], 'w');
    
    for OFFICIAL_student_mark_I = 1:size(OFFICIAL_student_mark_folders)
        
        OFFICIAL_current_student_folder = ...
            OFFICIAL_student_mark_folders(OFFICIAL_student_mark_I).name;
        
        OFFICIAL_current_student_number_str = ...
            student_number_str_from_dir(OFFICIAL_current_student_folder);
        
        if numel(OFFICIAL_current_student_number_str) == 0
            continue;
        end
        
        OFFICIAL_student_mark_fid  = ...
            fopen([OFFICIAL_mark_output_dir, ...
            'z', OFFICIAL_current_student_number_str, '.txt'], 'w');
        
        OFFICIAL_student_score = block_score(OFFICIAL_ground_truth_dir, ...
            [OFFICIAL_student_output_dir, OFFICIAL_current_student_folder, '/'], ...
            OFFICIAL_student_mark_fid);
        
        for OFFICIAL_student_number_I = 1:size(OFFICIAL_student_number_strs, 1)
            if strcmp(OFFICIAL_current_student_number_str, ...
                    OFFICIAL_student_number_strs{OFFICIAL_student_number_I})
                
                fprintf(OFFICIAL_student_mark_fid, ...
                    'Total run time: %f', ...
                    OFFICIAL_student_run_times(OFFICIAL_student_number_I));
                
                fprintf(OFFICIAL_all_marks_fid, ['Student number: ', ...
                    OFFICIAL_current_student_number_str, ...
                    ' score: %f\n'], OFFICIAL_student_score);
                
            end
        end
        
        fclose(OFFICIAL_student_mark_fid);
        
    end
    
    fclose(OFFICIAL_all_marks_fid);
end

function jpg_files = jpg_files_in_dir(dir_path)
    
    directory = dir(dir_path);
    jpg_files = {};
    
    for I = 1:size(directory,1)
        if ~isempty(strfind(directory(I).name, '.jpg'))
            jpg_files{size(jpg_files,1)+1, 1} = directory(I).name; %#ok<AGROW>
        end
    end
    
end
function student_number_str = student_number_str_from_dir(student_number_dir)
    
    student_number_str = ...
        student_number_dir(2:(strfind(student_number_dir, '_MTRN4230_ASST1') - 1));
end

function jpg_filename = jpg_to_txt(txt_filename)
    
    jpg_filename = [txt_filename(1:(strfind(txt_filename, '.jpg') - 1)), '.txt'];
end
