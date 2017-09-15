function chirpTest()

fs = 44100;

t = fs * 0.02;
nfft = 2^nextpow2(t);

X = upChirp(19000,19500,fs,0.02);
Y = downChirp(19000,18500,fs,0.02);

subplot(4,1,1);
spectrogram(X,'yaxis');

subplot(4,1,2);
spectrogram(Y,'yaxis');

% Construct windowing function
windowFunc = hamming(nfft)';

X = Utils.addPadding(X,nfft);
Y = Utils.addPadding(Y,nfft);

% Apply window function on data
X = X.*windowFunc;
Y = Y.*windowFunc;

% Perform bandpass filtering on the signals
X = Utils.bandPassFilter(X,fs,18500,19500);
Y = Utils.bandPassFilter(Y,fs,18500,19500);

% Extract 
%f = fft(X.*windowFunc',1024);
%g = fft(Y.*windowFunc',1024);

% Extract envelopes
fUp = Utils.getEnvelope(X,X);
fDown = Utils.getEnvelope(Y,X);

subplot(4,1,3);plot(1:length(fUp),fUp,'r-')
subplot(4,1,4);plot(1:length(fDown),fDown,'r-')
% Perform band-pass filtering




