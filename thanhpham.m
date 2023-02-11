clc
clear ALL
format long
%tien xu ly
A=imread("C:\project\input\1.jpg");  %anh
b=rgb2gray(A);
w = graythresh(b);
c= imbinarize(b,w);
h=size(c)
 for k=1:h(1)
      for j=1:h(2)
          if c(k,j) >= 1
              c(k,j)=0;
             
          else c(k,j)=256;
          end
      end
 end
 
 %trich dang trung Hu

image=c/255;
image=im2double(image);

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


Hu(1,:)=hu_moments_vector_norm
%KNN (K=5) 
test = Hu;
data = xlsread('C:\thom\hu400.xlsx');
h=size(test);
h1=size(data);

 for j=1:400
     dis(1,j) = abs(test(1,1)- data(1,1)) + abs(test(1,2)- data(j,2))+abs(test(1,3)- data(j,3))+ abs(test(1,4)- data(j,4))+abs(test(1,5)- data(j,5)) +abs(test(1,6)- data(j,6))+ abs(test(1,7)- data(j,7))      
 end
 L1=dis(1,400)
 for k=1:400
    if dis(1,k)<L1 L1=dis(1,k)
                      A1=k  
    end
 end
 L2=dis(1,400)
 for k=1:400
     if (dis(1,k)<L2 && dis(1,k)>L1) L2=dis(1,k)
                                           A2=k
     end
 end
 L3=dis(1,400)
 for k=1:400
     if (dis(1,k)<L3 && dis(1,k)>L2) L3=dis(1,k)
                                           A3=k
     end
 end
 L4=dis(1,400)
 for k=1:400
     if (dis(1,k)<L4 && dis(1,k)>L3) L4=dis(1,k)
                                           A4=k
     end
 end
 L5=dis(1,400)
 for k=1:400
     if (dis(1,k)<L5 && dis(1,k)>L4(1)) L5=dis(1,k)
                                           A5=k
     end
 end

 L(1,:)=[L1 L2 L3 L4 L5] %la k diem gan nhat
 %A(1,:)=[A1 A2 A3 A4 A5] %vi tri nhan
 A(1,1)=A1;A(1,2)=A2;A(1,3)=A3;A(1,4)=A4;A(1,5)=A5
 
 C1=0;C2=0;C3=0;C4=0;C5=0

     for j=1:5
         if (A(1,j)>=1) && (A(1,j)<=80) C1=C1+1
         else if A(1,j)<=160 C2=C2+1
             else if A(1,j)<=240 C3=C3+1
                 else if A(1,j)<=320 C4=C4+1
                     else if A(1,j)<=400 C5=C5+1
                         end
                     end
                 end
             end
         end
     end 
 
 Max1 = 0;
 C(1,:)=[C1 C2 C3 C4 C5]
 for j=1:5
     if C(1,j)>Max1 Max1=C(1,j)
                   d=j;
     end
 end
 kiemtra=0;
 for j=1:5
     if (C(1,j)==Max1) && (j ~= d) Max2=C(1,j);
                                   n=j; 
                                   kiemtra=1
     end
 end
 % chi roi vao 3 TH: TH1: 5 qua deu xuat hien 1, TH2:2 qua xuat hien 2 lan
 %TH3:1 qua xuat hien nhieu hon cac qua con lai
if Max1==1 VT= randi(1,5)
           C6=VT
else if (kiemtra==1) VT= randi(1,2)
                if VT==1 C6=d
                else C6=n
                end
    else C6=d
    end
end

KQ(1,:)= [C1 C2 C3 C4 C5 C6] %C6 la ket qua
fprintf("========*Ket luan*========\n")
if C6==1 fprintf("Thom")
else if C6==2 fprintf("Mang Cut")
    else if C6==3 fprintf("Na")
        else if C6==4 fprintf("Chuoi")
            else if C6==5 fprintf("xoay")
                end
            end
        end
    end
end
