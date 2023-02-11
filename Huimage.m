clc;
clear all;
format long;
hu=[];
for i=1:2
 img = imread(['C:\project\dataout\' num2str(i) '.jpg']);
im1=im2bw(img);
% im=im1/255;
image=im2double(im);

[height, width] = size(image);

xgrid = repmat((-floor(height/2):1:ceil(height/2)-1)',1,width);
ygrid = repmat(-floor(width/2):1:ceil(width/2)-1,height,1);

[x_bar, y_bar] = centerOfMass(image,xgrid,ygrid);

xnorm = x_bar - xgrid;
ynorm = y_bar - ygrid;

mu_11 = central_moments( image ,xnorm,ynorm,1,1);
mu_20 = central_moments( image ,xnorm,ynorm,2,0);
mu_02 = central_moments( image ,xnorm,ynorm,0,2);
mu_21 = central_moments( image ,xnorm,ynorm,2,1);
mu_12 = central_moments( image ,xnorm,ynorm,1,2);
mu_03 = central_moments( image ,xnorm,ynorm,0,3);
mu_30 = central_moments( image ,xnorm,ynorm,3,0);

I_one   = mu_20 + mu_02;
I_two   = (mu_20 - mu_02)^2 + 4*(mu_11)^2;
I_three = (mu_30 - 3*mu_12)^2 + (mu_03 - 3*mu_21)^2;
I_four  = (mu_30 + mu_12)^2 + (mu_03 + mu_21)^2;
I_five  = (mu_30 - 3*mu_12)*(mu_30 + mu_12)*((mu_30 + mu_12)^2 - 3*(mu_21 + mu_03)^2) + (3*mu_21 - mu_03)*(mu_21 + mu_03)*(3*(mu_30 + mu_12)^2 - (mu_03 + mu_21)^2);
I_six   = (mu_20 - mu_02)*((mu_30 + mu_12)^2 - (mu_21 + mu_03)^2) + 4*mu_11*(mu_30 + mu_12)*(mu_21 + mu_03);
I_seven = (3*mu_21 - mu_03)*(mu_30 + mu_12)*((mu_30 + mu_12)^2 - 3*(mu_21 + mu_03)^2) + (mu_30 - 3*mu_12)*(mu_21 + mu_03)*(3*(mu_30 + mu_12)^2 - (mu_03 + mu_21)^2);


hu_moments_vector = [I_one, I_two, I_three,I_four,I_five,I_six,I_seven];
hu_moments_vector_norm= -sign(hu_moments_vector).*(log10(abs(hu_moments_vector)));


Hu(i,:)=hu_moments_vector_norm
end
xlswrite('C:\project\hu.xlsx', Hu,1);
type 'C:\project\hu.xlsx';