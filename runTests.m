function runTests()

files = {'new_q.wav'};
codes = {'01110001'};

results = {};

for i=1:length(files)
    
    [X,fs] = readFile(files{i});
    testcode = decodeContents(X,fs);    
    
end

function testcode = decodeContents(data, fs)

% Determine 
winSize = fs * 0.02;
nfft = 2^nextpow2(winSize);
fftBins = fs/2 * linspace(0,1,nfft/2);

% Extract frames for passing through the data
windowFunction = hamming(nfft);

for i = 1:nfft/2:length(data)
    
    % Extract next window
    tmp = data(i:i+nfft-1);
    
    % ap
    
    % Get energy of each bin
    
    
end


% % FFT resolution
% nfft1 = 2^nextpow2(fs * 0.01);
% nfft2 = 2^nextpow2(fs * 0.02);
% 
% h1 = hamming(nfft1);
% h2 = hamming(nfft2);
% 
% fftBins1 = fs/2 * linspace(0,1,nfft1/2);
% fftBins2 = fs/2 * linspace(0,1,nfft2/2);
% 
% energies = zeros(length(fftBins1),1);
% ss = zeros(length(fftBins1),1);
% N = zeros(length(fftBins1),1);
% 
% firstwin = 1;
% 
% testcode = [];
% 
% for i=1:nfft1:length(data)
%     
%     tmp = data(i:i+nfft1-1);
%                 
%     f = fft(tmp);
%     f = 2 * abs(f(1:nfft1/2));    
%     
%     lf = logical(fftBins1 >= 19000 & fftBins1 <= 20500);
%     f(~lf) = 0;
%     
%     if sum(f) == 0
%         continue
%     end
%     
%     if firstwin == 1
%         energies = f;
%         ss = (f - energies).^2;
%         N = ones(length(f),1) + 1;
%         firstwin = 0;
%         continue;                
%     end    
%     
%     lenerg =  logical(ss > 0);
%     
%     stmp = max(sqrt(ss(lenerg)./ N(lenerg)),0.001);
%     zval = (f(lenerg) - energies(lenerg)) ./ (stmp);
%     
%     l = logical(abs(zval) > tinv(1 - 0.001/2, N(lenerg))) & logical(f(lenerg) > 0);    
%     
%     if nnz(l) > 0        
%         testcode = [testcode; ones(nnz(l),1)*i, fftBins1(find(l))'];
%     end
%         
%     energies = energies + (1 ./ (N + 1)) .* (f - energies);
%     t = N;
%     ss = ss + (t - 1) ./ t .* (f - energies).^2;
%     N = N + 1;
%     
%     
% end
% 
% %[ss,energies,N]
% 
% size(testcode)
% 
% 
% clf;
% figure(1)
% hold on;
% plot(1:length(data),data,'k--')
% 
% figure(2);
% hold on
% 
% for q=1:length(testcode)
%     
%     val = testcode(q,:);
%     f = val(:,2);
%     val = val(:,1);
%     
%     if f < 18000
%         continue
%     end
%     
%     f
%             
%     plot([val,val+nfft1],[f,f],'r-x');
%     
% end


function [data, fs] = readFile(fileName)
% Read a given audio file

[data,fs] = audioread(fileName);

