clc
clear all
format long
test = xlsread('C:\project\hu.xlsx');
data = xlsread('C:\project\Hu400.xlsx');
h=size(test);
h1=size(data);
for i=1:2
 for j=1:400
     dis(i,j) = abs(test(i,1)- data(j,1)) + abs(test(i,2)- data(j,2))+abs(test(i,3)- data(j,3))+ abs(test(i,4)- data(j,4))+abs(test(i,5)- data(j,5)) +abs(test(i,6)- data(j,6))+ abs(test(i,7)- data(j,7))      
 end
 L1(i)=dis(i,400)
 for k=1:400
    if dis(i,k)<L1(i) L1(i)=dis(i,k)
                      A1(i)=k  
    end
 end
if (A1(i)>=1) && (A1(i)<=80) N=1
         else if A1(i)<=160 N=2
             else if A1(i)<=240 N=3
                 else if A1(i)<=320 N=4
                     else if A1(i)<=400 N=5
                         end
                     end
                 end
             end
end

KQ(i,:)=[L1(i) A1(i) N]
%L1 la khoang cach, A la vi tri, N la ket qua 
 
end
