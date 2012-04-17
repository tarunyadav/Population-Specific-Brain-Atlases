function[n_x n_y base_points input_points] = non_linear_CP(src,dst)
    
    input_points=[];
    base_points=[];
    n_x=51;n_y=51;
    for i=5:5:256
         for j =5:5:256
            input_points=[input_points;i j];
            %if(i <256/1.4)
             %   base_points=[base_points;i j];
            %else
                base_points=[base_points;i j];
            %end
         end
    end
    %disp(size(base_points));
    %disp(size(input_points));
    %cpselect(dst,src,input_points,base_points);
end
