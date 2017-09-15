function testChirp()
%
% Test the performance of the chirp detection.
%

% The number of codes to try
NoRepetitions = 1;

% The code length to use
CodeLength = 8;

errors = zeros(NoRepetitions,1);

for i = 1:NoRepetitions
    
    code = generateRandomCode(CodeLength);    
        
    recording = encode(code);    
    recordedCode = decode(recording,44100);
    recordedCode = generateRandomCode(CodeLength);
    
    % Determine the number of bit errors
    bitErrors = nnz(code & recordedCode);
    errors(i) = bitErrors;
    
end

%cdfplot(errors)

fprintf('Correct codes: %f\n',nnz(errors == 0) / NoRepetitions);

