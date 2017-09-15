function code = quickTest()

th = 0.1;
correctCode = '01110001';

ts = 0.02;

[x,fs] = audioread('new_q.wav');
[s,w,t]= spectrogram(x,ts*fs);

clf;
spectrogram(x,ts*fs,'yaxis');
hold on;
%return

% Get up chirp
u = upChirp(20000,20500,fs,0.02)';

% Get down chirp
d = downChirp(19500,19000,fs,0.02)';

% Determine windowsize and number of samples
windowSize = fs * ts;
noSamples = length(x);

code = [];

for i=1:windowSize:noSamples
    
    tmp = x(i:min(noSamples,i+windowSize));    
    eup = getEnergyOfFrequency(tmp,fs,20000);
    edown = getEnergyOfFrequency(tmp,fs,19500);
   
    maxup = 0;
    maxdown = 0;
    
    if eup > th
        
        upenv =  getEnvelope(tmp,u);
        maxup = max(upenv);
        
        
        %idx1 = getIndexOfFrequency(w, fs, 20000);
        %idx2 = getIndexOfFrequency(w, fs, 20500);                
        
        w1 = 2 * pi * 20000 / fs;
        w2 = 2 * pi * 20500 / fs;
        
        %i / fs
        
        plot([i / noSamples * max(t)/ 3600, i / noSamples * max(t)/ 3600], [0, 1],'r-');
        
        %plot([i / noSamples * max(t)/3600,(i+windowSize)/noSamples * max(t) / 3600],[(pi - w1) / pi,(pi - w2) / pi],'r-');
        
        
                
    end
    
    if edown > th
        
        downenv = getEnvelope(tmp,d);
        maxdown = max(downenv);
        
        idx1 = getIndexOfFrequency(length(tmp), fs, 19500);
        idx2 = getIndexOfFrequency(length(tmp), fs, 19000);
        
        %plot([i / noSamples * max(t)/3600,(i+windowSize)/noSamples * max(t) / 3600],[w(idx1) /pi ,w(idx2) / pi],'r-');
        
    end
    
    if maxup > 0 | maxdown > 0
        
        bit = -1;
        
        if maxup>  maxdown
            bit = 1;
        elseif maxup < maxdown
            bit = 0;
        end
        
        if bit > -1
            code = [code, bit];
            if bit == 0
                %plot([
            elseif bit == 1
            end
            bit = -1;
        end
        
    end
    
    
end

function env = getEnvelope(signal, referenceSignal)

L = max([length(signal),length(referenceSignal)]);
nfft = 2^nextpow2(L);

f1 = fft(signal,nfft);
f2 = fft(referenceSignal,nfft);

f1(nfft/2+1:end) = 0;
f2(nfft/2+1:end) = 0;

combined = abs(f1) .* abs(f2);

env = ifft(abs(combined));




function e = getEnergyOfFrequency(signal, fs, frequency)

L = length(signal);
nfft = 2^nextpow2(L);

f = fft(signal,nfft);
f = 2 * abs(f(1:nfft/2+1));

frequencies = fs/2 * linspace(0,1,nfft/2+1);

[~,i] = min(abs(frequencies - frequency));

e = f(i);
    
function idx = getIndexOfFrequency(w, fs, frequency)

wtmp = 2 * pi * frequency / fs;

[~,idx] = min(abs(w - wtmp));
%idx = L - idx;


