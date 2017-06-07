function recording = encode(code)
%


%preAmble();
recording = [];

% create
%y = preAmble();
%recording = [recording,y];

for i=1:length(code)
    
    if code(i) == 1
        y = upChirp();
    elseif code(i) == 0
        y = downChirp();
    end
    
    recording = [recording,y];
    
    if i < length(code)
        %y = createPause();
        %recording = [recording,y];
    end
    
end