function[src_lines dst_lines]= line_detection(src_image_name,dst_image_name)
    
    I=imread(sprintf('images/%s',src_image_name));
    J=imread(sprintf('images/%s',dst_image_name));
    src_feature = affdemo2(src_image_name);
    dst_feature = affdemo2(dst_image_name);
    
    src_feature_points = src_feature(:,1:2);
    dst_feature_points = dst_feature(:,1:2);
    
    SRC = edge(I(:,:,1),'sobel');
    DST = edge(J(:,:,1),'sobel');
    
    SRC_SIZE = size(SRC);
    DST_SIZE = size(DST);
    
    src_size=size(src_feature_points);
    dst_size=size(dst_feature_points);
    
    count = 1;
    
    for p=1:src_size(1)
            i = src_feature_points(p,1);
            j = src_feature_points(p,2);
            i_min = max(1,i-1);
            i_max = min(SRC_SIZE(1),i+1);
            j_min = max(1,j-1);
            j_max = min(SRC_SIZE(2),j+1);
            Check_Matrix = zeros(SRC_SIZE(1),SRC_SIZE(2));
            Check_Matrix(i,j)=1;
            for m=i_min:i_max
                for n=j_min:j_max
                    if (SRC(m,n)==1)
                        m_min = max(1,m-1);
                        m_max = min(SRC_SIZE(1),m+1);
                        n_min = max(1,n-1);
                        n_max = min(SRC_SIZE(2),n+1);
                        for x=m_min:m_max
                            for y=n_min:n_max
                                if (SRC(x,y)==1 && Check_Matrix(x,y)~=1 && ((x<=m_min && n_min<=y<=n_max) || (x>=m_max && n_min<=y<=n_max) || (m_min<=x<=m_max && y <=n_min) || (m_min<=x<=m_max && y >=n_max)))
                                    Check_Matrix(x,y)=1;
                                    lines_s(count)=struct('point1',[i j],'point2',[x y]);
                                    count = count+1;
                                end
                            end
                        end
                    end 
                end
           end
    end
    
    count=1;
    for q=1:dst_size(1)
            i = dst_feature_points(q,1);
            j = dst_feature_points(q,2);
            i_min = max(1,i-1);
            i_max = min(DST_SIZE(1),i+1);
            j_min = max(1,j-1);
            j_max = min(DST_SIZE(2),j+1);
            Check_Matrix = zeros(DST_SIZE(1),DST_SIZE(2));
            Check_Matrix(i,j)=1;
            for m=i_min:i_max
                for n=j_min:j_max
                    if (DST(m,n)==1 )
                        m_min = max(1,m-1);
                        m_max = min(DST_SIZE(1),m+1);
                        n_min = max(1,n-1);
                        n_max = min(DST_SIZE(2),n+1);
                        for x=m_min:m_max
                            for y=n_min:n_max
                                if (DST(x,y)==1 && Check_Matrix(x,y)~=1 && ((x<=m_min && n_min<=y<=n_max) || (x>=m_max && n_min<=y<=n_max) || (m_min<=x<=m_max && y <=n_min) || (m_min<=x<=m_max && y >=n_max)))
                                    Check_Matrix(x,y)=1;
                                    lines_d(count)=struct('point1',[i j],'point2',[x y]);
                                    count = count+1;
                                end
                            end
                        end
                    end 
                end
           end
    end
    
    src_points = [];
    dst_points = [];
    src_lines = [];
    dst_lines = [];
    for k = 1:length(lines_s)
        %src_points = [src_points; lines_s(k).point1;lines_s(k).point2];
        src_lines = [src_lines; lines_s(k).point1 lines_s(k).point2 ((lines_s(k).point2(1,2)-lines_s(k).point1(1,2))/(lines_s(k).point2(1,1)-lines_s(k).point1(1,1)))];
        %disp(src_lines(k,:));
        
    end
    for k = 1:length(lines_d)
        %dst_points = [dst_points; lines_d(k).point1;lines_d(k).point2];
        dst_lines = [dst_lines; lines_d(k).point1 lines_d(k).point2 ((lines_d(k).point2(1,2)-lines_d(k).point1(1,2))/(lines_d(k).point2(1,1)-lines_d(k).point1(1,1)))];
        %disp(dst_lines(k))
    end
    
    %disp(src_lines);
    %disp(dst_lines);
    %subplot(2,2,1);imshow(SRC);
    %subplot(2,2,2);imshow(DST);
 

end