function [Transformation,transformations] = feature_mapping(transformations,src, dst,step_x,step_y,step_theta,image_name)

      max_x = 70;max_y=70;max_theta = 60;
     [src_row_size src_column_size] = size(src);
     [dst_row_size dst_column_size] = size(dst);
    
    h = waitbar(0,'Please wait...');
    steps = src_column_size;
    step=1;
     % increament to appropiate configuration 
     for i = 1:src_column_size
         for j = 1:dst_column_size
            %for s = .8:.2:1.2 
             for theta = -max_theta:step_theta:max_theta
                %imrotate(src,theta,'bilinear')
                T = ([dst(1,j) ; dst(2,j)]) - ([128 ; 128]+ ([cos(theta*pi/180) -sin(theta*pi/180); sin(theta*pi/180) cos(theta*pi/180)] *([-128; -128]+[src(1,i) ; src(2,i)])));
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
                   % step=step+1;
                    %waitbar(step / steps);
                end
                transformations(min_trans_row,5)=transformations(min_trans_row,5)+1;
            end
           %end
         end
         step=step+1;
         waitbar(step / steps,h,sprintf('Computing the Transfromations for %s',image_name));
     end
     close(h) 
     
     % choosing the maximum matching configuration
     [value maximum] = max(transformations(2000:20000,5));
     min_distance = 10000000;
     min_distance_row = 1;
     for i=1:1:row_trans
         if (transformations(i,5)==value)
            distance = (transformations(i,1)*transformations(i,1) + transformations(i,2)*transformations(i,2));
            if (distance < min_distance)
                min_distance = distance;
                min_distance_row=i;
            end
         end
         %step=step+1;
         %waitbar(step / steps);
     end
    
     Transformation = transformations(min_distance_row,:);
end
