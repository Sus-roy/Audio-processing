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

sound(recording);
plot(recording);
end