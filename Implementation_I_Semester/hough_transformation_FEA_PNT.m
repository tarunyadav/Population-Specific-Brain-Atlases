function[lines]= hough_transformation_FEA_PNT(src_image_name,dst_image_name)
    
    I=imread(sprintf('images/%s',src_image_name));
    J=imread(sprintf('images/%s',dst_image_name));
    SRC = edge(I(:,:,1),'sobel');
    DST = edge(J(:,:,1),'sobel');
    [H_s,theta_s,rho_s] = hough(SRC);
    [H_d,theta_d,rho_d] = hough(DST);
    P_s = houghpeaks(H_s,10,'threshold',ceil(0.6*max(H_s(:))));
    P_d = houghpeaks(H_d,10,'threshold',ceil(0.6*max(H_d(:))));
    lines_s = houghlines(SRC,theta_s,rho_s,P_s,'FillGap',3,'MinLength',3);
    lines_d = houghlines(DST,theta_d,rho_d,P_d,'FillGap',3,'MinLength',3);
    
    src_points = [];
    dst_points = [];
    for k = 1:length(lines_s)
        src_points = [src_points; lines_s(k).point1;lines_s(k).point2];
        %src_points = [src_points; lines_s(k).point2];
    end
    for k = 1:length(lines_d)
        dst_points = [dst_points; lines_d(k).point1;lines_d(k).point2];
        %dst_points = [dst_points; lines_d(k).point2];
    end
    subplot(2,2,1);imshow(SRC);
    subplot(2,2,2);imshow(DST);
    step_x = 30;step_y=30;step_theta=90;
    transformation = feature_mapping(transpose(src_points),transpose(dst_points),step_x,step_y,step_theta);
    
    
    trans_X = transformation(1,1);
    trans_Y = transformation(1,2);
    theta = -1*transformation(1,3);
    
    T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
    tformfwd([trans_X trans_Y],T);
    REGISTERED= imtransform(SRC,T);
    subplot(2,2,4);imshow(REGISTERED,[]);
    
%     imshow(SRC)
%     figure, imshow(SRC), hold on
%     max_len = 0;
%     for k = 1:length(lines)
%        xy = [lines(k).point1; lines(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%        % Plot beginnings and ends of lines
%        plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
% 
%        % Determine the endpoints of the longest line segment
%        len = norm(lines(k).point1 - lines(k).point2);
%        if ( len > max_len)
%           max_len = len;
%           xy_long = xy;
%        end
%     end
% 
%     % highlight the longest line segment
%     plot(xy_long(:,1),xy_long(:,2),'LineWidth',1.5,'Color','red');

end