function [z_tilde] = filter_rx (s_tilde,downsampling_factor,switch_graph,switch_off)

    if switch_off==1
        
        t = linspace(-4,4,161); 
        LPF = sinc(t); % ideal LPF
        F_out = conv( LPF, s_tilde);
        F_out=F_out/sqrt(sum(abs(F_out.^2))/length(F_out));
        z_tilde = F_out((length(LPF)+1)/2:downsampling_factor:end-(length(LPF)-1)/2);

        if switch_graph==1
            figure('name','Rx filter output')
            subplot(2,1,1)        
            plot(real(F_out),'g');
            xlabel('Time');
            ylabel('Amplitude');
            title('Real part of output of Rx filter')
            grid on
            subplot(2,1,2)
            plot(imag(F_out),'r');
            grid on
            xlabel('Time');
            ylabel('Amplitude');
            title('Imaginary part of output of Rx filter')


        end
    else
        z_tilde=s_tilde;
    end
end