function q1()
    file = wavread('Adaptive_Filter_Input.wav');
    fs = 44100;
    
    q1b(file, fs);
    q1c(file, fs);
    q1d(file, fs);
end

function [flt err] = jeremy_lms(inp, M, fs, start, stop)

% mic 1 is desired
% mic 2 is noise
% M is number of coefficients
% fs is sample rate
% start and stop are boundaries on the learning area of the signal

mu = 0.01;          % learning rate

w = zeros(M,1);     % filter taps

num_samples = size(inp(:,2));
y = zeros(num_samples,1); % estimated signal
err = zeros(fs*3, 1); % error tracking for plot

mic1 = [inp(:,1)]; % select mic1, pad both
mic2 = [zeros(M-1,1); inp(:,2)]; % select mic2, pad front

for i=start:stop;
    X = mic2(i+M-1:-1:i); % get the input vector
    y(i) = w' * X; % convolve to get the estimate
    err(i) = mic1(i) - y(i); % calculate error
    w = w + mu*err(i)*X; % calculate the new taps
end

flt = conv(w,mic2(M:end));
flt = mic1 - flt(1:size(mic1));

end

function q1b(inp, fs)
    figure;
    hold on;
    
    subplot(3,1,1);
    [flt err] = jeremy_lms(inp, 16, fs, 1, fs*3);
    plot(err);
    title('M=16');
    ylabel('error');
    xlabel('number of iterations');
    
    subplot(3,1,2);
    [flt err] = jeremy_lms(inp, 32, fs, 1, fs*3);
    plot(err);
    title('M=32');
    ylabel('error');
    xlabel('number of iterations');
    
    subplot(3,1,3);
    [flt err] = jeremy_lms(inp, 64, fs, 1, fs*3);
    plot(err);
    title('M=64');
    ylabel('error');
    xlabel('number of iterations');
end

function q1c(inp,fs)
    figure;
    hold on;
    subplot(2,1,1);
    plot(inp(:,1));
    title('Unfiltered Signal');
    
    [flt, err] = jeremy_lms(inp, 64, fs, 1, fs*3);
    subplot(2,1,2);
    plot(flt);
    title('Filtered Signal (M=64, learning from 1-3s)');
end

function q1d(inp, fs)
    figure;
    hold on;
    subplot(2,1,1);
    plot(inp(:,1));
    title('Unfiltered Signal');
    
    [flt, err] = jeremy_lms(inp, 64, fs, fs*12, fs*15);
    subplot(2,1,2);
    plot(flt);
    title('Filtered Signal (M=64, learning from 12-15s)');
end