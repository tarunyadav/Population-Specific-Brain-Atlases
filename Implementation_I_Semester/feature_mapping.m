function [Transformation] = feature_mapping(src, dst,step_x,step_y,step_theta)

     %x,y will be 2 x n matrices which includes feature points
%      max_x = input('Enter max translation in x direction : '  );
%      step_x = input('Enter the step size in x : ' );
%      max_y = input('Enter max translation in y direction : ' );
%      step_y = input('Enter the step size in y : ');
%      max_theta = input('Enter the max theta : ');
%      step_theta = input('Enter the step theta : ');

      max_x = 250;max_y=250;max_theta = 180;
     [src_row_size src_column_size] = size(src);
     [dst_row_size dst_column_size] = size(dst);
     
     % initialization of Matrix contating all transformations
     transformations=[];
     for i = -max_x:step_x:max_x
         for j = -max_y:step_y:max_y
             for theta = -max_theta:step_theta:max_theta
               for s = .8:.2:1.2  
                 d(1,1) = i;
                 d(1,2) = j;
                 d(1,3) = theta;
                 d(1,4) = s;
                 d(1,5) = 0;
                 transformations = [transformations ; d];
               end
             end
         end
     end

     % increament to appropiate configuration 
     for i = 1:src_column_size
         for j = 1:dst_column_size
            %for s = .8:.2:1.2 
             for theta = -max_theta:step_theta:max_theta
                %imrotate(src,theta,'bilinear')
                T = ([dst(1,j) ; dst(2,j)]) - ([125 ; 125]+ ([cos(theta*pi/180) -sin(theta*pi/180); sin(theta*pi/180) cos(theta*pi/180)] *([-125; -125]+[src(1,i) ; src(2,i)])));
                Tx = T(1,1);
                Ty = T(2,1);
                
                [row_trans column_trans]=size(transformations);                
                min_trans = 10000000;min_trans_row=0;
                for l=1:row_trans
                    if transformations(l,3)==theta %&& transformations(l,4)==s
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
                transformations(min_trans_row,5)=transformations(min_trans_row,5)+1;
                
             end
            %end
         end
     end
     % choosing the maximum matching configuration
     [value maximum] = max(transformations(:,5));
     min_distance = 10000000;
     min_distance_row = 1;
     for i=1:1:row_trans
         if (transformations(i,5)==value)
            %disp(transformations(i,:)); 
            distance = (transformations(i,1)*transformations(i,1) + transformations(i,2)*transformations(i,2));
            if (distance < min_distance)
                min_distance = distance;
                min_distance_row=i;
            end
         end
         %disp(transformations(i,:));
     end
     %disp(transformations(min_distance_row,:));
     
     %Transformation = transformations(maximum,:);
     Transformation = transformations(min_distance_row,:);
end
