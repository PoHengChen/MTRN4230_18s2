Folder = 'C:\Users\z5014\Pictures\data\Raw_data\shape\6';
ImgType = '*.png';

FrameResize(Folder, ImgType)

% imread(fullfile(folder,Frames(),name));

function [ image ] = FrameResize(Folder, ImgType)

Frames = dir([Folder '/' ImgType]);
NumFrames = size(Frames,1);

        mkdir('6');
        cd('6');
for i = 1 : NumFrames
    image = (imread([Folder '/' Frames(i).name]));
%         image = imread(fullfile(Folder,Frames(i).name));
%     for j = 2 : 10
%         new_size = power(new_size, j);

        % Creating a new folder called 'Low-Resolution' on the
        % previous directory
%         mkdir ('.. Low-Resolution1');

%         image = imresize(image, [new_size new_size]);

        image = imresize(image, [50 50]);
        imwrite(image, ['im_' num2str(i) '.png']);


%     end

end

end