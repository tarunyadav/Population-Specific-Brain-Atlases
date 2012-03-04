 function[ ]= reg_using_lines(src_image_name,dst_image_name,step_x,step_y,step_theta)
    
    
    [src_lines dst_lines src_points dst_points]=line_detection(src_image_name,dst_image_name);
       
    transformation =line_mapping(src_lines,dst_lines,transpose(src_points),transpose(dst_points),step_x,step_y,step_theta);
        
    trans_X = transformation(1,1);
    trans_Y = transformation(1,2);
    theta = transformation(1,3);

    %imshow(SRC);
    T = maketform('affine',[cos(pi*theta/180) -sin(pi*theta/180) 0; sin(pi*theta/180) cos(pi*theta/180) 0; 0 0 1]);
    tformfwd([trans_X trans_Y],T);
    REGISTERED= imtransform(SRC,T);
    subplot(2,2,4);
    %imshow(DST); hold on;
    %figure,
    imshow(REGISTERED);
        
%         figure, imshow(DST), hold on
%     max_len = 0;
%     for k = 1:length(lines_d)
%        xy = [lines_d(k).point1; lines_d(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%        % Plot beginnings and ends of lines
%        plot(xy(1,1),xy(1,2),'x','LineWidth',1,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',1,'Color','red');
% 
%        % Determine the endpoints of the longest line segment
%        len = norm(lines_d(k).point1 - lines_d(k).point2);
%        if ( len > max_len)
%           max_len = len;
%           xy_long = xy;
%        end
%     end
% 
%     % highlight the longest line segment
%     plot(xy_long(:,1),xy_long(:,2),'LineWidth',1.5,'Color','red');

end