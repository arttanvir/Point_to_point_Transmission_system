function s_tilde=impair_rx_hardware(y,clipping_threshold,switch_graph)

abs_Value = abs(y);             
theta_angle = angle(y);       

clipped_value = zeros(1,length(abs_Value));


for i = 1: length(abs_Value)
    
    % Clip when Filter_in_abs(i)> rx_clipping_threshold = 1;
    if abs_Value(i) > clipping_threshold
        clipped_value(i)= clipping_threshold;
    else
        clipped_value(i)=abs_Value(i);
    end
end

[a, b] = pol2cart(theta_angle, abs_Value);     % Convert polar coordinates to Cartesian coordinates

s_tilde = complex(a, b);               % Form complex number 


if switch_graph==1
    figure;
    subplot(2,1,1)
    plot(real(y),'g');
    title('Real part Non clipped signal')
    grid on
    subplot(2,1,2)
    plot(real(s_tilde),'r');
    grid on
    title('Real part output of impair_rx_hardware')
    figure;
    subplot(2,1,1)
    plot(imag(y),'g');
    title('Imaginary part Non clipped signal')
    grid on
    subplot(2,1,2)
    plot(imag(s_tilde),'r');
    grid on
    title('Imaginary part output of impair_rx_hardware')
end
end
