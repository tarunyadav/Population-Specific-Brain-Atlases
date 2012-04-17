function [ I ] = template_average( transformations,reg_images,z )

R = transformations;
I= reg_images;

R = R(:,1:3);
R = abs(R);

s = size(R);
row = s(1,1);


Tx_c = 1;
Ty_c = 1;
R_c = 1;

sum = [];

for i = 1:row
    temp = (Tx_c/256)*R(i,1) + (Ty_c/256) * R(i,2) + (R_c/360) * R(i,3);
    sum = [sum; temp];
end

[sort_sum index_sum] = sort(sum);
% for dissimilar matching
if(z==1)
        si = size(index_sum,1);
        new_index_sum = [];
        if mod(si,2) == 0
            for i = 1:si/2
                new_index_sum = [new_index_sum; index_sum(i); index_sum(si-i+1)];
            end
        end

        if mod(si,2) == 1
            half = round(si/2) - 1;
            for i = 1:half
                  new_index_sum = [new_index_sum ;index_sum(i); index_sum(si-i+1)];
            end
            new_index_sum = [new_index_sum ;index_sum(half+1)];
        end
        index_sum = new_index_sum;
end

s = size(index_sum);
row = s(1,1);
temp_I = [];

while row > 1
    
    temp_I = [];
   % row
    for i = 1:2:row
        index = index_sum(i);
        image1 = I((index-1)*256 + 1:index*256,:);
        if i+1 <= row
            index = index_sum(i+1);
            image2 = I((index-1)*256 + 1:index*256,:);
            result = (image1 + image2)/2;
            
            temp_I = [temp_I; result];
        end
        
        if(i == row)
            temp_I = [temp_I ; image1];
        end
    end
    I = temp_I;
    
    [row column] = size(I);
    row = row/256;
    index_sum = [];
    for i = 1:row
        index_sum = [index_sum i];
    end
end

end

