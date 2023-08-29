function b_hat = decode_hamming(c_hat, parity_check_matrix, n_zero_padded_bits, switch_off, switch_graph)
  
    c_hat_unpadded = c_hat(1:length(c_hat)-n_zero_padded_bits, 1); % Remove padded bits
    
    if switch_off == 1
        b_hat = [];
        corrected = [];
        %ctr = zeros(1, 1);
        
        %k =0;
        for i = 1:7:length(c_hat_unpadded)  % iterating 7 bit blocks
            %k = k+1;
            c_7 = c_hat_unpadded(i:i+6);            % c_7 is a 7-element column vector
            syndrome = mod(parity_check_matrix * c_7, 2);   % Calculate syndrome by multiplying parity_check_matrix and 7-bit vector c_7
            
            if any(syndrome) % Check if there are any non-zero syndrome elements
                for j = 1:size(parity_check_matrix, 2)
                    if isequal(parity_check_matrix(:, j), syndrome) % If the jth column in the parity_check_matrix is equal to the syndrome
                        c_7(j) = ~c_7(j); % Correct the error by flipping the bit
                        %A =  (k*7)+j;
                    end
                    
                end
               %x =(k*7);
             
            end
            
            Decoder = [1 0 0 0 0 0 0;0 1 0 0 0 0 0;0 0 1 0 0 0 0;0 0 0 1 0 0 0];
            c_code = Decoder * c_7(1:7); % Decode the first 7 bits of the corrected 7-bit vector
            corrected = [corrected, c_7];
            b_hat = [b_hat; c_code];
            
        end
        
        B = reshape(corrected,[],1);
       
        %errorLocations_8 =  errorLocations(1:8);
    else
        
        b_hat = c_hat_unpadded;
    end
    
    
    % Plotting 
    
   if switch_graph == 1
        time = 1:256;
        figure('name', 'Exemplary code word ');
        subplot(2,1,1);
        stem(time, c_hat(1:256));
        xlabel('Time');
        ylabel('Amplitude');
        title('Graph of c-hat');
        subplot(2,1,2);
        stem(time, B(1:256));
        xlabel('Time');
        ylabel('Amplitude');
        title('Graph of corrected');
    end
   
end
