clc, clear all, close all

% choose what to be exported {
    includeTestVectors = false;
    %run("soundstageSim.m"); 
    %load("movingactor4-1_reading_70dB_lecroom");
    load("movingactorYaxis4_reading_70dB_lecroom")
    % test sinewave {
        % f0 = 100;
        % f1 = 5000;
        % fs = 48000;
        % n=1;
        % mY = linspace(0, n*f0*2*pi, n*fs);
        % mY = sin(mY) + 0.5*sin(mY*f1/f0);
        % mY = mY';
    % }
% }

len = length(mY(:,1));
close all

%normalize signal
m = max(abs(mY));
m = max(m);
mY = mY./(2*m);
plot(mY);


%quantize signal
q = 16;
mY = round((2^q -1)*(mY) -0.5);

if includeTestVectors 
    run("simple_algorithm.m");
    mY = [mY, out.'];
end

% convert to 2s compliment
mY = mod(mY, 2^(q-1)) -(2^(q-1))*floor(mY./(2^(q-1)));
%plot(mY); hold on;

if includeTestVectors 
    mY = [mY, out.' + 2^(q-1)];
    mY = [mY, (phaseA.*(2^(q-3))).'];
end


%Bit converter
Bits = zeros(len, 4, q);
oune = char(49);
zerou = char(48);
for m = 1:length(mY(1,:))
    if m==5
        fileId = fopen("Correct_2s.txt", "w");
    elseif m==6
            fileId = fopen("Correct_DAC.txt", "w");
    elseif m == 7
        fileId = fopen("Correct_PA.txt", "w");
    else
        fileId = fopen("simMic_" + string(m) + ".txt", 'w');
    end

    megaStr = char(len*(q+2));
    for i=1:len
        for b = 1:q
            if mY(i,m)/ 2^(q-b) >=1
                Bits(i,m,b) = 1;
                mY(i,m) = mY(i,m) -2^(q-b);
                megaStr((i-1)*(q+2) +b) = oune;
            else
                megaStr((i-1)*(q+2) +b) = zerou;
            end
        end
            megaStr((i-1)*(q+2) +q+1) = "\";
            megaStr((i-1)*(q+2) +q+2) = "n";
    end

    fprintf(fileId, megaStr);
    fclose(fileId);
end
