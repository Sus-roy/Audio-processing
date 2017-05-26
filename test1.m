[x, fs]= audioread('sample.wav'); 
sound(x, fs); 
timex=(1: length(x))/fs; 
plot(timex, x); 
xlabel ('Seconds') ; 
ylabel ('Amplitude');

flength=1024;
foverlap=flength/2;
fftlength=flength;
wnd=hamming(flength,'periodic');
fs = 8*1e3;

sigIn = complex(inp(:,1),inp(:,2));
[y, f, t, p] = spectrogram(sigIn,wnd,foverlap,fftlength,fs,'yaxis');

%Here is the plotting
figure;
surf(t,f,10*log10(abs(p)),'EdgeColor','none');
axis xy; axis tight;colormap(jet);view(0,90);
ylabel('Frequency (Hz) ');xlabel('Time ');
