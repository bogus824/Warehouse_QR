clear all
clc

CodeStr = "A11B27C52D108"
cam = webcam('Lenovo EasyCamera')
cam.Brightness = 50;
cam.Saturation = 50;
g=0;
preview(cam)
TestMatrix = ones(9,4);
tic
k = 0;
angle1 =90;
up1 = false;

while g<7
  
    img = snapshot(cam);
    [Code] = CodeProcessing1804(img);
    if (mean(mean([Code(1,:)]))== 1)&&(mean(mean(Code(:,:)-TestMatrix(:,:)))==0)
        g = g+1
    else
    g=0;

k=k+1;
if k==7
[angle1 up1] = engineRotation(angle1,up1)
k = 0;
end
end
TestMatrix = Code;

end

if g == 7
    
    VerifiedCode = Code
    [Corr Position SpecialA SpecialB] = ImageToLocation(VerifiedCode);
    time = toc
end

location = "A"+int2str(Corr)+"B"+int2str(Position)+"C"+int2str(SpecialA)+"D"+int2str(SpecialB)
locationv = [Corr,Position,SpecialA,SpecialB]

if CodeStr==location
    
    str = "Code matches"
    ifaccepted = 1;
else
    str = "Wrong Code"
    ifaccepted = 0;
    
end

closePreview(cam)
