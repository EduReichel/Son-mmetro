function [mff] = TercioDeOctava(x,freq)


F0 = 1000;
Fs = 48000;
N = 6;
f = fdesign.octave(3,'Class 0','N,F0',N,F0,Fs);
F0 = validfrequencies(f);

F0_n = F0;

f.F0 = F0_n(freq);
fd = design(f,'butter');
m_filt = filter(fd,x);
mff = sqrt(mean(m_filt.^2)); %%CHEQUEAR ESTO, deberia ser el Leq

assignin('base','F0',F0)

end




 