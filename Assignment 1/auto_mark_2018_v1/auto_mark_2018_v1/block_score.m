% Block_score score the student's answer

% Z.Zhang 06/08/2017: Change name from chocolate_score to block_score
% Z.Zhang 06/08/2017: Change start message to version 1 of the 2017 MTRN4320
% Z.Zhang 06/08/2017: Check x, y, angle, colour, shape, upper, reachable
% Z.Zhang 06/08/2017: Block score is normalized by 7 instead of 5
% J.Tang  07/08/2017: Changed score calculation from ~xor to == due to
%                     non-binary inputs
% J.Tang  22/08/2017: Updated scoring method for angle
% Z.Zhang 13/08/2018: Changed upper score to letter score, 
% Only score the first N blocks in submission. N = number of block in
% reference.
% Handle special case for symetrical letters.


function total_score = block_score(ground_truth_dir, submission_dir, print_out)
    fprintf(print_out, 'This is version 1 of the 2018 MTRN4230 Assignment 1 scoring software\n\n');
    
    dist_threshold = 10;
    angle_threshold = 10*pi/180;
    
    ground_truth_files = txt_files_in_dir(ground_truth_dir);
    submission_files = txt_files_in_dir(submission_dir);
    
    ground_truth_map = load_rectangle_map(ground_truth_files);
    submission_map = load_rectangle_map(submission_files);
    
    scores = zeros(size(ground_truth_map, 1), 1);
    
    for I = 1:size(ground_truth_map, 1)
        ground_truth_file_name = ground_truth_map{I,2};
        for J = 1:size(submission_map, 1)
            submission_file_name = submission_map{J,2};
            if strcmp(ground_truth_file_name, submission_file_name)
                fprintf(print_out, 'Scoring image: %s\n', ground_truth_file_name);
                scores(I) = score_rectangles(ground_truth_map{I,1}, ...
                    submission_map{J,1}, dist_threshold, angle_threshold, print_out);
                fprintf(print_out, '\n');
                break;
            end
        end
    end
    
    total_score = print_results(ground_truth_map, scores, print_out);
    
end
function txt_files = txt_files_in_dir(dir_path)
    
    directory = dir(dir_path);
    txt_files = {};
    
    for I = 1:size(directory,1)
        if ~isempty(strfind(directory(I).name, '.txt'))
            txt_files{size(txt_files,1)+1, 1} = [dir_path, directory(I).name]; %#ok<AGROW>
        end
    end
end

function rectangle_map = load_rectangle_map(files)
    
    rectangle_map = cell(size(files,1), 2);
    
    for I = 1:size(files,1)
        [rectangles, file_name] = load_rectangles(files{I});
        rectangle_map{I,1} = rectangles;
        rectangle_map{I,2} = file_name;
    end
end

function [rectangles, file_name] = load_rectangles(file_path)
    
    fid = fopen(file_path);
    
    line = fgetl(fid);
    while ischar(line)
        
        if contains(line, 'image_file_name')
            line = fgetl(fid);
            file_name = strrep(line, '\n', '');
        elseif contains(line, 'rectangles')
            line = fgetl(fid);
            rectangles = [];
            while ischar(line)
                rectangles = [rectangles; sscanf(line, '%f')']; %#ok<AGROW>
                line = fgetl(fid);
            end
        end
        
        line = fgetl(fid);
        
    end
    
    if isempty(rectangles)
        rectangles = nan(1,8);
    end
    
    fclose(fid);
    
    % not sure what this line does
    %rectangles = rectangles(:, ~ismember(1:size(rectangles, 2), 3:4));
end

function score = score_rectangles(ground_truth_rectangles, ...
        submission_rectangles, dist_threshold, angle_threshold, print_out)
    
    % Select first n blocks.
    if size(submission_rectangles,1) > size(ground_truth_rectangles,1)
        submission_rectangles = submission_rectangles(1:size(ground_truth_rectangles,1),:);
        
    end
    
    ground_truth_positions = ground_truth_rectangles(:,1:2);
    submission_positions = submission_rectangles(:,1:2);
    
    
    valid_indices = cell(size(ground_truth_positions, 1), 1);
    
    % Find blocks within certain distance.
    for I = 1:size(ground_truth_positions, 1)
        
        dists = sqrt(sum(bsxfun(@minus, submission_positions, ...
            ground_truth_positions(I,:)).^2, 2));
        
        valid_indices{I,1} = find(dists < dist_threshold);
        
    end
    
    score = 0;
    fprintf(print_out, '[DETECTED] [ANGLE] [COLOUR] [SHAPE] [LETTER] [REACHABLE]\n');
    
    for I = 1:length(valid_indices)
        
        current_valid_indices = valid_indices{I};
        
        if ~isempty(current_valid_indices)
            
            min_current_scores = 100;
            for J = 1:length(current_valid_indices)
                current_scores = score_rectangle(ground_truth_rectangles(I,:), ...
                    submission_rectangles(current_valid_indices(J),:), ...
                    angle_threshold);
                if (sum(current_scores) < sum(min_current_scores))
                    min_current_scores = current_scores;
                end
            end
            
            fprintf(print_out, '[%8d] [%5d] [%6d] [%5d] [%13d] [%9d]\n', ...
                min_current_scores);
            
            score = score + sum(min_current_scores);
            
        else
            fprintf(print_out, '[       0] [    0] [      0] [        0]\n');
        end
    end
    score = score/(7*size(ground_truth_rectangles, 1));
end

function scores = score_rectangle(ground_truth_rectangle, ...
        submission_rectangle, angle_threshold)
    
    
    %%
    detected_score = 2;
    
    if ground_truth_rectangle(6) == 0 || ground_truth_rectangle(6) ==15 || ground_truth_rectangle(6) == 24  % Shape or letter O or X
        angle_range = pi/2;
    elseif ground_truth_rectangle(6)==8 ... % Letter H I N S Z
            || ground_truth_rectangle(6) == 9 ...
            || ground_truth_rectangle(6) == 14 ...
            || ground_truth_rectangle(6) == 19 ...
            || ground_truth_rectangle(6) == 26
        
        angle_range = pi;
    else
        angle_range = 2*pi; 
    end
    
    delta_angle = mod(ground_truth_rectangle(3),angle_range) - mod(submission_rectangle(3),angle_range);
    delta_angle2 = - abs(delta_angle) + angle_range; % Wrap around case, -abs(delta_angle) is always the negative difference, offset to 1 revolution give the correct value.
    angle_score = (-angle_threshold < delta_angle && delta_angle < angle_threshold) || (-angle_threshold < delta_angle2 && delta_angle2 < angle_threshold);

    colour_score = ground_truth_rectangle(4)== submission_rectangle(4);
    shape_score = ground_truth_rectangle(5)==submission_rectangle(5);
    letter_score = ground_truth_rectangle(6)==submission_rectangle(6);
    reachable_score = ground_truth_rectangle(7)==submission_rectangle(7);
    
    scores = [detected_score, angle_score, colour_score, shape_score, letter_score, reachable_score];
end

function total_score = print_results(ground_truth_map, scores, print_out)
    
    fprintf(print_out, '[       IMAGE] [SCORE]\n');
    for I = 1:size(ground_truth_map, 1)
        fprintf(print_out, '[%s] [%5d]\n', ground_truth_map{I,2}, round(scores(I)*100));
    end
    
    total_score = 100*sum(scores)/size(ground_truth_map, 1);
    fprintf(print_out, '\nTOTAL SCORE: %f\n', total_score);
end
