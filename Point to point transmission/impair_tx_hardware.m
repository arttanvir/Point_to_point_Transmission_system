function x=impair_tx_hardware(s,clipping_threshold,switch_graph)
 
abs_Value = abs(s);             
theta_angle = angle(s);       

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

x = complex(a, b);               % Form complex number 


if switch_graph==1
    figure;
    subplot(2,1,1)
    plot(real(s),'g');
    title('Real part Non clipped signal')
    grid on
    subplot(2,1,2)
    plot(real(x),'r');
    grid on
    title('Real part output of impair_tx_hardware')
    figure;
    subplot(2,1,1)
    plot(imag(s),'g');
    title('Imaginary part Non clipped signal')
    grid on
    subplot(2,1,2)
    plot(imag(x),'r');
    grid on
    title('Imaginary part output of impair_tx_hardware')
end
end
