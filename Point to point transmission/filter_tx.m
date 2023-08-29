function s = filter_tx(z, oversampling_factor, switch_graph, switch_off)

    if switch_off==1
    t = linspace(-4,4,161); % define t with 161 values
    LPF = sinc(t); % ideal LPF
  
    z_osampled=[];
    for i=1:length(z)
        x1=[z(i),zeros(1,oversampling_factor-1)];% expanding the data z
        z_osampled= [z_osampled,x1];   
    end
    
    F_out1 = conv(LPF,z_osampled);

    F_out2=F_out1/sqrt(sum(abs(F_out1.^2))/length(F_out1)); %normalizing
    F_out= F_out2((length(LPF)+1)/2:end-(length(LPF)-1)/2); %taking only filtred output
    [~,n]=size(F_out);
    s=reshape(F_out,n,1); % make a column matrix

    if switch_graph==1
      [H,W] = freqz(F_out,1,1024);
       figure('name','Tx filter output in normalized frequency domain');
       plot(W/pi,20*log10(abs(H)));
       xlabel('\omega/pi');
       ylabel('H in DB');
       title('Transmit filter output in normalize frequency domain');

       figure('name','Tx filter output');
       subplot(2,1,1)
       plot(real(s),'c');
       xlabel('Time')
       ylabel('Real Part')
       title('Tx filter output in Time domain');
       grid on
       hold on
       subplot(2,1,2)
       plot(imag(s),'r');
       grid on
       xlabel('Time')
       ylabel('Imaginary Part')
       title('Tx filter output in Time domain');
    end
     
    else
        s=z;
    end
end
