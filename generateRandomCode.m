function code = generateRandomCode(codeLength)
%
% Generates a random code of the given length.
% Input parameters:
%   codeLength - the length of the code in bits.
% Output parameters:
%   code - bit string of the code
% 

if nargin == 0
    codeLength = 16;
end

code = randi([0,1],1,codeLength);