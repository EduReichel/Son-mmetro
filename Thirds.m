function [SOS,G,F0,Nfc] = Thirds(Fs,n)

BandsPerOctave = 1;  
N = 8;           % Filter Order
F0 = 1000;       % Center Frequency (Hz)
f = fdesign.octave(BandsPerOctave,'Class 0','N,F0',N,F0,Fs);

f.BandsPerOctave = 3;
f.FilterOrder = n;
F0 = validfrequencies(f);
assignin('base','F0',F0)
Nfc = length(F0);

for i=1:Nfc,
    f.F0 = F0(i);
    oneThirdOctaveFilterBank(i) = design(f,'butter');
    SOS(:,:,i) = get(oneThirdOctaveFilterBank(i),'sosMatrix');
    G(:,i) = get(oneThirdOctaveFilterBank(i),'ScaleValues');
end