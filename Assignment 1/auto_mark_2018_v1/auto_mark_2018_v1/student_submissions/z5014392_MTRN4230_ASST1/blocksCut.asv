function  [blocks,mask_block] = blocksCut(blocks, block_regions, block_length,mask_block,im,show1)
%     No_of_blocks = ceil(block_regions.Area/(block_length)^2);
    target = zeros(size(mask_block));
    target(block_regions.PixelIdxList) = 1;
    if show1,  subplot(2,2,4);imshow(mask_block);title('Residual Area');  subplot(2,2,2);imshow(target);title('Current Target Area');   end
    %% 1. Boundary
    blockBoundaries = bwboundaries(target,'noholes');
    if show1,  subplot(2,2,1);plot(blockBoundaries{1,1}(:,2),blockBoundaries{1,1}(:,1),'r','LineWidth',2);  end
    %% 2. DouglasPeucker
     douglasEpsilon = 6;
    result = DouglasPeucker(blockBoundaries{1,1}(1:end-1,:)', douglasEpsilon); %end-1 otherwise it loops back and doesn't move, 2.5 works
    if show1,  subplot(2,2,1);plot(result(2,:),result(1,:),'g.','Markersize',10);  end
    %% 3. Corner
    result2 = result;
    result2 = [result2(:,end),result2];  result2 = [result2,result2(:,2)]; 
    % find angle between adjacent point
    vector1 = result2(:,1:end-2) - result2(:,2:end-1);    alpha1 = atan2d(vector1(1,:),vector1(2,:));
    vector2 = result2(:,3:end) - result2(:,2:end-1);      alpha2 = atan2d(vector2(1,:),vector2(2,:));
    alpha = abs(wrapTo180(alpha1 - alpha2));
    % find corner coordinate
    right_angle_tolerance = 15;
    corner_index = find((alpha > (90 - right_angle_tolerance)) & (alpha < (90 + right_angle_tolerance)));
    corner = result(:,corner_index);
    if show1, subplot(2,2,1);plot(corner(2,:),corner(1,:),'bx','Markersize',4);  end
    %% 4. Center
    center = [];
    for i = 2 : size(result2,2) - 1 
        new = 1;
        if ismember(i,corner_index + 1) % i belong result2 (size+2) to find result(size), so index+1
            u = (result2(:,i-1) - result2(:,i)); u = (u/norm(u))*25;% vector to center
            v = (result2(:,i+1) - result2(:,i)); v = (v/norm(v))*25;
            y_v = -(u(1) + v(1));% vector to corner
            x_v = -(u(2) + v(2));
            y = round(result2(1,i) + u(1) + v(1));% get center from corner
            x = round(result2(2,i) + u(2) + v(2));
            if target(y,x) == 0, continue; end  % illegal center(outside target)

            if isempty(center)
                center = [x;y;x_v;y_v];
            else
                for j = 1 : size(center,2) 
                    center_dist = sqrt((center(1,j) - x)^2 + (center(2,j) - y)^2);
                    if center_dist < 20     % check repeat
                        new = 0;
                        center(1,j) = round((x + center(1,j))/2);
                        center(2,j) = round((y + center(2,j))/2);
                        break;
                    elseif center_dist > 20 && center_dist < 40  % abandon close center
                        new = 0;
                        break;
                    end
                end
                if new == 1
                    center = [center(1,:),x; center(2,:),y;center(3,:),x_v;center(4,:),y_v]; 
                end
            end
        end
    end
    if ~isempty(center),if show1==1, subplot(2,2,1);plot(center(1,:),center(2,:),'.m','Markersize',14);end,end
    if show1,for ii = 1:size(center,2),quiver(center(1,ii),center(2,ii),center(3,ii),center(4,ii),'y','LineWidth',1); end, end
    %% 5. Store & Cut
%     extract = zeros(block_length,block_length,3);
    for k = 1:size(center,2)
        x = [center(1,k)+center(3,k) center(1,k)-center(4,k) center(1,k)-center(3,k) center(1,k)+center(4,k) center(1,k)+center(3,k)];
        y = [center(2,k)+center(4,k) center(2,k)+center(3,k) center(2,k)-center(4,k) center(2,k)-center(3,k) center(2,k)+center(4,k)];
        msk = poly2mask(x,y,1200,1600);
        
        extractedBlock = im(:,:,:);
        extractedBlock(:,:,1) = im(:,:,1) .* (msk);
        extractedBlock(:,:,2) = im(:,:,2) .* (msk);
        extractedBlock(:,:,3) = im(:,:,3) .* (msk);
        
        MCD = round((block_length/2)*sqrt(2));
        extractedMask(:,:,1) = extractedBlock(center(2,k)-MCD:center(2,k)+MCD,  center(1,k)-MCD:center(1,k)+MCD,  1);
        extractedMask(:,:,2) = extractedBlock(center(2,k)-MCD:center(2,k)+MCD,  center(1,k)-MCD:center(1,k)+MCD,  2);
        extractedMask(:,:,3) = extractedBlock(center(2,k)-MCD:center(2,k)+MCD,  center(1,k)-MCD:center(1,k)+MCD,  3);
        
        
        angle = wrapTo360(atan2d(center(4,k),center(3,k))+45);
        if show1==1,quiver(center(1,ii),center(2,ii),25*cos(deg2rad(angle)),25*sin(deg2rad(angle)),'m','LineWidth',1);end
        % wrap to (0 ~ 90) degrees
        while  angle > 90, angle = angle - 90; end 
        if show1==1,quiver(center(1,ii),center(2,ii),25*cos(deg2rad(angle)),25*sin(deg2rad(angle)),'g','LineWidth',1);end
        % wrap to (-45 ~ 45) degrees
        if angle > 45,angle = angle - 90; end
        extractedMask = imrotate(extractedMask, angle, 'crop'); % counterclockwise
        if show1, subplot(2,2,3); imshow(extractedMask);title('Current Block Info'); end

        extract = extractedMask(14:60,14:60,:);
        extract = imresize(extract,[block_length block_length]);
        blocks{1,end+1} = center(2,k);
        blocks{2,end} = center(1,k);
        blocks{3,end} = angle;
        blocks{4,end} = extract;
        % fill the extracted area in mask
        mask_block = mask_block .* ~msk;
    end
    
    % clean the residual
    mask_block = imerode(mask_block,strel('disk',1));
    mask_block = bwareaopen(mask_block,300);
    mask_block = imerode(mask_block,strel('disk',2));
    mask_block = bwareaopen(mask_block,300);
    mask_block = imdilate(mask_block,strel('disk',2));
    mask_block = imdilate(mask_block,strel('disk',1));
end
