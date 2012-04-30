function[src_reg]=non_linear_reg(src,dst)
    %datapath='images';
    %src= dicomread(sprintf('%s/%s',datapath,src_image));
    %dst= dicomread(sprintf('%s/%s',datapath,dst_image));
    [n_x n_y src_points dst_points] = non_linear_CP(src,dst);
    src_reg= non_linear_feature_mapping(n_x,n_y,src_points,dst_points,src,dst);
    %subplot(2,3,1);title('Registered Image');
    %imshow(src_reg,[]);
    %subplot(2,3,2);title('Source Image');
    %imshow(src,[]);
    % subplot(2,3,3);title('Destination Image');
    %imshow(dst,[]);
    %subplot(2,3,5);title('Difference of Registerd and Source Image');
    %imshow(src_reg-src,[]);
    %subplot(2,3,6);title('Difference of Registerd and Destination Image');
    %imshow(src_reg-dst,[]);
end