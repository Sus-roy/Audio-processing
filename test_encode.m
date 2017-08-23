function [recording, bit_length] = test_encode()
%function recording = test_encode(codeLength)
% if nargin == 0
%     codeLength = 8;
% end
% code = randi([0,1],codeLength,1);
% code'
%......................................
fileID= fopen('q.txt','r')
formatSpec = '%c';
s = fscanf(fileID,formatSpec);
code=text2bin(s);
fclose(fileID);

bit_length=length(code);
%......................................
y=0;
idleTime = zeros(1,0.04*44100);
[preAmble1,idleTime,preAmble2,idleTime,preAmble3,idleTime,preAmble4,idleTime];
recording=[];
for j=1:length(code)
    
    if code(j) == 1
        y = upChirp(16000,16500,44100,0.02);
    elseif code(j) == 0
        y = downChirp(16500,16000,44100,0.02); 
    end
    recording = [recording, y,idleTime];    
end
reverse_recording= fliplr(recording); % to reverse
%plot(recording);
specgram(recording, 2048, 44100);
length(recording);
audiowrite('new.wav',recording,44100);
%title('original recording');

sound(recording);


end