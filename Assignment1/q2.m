function q2()
    file = wavread('Cleaned_DTMF.wav');
    fs = 16E3;
    
    N = 900; % window size
    k = 1336/fs; % normalised frequency
    
    figure;
    hold on;
    spectrogram(file,16E3/75);
    
    figure;
    hold on;
    
    subplot(2,1,1);
    plot(goertzel(file, 1336/fs, N));
    title('clean goertzel for 1336Hz, N=900');
    
    subplot(2,1,2);
    plot(goertzel(file, 941/fs, N), 'r');
    title('clean goertzel for 941Hz, N=900');
    
    figure;
    hold on;
    
    for n=0:5
        subplot(6,1,n+1);
        plot(goertzel(awgn(file,-18+7.2*n), 1336/fs, N));
        title(['noisy goertzel for 1336Hz, N=900, SNR=' num2str(-18+7.2*n) 'dB']);
    end
end

function powers = goertzel(inp, k, N)
    coeff = 2*cos(2*pi*k);
    powers = zeros(length(inp),1);
    
    for i=1:length(inp)-N
        s = 0;
        sm1 = 0;
        sm2 = 0;
        for j=i:i+N-1
            s = coeff*sm1 - sm2 + inp(j);
            sm2 = sm1;
            sm1 = s;
        end
        powers(i) = sm2^2 + sm1^2 - coeff*sm1*sm2;
    end
end
