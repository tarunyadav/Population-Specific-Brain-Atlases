function [J E x_coordinates y_coordinates] =  anti_clockwise_1(J,E,i,j,x_coordinates,y_coordinates,detect_length)
%function [J E] =  anti_clockwise_1(J,E,i,j)


%I = dicomread('IM_0010');
%J = edge(I,'sobel');

%I = imread('C:\Users\chaitu\Desktop\download.jpg');
%J1 = rgb2gray(I);
%J = edge(J1,'sobel');
 


%K=size(J);
%
%row = K(1,1);
%column = K(1,2);
%bre = 0;
%for i = 1:row
%    for j = 1:column
%        if(J(i,j) == 1)
%            bre = 1;
%           
%        end
%        if bre == 1
%            break
%        end
%    end
%    if bre == 1
%            break
%    end
%end

%E = zeros([row column]);



dir = 7;

max_rept = 8;

   
matrix = [0 -1; -1 -1; -1 0; -1 1;0 1; 1 1;1 0; 1 -1];

side_length = 0;

figure_length = 0;

%create a temp matrix of size J
[J_row J_column] = size(J);
temp = zeros(J_row,J_column);
temp(i,j) = 1;
start_temp_x = i;
start_temp_y = j;
start_dir = dir;
entered = 0;


while 1
    
    while J(i+matrix(dir+1,1), j+matrix(dir+1,2)) == 0
        
        if max_rept == 0
            break;
        end        
        dir = mod((dir + 1),8);
        max_rept = max_rept - 1;
    end
       
    figure_length = figure_length +1;
    J(i,j) = 0;
    if max_rept == 0 && figure_length < 10
        break;
    end
    
    
    %E(i,j) = 1;
    temp(i,j) = 1;
    temp(i,j);
    i = i+matrix(dir+1,1);
    j = j+matrix(dir+1,2);
    

    if dir%2 == 0
        dir = (dir  + 7);
        dir = mod(dir,8);
    else
        dir = (dir + 6);
        dir = mod(dir,8);
    end
    
    
        if (max_rept == 0) && (figure_length > 0)
            i1 = start_temp_x;
            j1 = start_temp_y;
            
          while 1  
          
              
            entered = 1;
            dir1 = start_dir;
            max_rept = 8;
            while temp(i1+matrix(dir1+1,1), j1+matrix(dir1+1,2)) == 0              
                if max_rept == 0
                    break;
                end        
                dir1 = mod((dir1 + 1),8);
                max_rept = max_rept - 1;
            end
            
    
            %%%
            % This is for plotting purpose
            %%%
            
            if (side_length < detect_length)
                side_length = side_length + 1;
            elseif side_length == detect_length
                
                x_coordinates = [x_coordinates i1];
                y_coordinates = [y_coordinates j1];        
                side_length = 0;
            end
            
            figure_length = figure_length - 1;
            temp(i1,j1) = 0;
            if max_rept == 0
                
                break;
            end
            
            %figure_length = figure_length - 1
            E(i1,j1) = 1;
            i1 = i1+matrix(dir1+1,1);
            j1 = j1+matrix(dir1+1,2);

            
            if dir1%2 == 0
                dir1 = (dir1  + 7);
                dir1 = mod(dir1,8);
            else
                dir1 = (dir1 + 6);
                dir1 = mod(dir1,8);
            end
            
          end
        end
    
    max_rept = 8; 
    if(entered == 1)
        break;
    end

end




%for i = 2:row-1
%    for j = 2:column-1
%        if (J(i-1,j) == 0) && (J(i,j-1) == 0) && (J(i,j+1) == 0) && (J(i+1,j)==0) && (J(i-1,j-1) == 0) && (J(i-1,j+1) == 0) && (J(i+1,j-1) == 0) && (J(i+1,j+1) == 0)
%            J(i,j) = 0;
%        end
%    end
%end

 
%imshow(J)
%subplot(1,3,1) , imshow(J)
%subplot(1,3,2) , imshow(E)

end





            
