function [c,deg] = character_ocr(im,deg)
    show3 = 1;  if show3 == 1, figure(3),end
    
    % binary image
    gray = rgb2gray(im);
    bw = gray>0.55;
    bw = bw(2:48,2:48);
    bw = imresize(bw,[50 50]);
    bw = imerode(bw, strel('disk',1));
    bw = bwareaopen(bw,25);
    
    min_confidence = 0;
    unknown = 1;
    rotate_90_times = 0;
    
    for i = 1:4 
        %(1=0deg, 2=90deg, 3=180deg, 4=270deg)
        bw = imrotate(bw,90);
        if show3 == 1,  subplot(1,4,i);  imshow(bw);    end
        
        % ORC function
        results = ocr(bw,[3 3 45 45],'TextLayout', 'Block','CharacterSet','A':'Z');
        
        % prevent no value return from OCR
        if isempty(results.Text), continue; end
        
        % prevent return more than 1 character
        if size(results.Words{1},2) ~= 1, continue; end
        
        % store the highest confidence character
        if results.WordConfidences > min_confidence
            unknown = 0;
            min_confidence = results.WordConfidences;
            c = results.Words;
            rotate_90_times = i;
        end
    end

    % letter 'I' is problematic
    % try 'Word' parameter in OCR (Treats the text in the image as a single word of text)
    if unknown == 1
        for i = 1:4 
            %(1=0deg, 2=90deg, 3=180deg, 4=270deg)
            bw = imrotate(bw,90);
            if show3 == 1,  subplot(1,4,i);  imshow(bw);    end

            % ORC function
            results = ocr(bw,[3 3 45 45],'TextLayout', 'Word','CharacterSet','A':'Z');

            % prevent no value return from OCR
            if isempty(results.Text), continue; end

            % prevent return more than 1 character
            if size(results.Words{1},2) ~= 1, continue; end

            % store the highest confidence character
            if results.WordConfidences > min_confidence
                unknown = 0;
                min_confidence = results.WordConfidences;
                c = results.Words;
                rotate_90_times = i;
            end
        end 
    end
    
    % cannot recognize letter
    if unknown == 1
        c = 0;
    else
        switch c{1}  % letter 2 number
            case ' ', c = 0;
            case 'A', c = 1;
            case 'B', c = 2;
            case 'C', c = 3;
            case 'D', c = 4;
            case 'E', c = 5;
            case 'F', c = 6;
            case 'G', c = 7;
            case 'H', c = 8;
            case 'I', c = 9;
            case 'J', c = 10;
            case 'K', c = 11;
            case 'L', c = 12;
            case 'M', c = 13;
            case 'N', c = 14;
            case 'O', c = 15;
            case 'P', c = 16;
            case 'Q', c = 17;
            case 'R', c = 18;
            case 'S', c = 19;
            case 'T', c = 20;
            case 'U', c = 21;
            case 'V', c = 22;
            case 'W', c = 23;
            case 'X', c = 24;
            case 'Y', c = 25;
            case 'Z', c = 26;
        end
    end
    
    % angle of letter 
    deg = wrapTo180( 90*rotate_90_times + deg);
    
    % close image3
    if show3, close(3); end
end