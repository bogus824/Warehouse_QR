function [BitMatrix] = CodeProcessing1804(img)


% cam.Brightness = 50;
% cam.Saturation = 50;
% g=0;
% img = snapshot(cam);

i = img;


I=rgb2gray(i);

[heigth width] = size(I);
T = adaptthresh(I,160/255,'ForegroundPolarity','dark');
CameraAreaThreshold1 = 0.01*heigth*width;
CameraAreaThreshold2 = 0.03*heigth*width;
BW = not((imbinarize(I,T)));
BW = bwpropfilt(BW,'Area',[CameraAreaThreshold1 CameraAreaThreshold2] );
BW = bwpropfilt(BW,'Solidity',[0.4 0.66] );
BW = bwpropfilt(BW,'Eccentricity',[0.4 0.83] );
% figure
% imshow(BW)
CC = bwconncomp(BW, 8);
s2 = regionprops(CC, 'all');
L = labelmatrix(CC);


try
    
    if s2(1).Orientation<0;
        angle = -(90+s2(1).Orientation);
    else
        angle = 90-s2(1).Orientation-1;    
    end
    
BW4 = imrotate(BW,angle);
CC = bwconncomp(BW4, 8);
s21 = regionprops(CC, 'all');
L = labelmatrix(CC);
% figure(5)
% imshow(BW4)

BW5 = imcrop(not(BW4),s21(1).BoundingBox);
% figure
% imshow(BW5)
% hold on

CodeQR = BW5;
CodeQR = bwpropfilt(CodeQR,'Area',[100 700] );
imshow(CodeQR)

%showing the code
s3 = regionprops(CodeQR,'all');

idxecc = find(0.83>=[s3.Eccentricity]);
idmajor = find(40>=[s3.MajorAxisLength]);
idmajor2= find([s3.MajorAxisLength]>=15);
result = intersect(idmajor,idmajor2);


Centroids = [s3(result).Centroid];
Xcoordinates = Centroids(1:2:end);
Ycoordinates = Centroids(2:2:end);
BeginPoints = [];
BitMatrix = zeros(9,4);
FirstLine = 0;
SecondLine = 0;
ThirdLine = 0;
FourthLine = 0;
% plot(Xcoordinates,Ycoordinates,'o');


for j=1:1:length(Xcoordinates)
    
    if (Ycoordinates(1,j)>0.8*min(Ycoordinates(:,:)))&&(Ycoordinates(1,j)<1.2*min(Ycoordinates(:,:)))
    
        BeginPoints = [BeginPoints;Xcoordinates(1,j),Ycoordinates(1,j);];
        
    end
end

for i=1:1:length(Xcoordinates)
if((abs(Xcoordinates(:,i)-BeginPoints(1,1))<10))
FirstLine = FirstLine+1;
end

if((abs(Xcoordinates(:,i)-BeginPoints(2,1))<10))
SecondLine = SecondLine+1;
end

if((abs(Xcoordinates(:,i)-BeginPoints(3,1))<10))
ThirdLine = ThirdLine+1;
end

if((abs(Xcoordinates(:,i)-BeginPoints(4,1))<10))
FourthLine = FourthLine+1;
end

end

FirstLineCoordinates = [Xcoordinates(1:FirstLine);Ycoordinates(1:FirstLine)];
SecondLineCoordinates = [Xcoordinates(FirstLine+1:FirstLine+SecondLine);Ycoordinates(FirstLine+1:FirstLine+SecondLine)];
ThirdLineCoordinates = [Xcoordinates(FirstLine+SecondLine+1:FirstLine+SecondLine+ThirdLine);Ycoordinates(FirstLine+SecondLine+1:FirstLine+SecondLine+ThirdLine)];
FourthLineCoordinates = [Xcoordinates(FirstLine+SecondLine+ThirdLine+1:FirstLine+SecondLine+ThirdLine+FourthLine);Ycoordinates(FirstLine+SecondLine+ThirdLine+1:FirstLine+SecondLine+ThirdLine+FourthLine)];    
LengthsOfLines = [FirstLine,SecondLine,ThirdLine,FourthLine];

BitM1 = [];
BitM2 = [];

BoundingBoxes = [s3(result).BoundingBox];

YCompareBox = mean(BoundingBoxes(4:4:end));

for i=1:1:4
    for j=0:1:8
        
      AssumedDistance = BeginPoints(i,2)+j*(YCompareBox)+j*5;  
      for k=1:1:LengthsOfLines(i)
        
          switch i
          
              case 1    
              
%                
                    
                    if FirstLineCoordinates(2,k)>0.90*AssumedDistance&&FirstLineCoordinates(2,k)<1.015*AssumedDistance
                        
                        Bit = 1;
                        break;
                    else
                        Bit = 0;
              
                    end
                   
                    
               case 2    
              
                 
                    if SecondLineCoordinates(2,k)>0.90*AssumedDistance&&SecondLineCoordinates(2,k)<1.015*AssumedDistance
              
                        Bit = 1;
                        break;
                    else
                        Bit = 0;
              
                    end
                    
                    
               case 3    
              
                 
                    if ThirdLineCoordinates(2,k)>0.90*AssumedDistance&&ThirdLineCoordinates(2,k)<1.015*AssumedDistance
              
                        Bit = 1;
                        break;
                    else
                        Bit = 0;
              
                    end
                    
                    
                case 4    
              
                
                    if FourthLineCoordinates(2,k)>0.90*AssumedDistance&&FourthLineCoordinates(2,k)<1.015*AssumedDistance
              
                        Bit = 1;
                        break;
                    else
                        Bit = 0;
              
                    end      
                    
                    
                    
          
          end
     
      end
      
    BitMatrix(j+1,i) = Bit;
      
    end
          
end



catch ME
   
            warning('Nie znaleziono obrazu');
            BitMatrix = [0 0 0 0];
    
end
end
%     