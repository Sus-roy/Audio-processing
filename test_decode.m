clear all
recording=test_encode(16);
preamble= upChirp(0,800,44100,0.1);
Lx = length(recording);%nfft for recording
Ly = length(preamble);%nfft fpr preamble

%zero padding of preamble to the length of recording
y = Ly;
if Ly < Lx
    y(Lx) = 0;
end
Ly = length(y);

%fft of recording
NFFT = 2^nextpow2(Lx);% Next power of 2 from length of Lx
%jehetu lx=ly after zero padding tai ekta Nfft value nilei hobe. for recording and preamble ektai nfft hobe ekhon.
fft_recording = fft(recording,NFFT);
fft_recording = abs(fft_recording(1:NFFT/2));
%plot(fft_recording);

%fft of preamble
NFFT = 2^nextpow2(Ly);% Next power of 2 from length of Lx
%jehetu lx=ly after zero padding tai ekta Nfft value nilei hobe. for recording and preamble ektai nfft hobe ekhon.
fft_preamble = fft(preamble,NFFT);
fft_preamble = abs(fft_preamble(1:NFFT/2));
%plot(fft_preamble);

%convolution of fft_preamble and fft_recording
convolution = fft_recording .* fft_preamble;
convolution=convolution(1:NFFT/2);
convolution = abs(ifft(convolution,NFFT));
convolution=convolution(1:NFFT/2);
%plot(convolution);

convolution=[zeros([1 1000]), convolution]; %zero padding
x = linspace(0,1.2,length(convolution));
figure
plot(x,convolution);
title('Convoluted signal: Preamble & Recording')
[pks,index] = findpeaks(convolution,x);

%finding max peak which as preamble delimeter
[maxi,i] = max(pks);% maxi te preamble value mane y axiser value ache
max=index(i);% index =x axis jekhane highest peak mane preamble ache

%system demodulation
up = upChirp(0,800,44100,0.02);
down = downChirp(800,0,44100,0.02);
Lup = length(up);
Ldown= length(down);

y = Lup;
if Lup < Lx
    y(Lx) = 0;
end
Lup = length(y);


y = Ldown;
if Ldown < Lx
    y(Lx) = 0;
end
Ldown = length(y);

%fft of upchirp 
NFFT = 2^nextpow2(Lup);% Next power of 2 from length of Lx
%jehetu lup=ldown after zero padding tai ekta Nfft value nilei hobe. for recording and preamble ektai nfft hobe ekhon.
fft_up = fft(up,NFFT);
fft_up = abs(fft_up(1:NFFT/2));
%plot(fft_up);

%fft of downchirp 
NFFT = 2^nextpow2(Ldown);% Next power of 2 from length of Lx
%jehetu lx=ly after zero padding tai ekta Nfft value nilei hobe. for recording and preamble ektai nfft hobe ekhon.
fft_down = fft(down,NFFT);
fft_down = abs(fft_down(1:NFFT/2));
%plot(fft_down);

%convolution with up chirp
convolution1 = fft_up .* fft_recording;
convolution1=convolution1(1:NFFT/2);
convolution1 = abs(ifft(convolution1,NFFT));
convolution1=convolution1(1:NFFT/2);
convolution1=[zeros([1 1000]), convolution1]; %zero padding
x1 = linspace(0,1.2,length(convolution1));
figure
plot(x1,convolution1);
title('Convoluted signal: Upchirp & Recording')

%convolution with down chirp
convolution2 = fft_down .* fft_recording;
convolution2=convolution2(1:NFFT/2);
convolution2 = abs(ifft(convolution2,NFFT));
convolution2=convolution2(1:NFFT/2);
convolution2=[zeros([1 1000]), convolution2]; %zero padding
x2 = linspace(0,1.2,length(convolution2)); 
figure
plot(x2,convolution2);
title('Convoluted signal:Downchirp & Recording')

%last part

[peak1,index1] = findpeaks(convolution1,x1);
length(index1);
%fprintf('%i**', index1);
[peak2,index2] = findpeaks(convolution2,x2);
length(index2);
%fprintf('%i**', index2);
data_received = [];

for i=max+0.04:0.04:1.2
    
    %p=find(index1==i);
    p=peak1(find(index1==i));
    
    %p=find(index2==i);
    q=peak2(find(index2==i));
    
    if p > q
        data_received =[data_received 1];
    end
    if q > p
        data_received =[data_received 0];
    end
end

data_received
