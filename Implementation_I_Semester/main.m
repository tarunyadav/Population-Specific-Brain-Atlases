function [ ] = main( ~ )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%%%%
%TARUN'S ALGO SYNCHRONIZING
%%%%
%f_point = affdemo2('IM_0010');
%var = f_point(:,1:2)
%v = var(1,:)
%%%%%
%
%%%%


I = dicomread('images/IM_0010');

%I = imread('download.jpg');
%I = rgb2gray(I);


J = edge(I,'sobel');

JU = edge(I,'sobel');

K=size(J);
row = K(1,1);
column = K(1,2);


%
%   Finding the first non-zero point
%
bre = 0;
for i = 1:row
    for j = 1:column
        if(J(i,j) == 1)
            bre = 1;
        end
        if bre == 1
            break
        end
    end
    if bre == 1
            break
    end
end
start_x = i;
start_y = j;

E = zeros([row column]);

%no.of independent line segments to be extracted
count = 450;
plot_count = count;


%used to store x and y coodinates for each value of count

%used to count no.of points for each value of count
each_count_total = [];

%used for final plot
total_x_coordinates = [];
total_y_coordinates = [];
addit = 0;

while J(i,j) == 1 && count>0
x_coordinates = [];
y_coordinates = [];

    [J E x_coordinates y_coordinates] = anti_clockwise_1(J,E,i,j,x_coordinates, y_coordinates);
    
   %just for checking output
   count;
    vx = x_coordinates;
    vy = y_coordinates;
    
    
   %to get the count (i.e no.of points) for each value of count
    [row1,column1] = size(x_coordinates);
    [e_row, e_column] = size(each_count_total);
    if e_column > 0
        addit = each_count_total(1,e_column);
    end
    if column1 > 0
        each_count_total = [each_count_total column1+addit];
    end
    
    
   %gathering all points  
    total_x_coordinates = [total_x_coordinates x_coordinates];
    total_y_coordinates = [total_y_coordinates y_coordinates];
    %[J E] = anti_clockwise_1(J,E,i,j);
    %[J E] = clockwise(J,E,i,j);


    bre = 0;
    for i = 1:row
        
        for j = 1:column
            
            if(J(i,j) == 1)
                
                bre = 1;
                break;
            end
            
        end
        
        if bre == 1
            
            break;
        end
    end

    count = count - 1;
    
end







%%%
%code for plotting(start)
%%%

[row,column] = size(total_x_coordinates);
loop_variable = 1;
each_count_total(1,2)
increment = 1;

pre_count = 0;


point_matrix = [];
line_matrix = [];
while loop_variable < column
    if (each_count_total(1,increment) == pre_count+1)
        %each_count_total(1,increment)
        loop_variable = loop_variable + 1;
        pre_count = each_count_total(1,increment);
        increment = increment +1;
        continue;
    end
    
    plot([total_y_coordinates(1,loop_variable),total_y_coordinates(1,loop_variable+1)],[total_x_coordinates(1,loop_variable),total_x_coordinates(1,loop_variable+1)],'LineWidth',2,'Color','green')
    %here we can add points (as told by tarun)
    x1 = total_y_coordinates(1,loop_variable);
    y1 = total_x_coordinates(1,loop_variable);
    x2 = total_y_coordinates(1,loop_variable+1);
    y2 = total_x_coordinates(1,loop_variable+1);
    slope = (y1 - y2)/(x1 - x2);
    point_matrix = [point_matrix; x1 y1; x2 y2];
    line_matrix = [line_matrix ; x1 y1 x2 y2 slope];
    
    
    
    hold on
    
    if loop_variable == each_count_total(1,increment)-1
        pre_count = each_count_total(1,increment);
        loop_variable = loop_variable+1;
        increment = increment +1;
        
    end
        
    
    loop_variable = loop_variable +1;
end


%%%
%code for plotting(stop)
%%%

line_matrix
point_matrix





%subplot(1,2,1) , imshow(J)
%subplot(1,1,1) , imshow(E)
%subplot(1,1,1) , imshow(JU)
%axis([0, 256, 0, 256])
%subplot(1,2,2) ,plot(x_coordinates,y_coordinates)

end