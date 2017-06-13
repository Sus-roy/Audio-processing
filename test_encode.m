function recording = encode(codeLength)
if nargin == 0
    codeLength = 16;
end
code = randi([0,1],codeLength,1);
%preAmble = [1 0 0 1 0 1];
recording = [];
idleTime = 0.04 %40ms;
preAmble = upChirp(0,200,0.1*44100) + idleTime;
recording = [preAmble,recording];

for j=1:length(code)
    
    if code(j) == 1
        y = upChirp() + idleTime;
    elseif code(j) == 0
        y = downChirp() + idleTime;
    end
    recording = [y,recording];    
end

%plotting the original recording and revrese recording
size(recording)  
reverse_recording= fliplr(recording);
figure
subplot(2,1,1)
plot (recording)
title('original recording')

subplot(2,1,2)
plot (reverse_recording)
 
title('reverse recording')
%sound(recording)
%sound(reverse_recording)

end
