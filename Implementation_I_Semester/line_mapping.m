function [Transformation] = line_mapping(src_lines,dst_lines,src, dst,step_x,step_y,step_theta)

      max_x = 250;max_y=250;max_theta = 180;
     [src_row_size src_column_size] = size(src);
     [dst_row_size dst_column_size] = size(dst);
     [src_line_row_size src_line_column_size] = size(src_lines);
     [dst_line_row_size dst_line_column_size] = size(dst_lines);
     
     % initialization of Matrix contating all transformations
     transformations=[];
     for i = -max_x:step_x:max_x
         for j = -max_y:step_y:max_y
             for theta = -max_theta:step_theta:max_theta
               %for s = .8:.2:1.2  
                 d(1,1) = i;
                 d(1,2) = j;
                 d(1,3) = theta;
                 d(1,4) = 0;
               %  d(1,5) = 0;
                 transformations = [transformations ; d];
               %end
             end
         end
     end
     [row_trans column_trans]=size(transformations);  
     translation = ones(dst_row_size,dst_column_size);
     %disp(dst_lines);
     %disp(src_lines);
     %disp(src_line_row_size);
     % increament to appropiate configuration 
     for theta = -max_theta:step_theta:max_theta
         rotated_points = ((150*translation)+ (([cos(theta*pi/180) -sin(theta*pi/180); sin(theta*pi/180) cos(theta*pi/180)])*((-150*translation)+ dst)));
         
         rotated_points_t = transpose(rotated_points);
         
         for k = 1:2:length(rotated_points)
                dst_lines((k+1)/2,:) = [rotated_points_t(k,:) rotated_points_t(k+1,:) (rotated_points_t(k+1,2)-rotated_points_t(k,2))/(rotated_points_t(k+1,1)-rotated_points_t(k,1))];
         end
         
         for i = 1:src_line_row_size
             for j = 1:dst_line_row_size
                 %disp('open')
                 %disp(src_lines(i,5));
                 %disp(dst_lines(j,5));  
                %disp(atan(abs(src_lines(i,5)-dst_lines(j,5))));
                if( atan(abs(src_lines(i,5)-dst_lines(j,5)))<0.05)
                    Tx = ((dst_lines(j,1)+dst_lines(j,3))/2)-((src_lines(i,1)+src_lines(i,3))/2);
                    Ty = ((dst_lines(j,2)+dst_lines(j,4))/2)-((src_lines(i,2)+src_lines(i,4))/2);
                    
                    min_trans = 10000000;min_trans_row=0;
                    for l=1:row_trans
                        if transformations(l,3)==theta
                            trans_x = Tx-transformations(l,1);
                            trans_y = Ty-transformations(l,2);
                            trans_x = trans_x*trans_x;
                            trans_y = trans_y*trans_y;
                            trans = trans_x + trans_y;
                            
                            if trans < min_trans
                                
                                min_trans = trans;
                                min_trans_row = l;
            
                            end
                    
                        end
                    end
                transformations(min_trans_row,4)=transformations(min_trans_row,4)+1;
                
             end
            end
         end
     end
     % choosing the maximum matching configuration
     [value maximum] = max(transformations(:,4));
     min_distance = 10000000;
     min_distance_row = 1;
     for i=1:1:row_trans
        % if(transformations(i,4)>=20)
          %   disp(transformations(i,:)); 
         %end
         if (transformations(i,4)==value)
            %disp(transformations(i,:)); 
            distance = (transformations(i,1)*transformations(i,1) + transformations(i,2)*transformations(i,2));
            if (distance < min_distance)
                min_distance = distance;
                min_distance_row=i;
            end
         end
         
     end
     %disp(transformations(min_distance_row,:));
     
     %Transformation = transformations(maximum,:);
     Transformation = transformations(min_distance_row,:);
end
