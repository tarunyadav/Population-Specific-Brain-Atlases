 function[src_lines dst_lines src_points dst_points]= line_detection_hough(src_image_name,dst_image_name)
    
    I=dicomread(sprintf('images/%s',src_image_name));
    J=dicomread(sprintf('images/%s',dst_image_name));
    SRC = edge(I(:,:,1),'sobel');
    DST = edge(J(:,:,1),'sobel');
    [H_s,theta_s,rho_s] = hough(SRC);
    [H_d,theta_d,rho_d] = hough(DST);
    P_s = houghpeaks(H_s,30,'threshold',ceil(0.3*max(H_s(:))));
    P_d = houghpeaks(H_d,30,'threshold',ceil(0.3*max(H_d(:))));
    lines_s = houghlines(SRC,theta_s,rho_s,P_s,'FillGap',3,'MinLength',3);
    lines_d = houghlines(DST,theta_d,rho_d,P_d,'FillGap',3,'MinLength',3);
    
    src_points = [];
    dst_points = [];
    src_lines = [];
    dst_lines = [];
    for k = 1:length(lines_s)
        src_points = [src_points; lines_s(k).point1;lines_s(k).point2];
        src_lines = [src_lines; lines_s(k).point1 lines_s(k).point2 ((lines_s(k).point2(1,2)-lines_s(k).point1(1,2))/(lines_s(k).point2(1,1)-lines_s(k).point1(1,1)))];
        %disp(src_lines(k,:));
        
    end
    for k = 1:length(lines_d)
        dst_points = [dst_points; lines_d(k).point1;lines_d(k).point2];
        dst_lines = [dst_lines; lines_d(k).point1 lines_d(k).point2 ((lines_d(k).point2(1,2)-lines_d(k).point1(1,2))/(lines_d(k).point2(1,1)-lines_d(k).point1(1,1)))];
        %disp(dst_lines(k))
    end
    
    
    
end