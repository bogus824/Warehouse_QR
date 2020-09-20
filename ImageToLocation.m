function [Corr Position SpecialA SpecialB] = ImageToLocation(CodeVerified)
Corr = 0;
Position = 0;
SpecialA = 0;
SpecialB = 0;
for i = 1:1:4
   
       for k=0:3
            switch i
                
                case 1
                 
                 Value = CodeVerified(k+2,1)*2^(2*(k))+CodeVerified(k+2,2)*2^(2*k+1); 
                 Corr = Corr + Value;   
                 
                 case 2
                 
                 Value = CodeVerified(k+6,1)*2^(2*(k))+CodeVerified(k+6,2)*2^(2*k+1); 
                 Position = Position + Value;   
                 
                 case 3
                 
                 Value = CodeVerified(k+2,3)*2^(2*(k))+CodeVerified(k+2,4)*2^(2*k+1); 
                 SpecialA = SpecialA + Value; 
                 
                 case 4
                 
                 Value = CodeVerified(k+6,3)*2^(2*(k))+CodeVerified(k+6,4)*2^(2*k+1); 
                 SpecialB = SpecialB + Value; 


            end


     
   
        end
end

end