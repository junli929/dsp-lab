% Load noisy input data into x
x=read_hex('IOS0010');

Fs=500; % Sampling frequency
N=length(x);
t = (0:N-1)/Fs; % time array

% Create a low pass filter with a cut-off frequency of 15 Hz
wn=15/(Fs/2);
order=31;
h = fir1(order, wn );  % FIXME - Insert the correct value here!
res = h./2^(-15);
fprintf('.dw 0x%04x\n',round(res))
% Matlab based filtering
y = filter(h, 1, x);

if exist('IOS0011')
  y_senior=read_hex('IOS0011');
 else
   fprintf('Warning: IOS0011 output from srsim not found!\n'); 
   y_senior=zeros(1,length(y));
end

relerr = visualize_timedomain(x,y,y_senior,t,h);
fprintf('Relative error of Senior implementation compared to Matlab implementation: %f\n',relerr);
visualize_freqdomain(x,y,y_senior,t,h,Fs);

