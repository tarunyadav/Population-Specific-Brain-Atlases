function [transformation]= nonLinearReg(src_image_path,dst_image_path)
    %subplot(2,2,1);
   src_image = affdemo2(src_image_path);
    %subplot(2,2,2);
    %dst_image = affdemo2(dst_image_path);
     %[src_row_size src_column_size] = size(src);
    % [dst_row_size dst_column_size] = size(dst);
    %for i=1:20:src_row_size
     %     for j=1:20:src_column_size
      %       unifrom_mesh(i,j)=
    
     for point  
     for i= 1:8
            for j=1:8
                   
    SRC=imread(sprintf('images/%s',src_image_path));
    DST=imread(sprintf('images/%s',dst_image_path));
    [size_row size_column] = size(SRC)
    subplot(2,2,1);imshow(SRC,[]);
    subplot(2,2,2);imshow(DST,[]);
    %transformation = non_linear_feature_mapping(size_row,size_column,transpose(src_image(:,1:2)),transpose(dst_image(:,1:2)));
    
%     trans_X = transformation(1,1);
%     trans_Y = transformation(1,2);
%     theta = -1*transformation(1,3);
%     
%     T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
%     tformfwd([trans_X trans_Y],T);
%     REGISTERED= imtransform(SRC,T);
%     subplot(2,2,4);imshow(REGISTERED,[]);
%     
end

