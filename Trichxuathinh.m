clc
clear all
scrfile = dir('C:\Users\Documents\MATLAB\Dataxoai\*.jpg');
for r =1: length (scrfile)
    filename = strcat( 'C:\Users\Documents\MATLAB\Dataxoai\',scrfile(r).name );
he = imread(filename);
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 2;
[cluster_idx, cluster_center] = kmeans (ab,nColors,'distance','sqEuclidean', ...
'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
segmented_images = cell(1,2);
rgb_label = repmat(pixel_labels,[1 1 3]);
for k = 1:nColors
color = he;
color(rgb_label ~= k) = 0 ;
segmented_images{k} = color;
end
B=segmented_images{2};
c=rgb2gray(B);
h = size(c);
  for i=1:h(1)
      for j=1:h(2)
          if c(i,j)> 1
              c(i,j)=256;
             
          else c(i,j)=0;
       end
      end
  end
  out= strcat('C:\Users\Documents\MATLAB\Dataxoai\xuat\',scrfile(r).name );
  imwrite( c ,out );
end 