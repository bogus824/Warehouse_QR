function [motor, up] = engineRotation(motor, up)

motor_border1 = 68;
motor_border2 = 112;

up = up;

if (motor <= motor_border2 && motor~=motor_border1)&&up==false
    motor = motor-1;
    up = false;
    return
end

if ((motor_border1 <= motor && up==true))&&motor~=motor_border2
    motor = motor+1;
    up = true;
    return
end

if motor == motor_border2
  motor = motor-1;
  up = false;
  return
end

if motor == motor_border1
  motor = motor+1;
  up = true;
  return
end


end