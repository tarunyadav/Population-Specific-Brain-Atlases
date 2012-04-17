function[]=non_linear_reg(src_image,dst_image)
    datapath='images';
    src= dicomread(sprintf('%s/%s',datapath,src_image));
    dst= dicomread(sprintf('%s/%s',datapath,dst_image));
    [n_x n_y src_points dst_points] = non_linear_CP(src,dst);
    src_reg= non_linear_feature_mapping(n_x,n_y,src_points,dst_points,src,dst);
    subplot(1,3,1);
    imshow(src,[]);
    subplot(1,3,2);
    imshow(src_reg-dst,[]);
    subplot(1,3,3);
    imshow(dst,[]);
end