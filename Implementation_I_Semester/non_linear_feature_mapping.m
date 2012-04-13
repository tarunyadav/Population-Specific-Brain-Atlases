function [Image] = non_linear_feature_mapping(n_x,n_y,src_points, dst_points,Image)
     Image_old=Image; 
    for x=50:256
         for y=50:256
                i=floor(x/60)-1;
                j=floor(y/60)-1;
                %u=x/60-floor(x/60);
                %v=y/60-floor(x/60);
                u=x/256;
                v=y/256;
                BERNSTEIN_u = bernstein_poly(2,u);
                BERNSTEIN_v=  bernstein_poly(2,v);
                A=[0 0];
                for l=0:2
                    for m=0:2
                        if(i+l>=0 && i+l<=256 && j+m>=0 && j+m<256)
                            A=A+ BERNSTEIN_u(l+1)*BERNSTEIN_v(m+1)*dst_points((i+l)*n_y +(j+m)+1);
                            % disp((i+l)*n_y +(j+m)+1);
                        end
                    end
                end
                disp('old');
                disp(x);
                disp(y);
                disp('new');
                disp(round(A(1)));
                disp(round(A(2)));
                Image(round(A(1)),round(A(2)))=Image_old(x,y);
                %Image(x,y)=0;
         end
    end
end