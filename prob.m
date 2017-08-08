clear all
[recording,bit_length]=test_encode();
figure
plot(recording)
Fs=44100;
Lx = length(recording);
up = upChirp(0,800,Fs,0.02);
down = downChirp(800,0,Fs,0.02);
Lup = length(up);
Ldown= length(down);
Nfft = Lx + Lup - 1;
Nfft = 2^nextpow2(Nfft);

f1=fft(recording,Nfft);
f1=f1(1:Nfft/2);

f2=fft(up,Nfft);
f2=f2(1:Nfft/2);
convolution1 = f1 .* f2;

convolution1=abs(ifft(convolution1));
Nfft = Lx + Ldown - 1;
Nfft = 2^nextpow2(Nfft);

f3=fft(down,Nfft);
f3=f3(1:Nfft/2);

convolution2 = f1 .* f3;
convolution2=abs(ifft(convolution2));

figure
plot(convolution1)
figure
plot(convolution2)

data_received = [];
Fs=44100;

%timeShift = 0.02 * Fs;%1764 882
timeShift1 = .16 * Fs;%7056
symbol=.02*Fs;%882
d1=[];
d2=[];
length(convolution1);
for i=1:symbol:timeShift1
    fprintf('%d\n',i);
    d1=[];
    d2=[];
  
   
for j=i:i+symbol
    %fprintf('%d\n',j);
    if j > length(convolution1) 
        break
    end
    d1=[d1 convolution1(j)];
    d2=[d2 convolution2(j)];
end
    p=max(d1);
    q=max(d2);
    if p > q
        data_received =[data_received 0];
    end
    if q > p
        data_received =[data_received 1];
    end
    
    
  
end
    
data_received






