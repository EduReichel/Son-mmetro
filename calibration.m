function [calibratedSignal]=calibration(s,c)

rmsValue= rms(c);

calibratedSignal=s/(rmsValue);

end