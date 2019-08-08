
function mask = ycbcr_adjustment(im)
        im_ycbcr = rgb2ycbcr(im);
        y = im_ycbcr(:,:,1);
        cb = im_ycbcr(:,:,2);
        cr = im_ycbcr(:,:,3);
%         figure;imshow(y);
%         figure;imshow(cb); % yellow is dark in cb
%         figure;imshow(cr); % red & orange is bright in cr
%         imshow((cb<0.4) | (cr>0.65));
        mask = (cb<0.4) | (cr>0.6);
        
        
%         im_ycbcr(:,:,1) = 1.5 * im_ycbcr(:,:,1);
%         back = cat(3,im_ycbcr(:,:,1),im_ycbcr(:,:,2),im_ycbcr(:,:,3));
%         im = ycbcr2rgb(back); imshow(im);
end