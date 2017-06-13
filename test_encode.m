function recording = test_encode(codeLength)
if nargin == 0
    codeLength = 16;
end
code = randi([0,1],codeLength,1);
recording = [];
idleTime = zeros(1,0.04*44100);
preAmble= upChirp(0,200,44100,0.1);
recording = [preAmble,idleTime];
for j=1:length(code)
    if code(j) == 1
        y = upChirp(0,200,44100,0.02);
    elseif code(j) == 0
        y = downChirp(200,0,44100,0.02); 
    end
    recording = [recording, y, idleTime];    
end

size(recording);
figure
subplot(2,1,1)
plot (recording)
title('original recording')
sound(recording)
end
