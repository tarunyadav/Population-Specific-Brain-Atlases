function [dst] = non_linear_feature_mapping(n_x,n_y,src_points, dst_points,src,dst)
     
     for i=1:256
         for j=1:256
               dst(i,j)=0;
         end
     end
     h=waitbar(0,'Please wait...');
     steps=236;
     step=1;
    for x=10:246
         for y=10:246
                i=floor(x/5)-1;
                j=floor(y/5)-1;
                u=x/5-floor(x/5);
                v=y/5-floor(y/5);
                BERNSTEIN_u = bernstein_poly(2,u);
                BERNSTEIN_v=  bernstein_poly(2,v);
                BERNSTEIN_u(1,2)=BERNSTEIN_u(1,2)+1;
                BERNSTEIN_v(1,2)=BERNSTEIN_v(1,2)+1;
                BERNSTEIN_u = BERNSTEIN_u/2;
                BERNSTEIN_v = BERNSTEIN_v/2;
                A=[0 0];
               for l=0:2
                    for m=0:2
                            A=A+ BERNSTEIN_u(1,l+1)*BERNSTEIN_v(1,m+1)*dst_points(((i-1)+l)*n_y +(j+m),:);
                    end
                end
                %fprintf(' x,y are %d,%d and new_x,new_y are %d, %d\n',x,y,round(A(1)),round(A(2)));
                 dst(floor(A(1)),floor(A(2)))=src(x,y);
         end
         waitbar(step/steps,h,'Applying Free Form deformation to the images...');
         step=step+1;
    end
    close(h);
end