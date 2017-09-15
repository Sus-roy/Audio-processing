function runTests()

files = {'new_q.wav'};
code = [0,1,1,1,0,0,0,1];

results = {};

for i=1:length(files)
    
    [X,fs] = readFile(files{i});
    
    m = max(X);
    X = X .* m^-1;
    
    % Uncomment following block to search for offset
    for q=1:1024       
         testcode = decodeContents(X,fs,0,q);
         if sum(abs(testcode - code)) == 0
             fprintf('Offset %d, error %d\n', q, sum(abs(testcode - code)));
         end
     end    

    % Test for a given file
    % Parameters: 
    % X: recording
    % fs: sampling rate
    % 0/1: whether to plot results or not, 1 = yes, 0 = no
    % offset: start of signal to ignore
%    testcode = decodeContents(X,fs,1,38);
 %   testcode
  %  code
    
    testcode = decodeContents(X,fs,1,138);
    [testcode; code]
    
    
end

function testcode = decodeContents(data, fs, plotOn, offset)

if nargin < 4
    offset = 1;
end

if nargin < 3
    plotOn = 0;
end

codeLength = 8;

% Determine 
winSize = 1024;%fs * 0.02;
nfft = 2^nextpow2(winSize);
fftBins = fs/2 * linspace(0,1,nfft/2);

%
upReference = upChirp(20000,20500,fs,0.023);
downReference = downChirp(19500,19000,fs,0.023);

upReference = Utils.addPadding(upReference,nfft);
downReference = Utils.addPadding(downReference,nfft);

% Compute windowing function
windowFunction = hamming(nfft);

testcode = [];

if plotOn > 0
    clf
    figure(1);
    subplot(4,1,1);
    hold on;
    subplot(4,1,2);
    hold on;
    subplot(4,1,3);
    plot(offset:length(data),data(offset:end),'k--');
    hold on
    subplot(4,1,4);
    hold on
end

for i = offset:winSize:length(data)
    
    if (i+winSize) > length(data)
        continue
    end
    
    % Extract next window
    tmp = data(i:i+winSize-1).*2;
       
    % Add padding to the signal and perform bandpass filtering
    tmp = Utils.addPadding(tmp',nfft);
    tmp = tmp .* windowFunction';    
    
        
    tmpUp = Utils.bandPassFilter(tmp, fs, 20000,20500);
    tmpDown = Utils.bandPassFilter(tmp, fs, 19000,19500);
    
    
    % Get total energy of bandpass filtered signal
    energyUp = Utils.getEnergy(tmpUp);
    energyDown = Utils.getEnergy(tmpDown);
    
    % Extract up envelope
    eUp = Utils.getEnvelope(tmpUp,upReference);    
    eDown = Utils.getEnvelope(tmpDown,downReference);
    
    %mup = eUp(1);
    %mdown = eDown(1);       
    mup = max(eUp);
    mdown = max(eDown);
    
    bit = mup > mdown;
    bit2 = energyUp > energyDown;
    
    if bit == bit2 & max([energyUp, energyDown]) > 0.1
        testcode = [testcode; max([energyUp, energyDown]), bit];
    end
    
    
    %   testcode = [testcode; max(energyUp,energyDown), bit];
    %end
    
    if plotOn > 0
    
        subplot(4,1,1);plot([i:i+nfft-1],eUp,'r-');
        subplot(4,1,2);plot([i:i+nfft-1],eDown,'r-');
    
        subplot(4,1,4);plot([i,i+nfft-1],[0, energyUp],'k--');        
        subplot(4,1,4);plot([i,i+nfft-1],[0, energyDown],'b-.');        
    end
    
end

%testcode

[~,startIdx] = max(testcode(:,1));

curLength = 1;

l = zeros(length(testcode),1);
l(startIdx) = 1;

buffer = [];

if startIdx > 1
    buffer = [buffer, startIdx-1];
end

if startIdx < length(testcode)-1
    buffer = [buffer, startIdx + 1];
end

while curLength < codeLength
    
   if isempty(buffer)
       break
   end
   
   [~,idx] = max(testcode(buffer,1));      
   nextIdx = buffer(idx);
   ltmp = zeros(length(buffer),1);
   ltmp(idx) = 1;
   buffer = buffer(~ltmp);
   l(nextIdx) = 1;
   
   curLength = curLength + 1;
   
   if nextIdx > 1 & l(nextIdx - 1) == 0
        buffer = [buffer, nextIdx-1];
   end

    if nextIdx < length(testcode)-1 & l(nextIdx + 1) == 0
        buffer = [buffer, nextIdx + 1];
    end
   %break
    
end

testcode = testcode(find(l>0),2)';


function [data, fs] = readFile(fileName)
% Read a given audio file

[data,fs] = audioread(fileName);



