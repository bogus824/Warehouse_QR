clear all
clc

angle = 90;
up = false;

while(angle<112)

[angle up] = engineRotation(angle,up)
pause(1)
end