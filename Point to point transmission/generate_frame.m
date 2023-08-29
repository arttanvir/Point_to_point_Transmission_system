function b = generate_frame(frame_size,switch_graph)
    % Generate a mean-free binary sequence
    b = randi([0 1], frame_size, 1);
    
    % Calculate number of zeros and ones
    num_zeros = sum(b == 0);
    num_ones = sum(b == 1);
    
    %algorithm to generate mean free or equal number of zeros and ones
    
    if num_zeros ~= num_ones 
        if num_zeros > num_ones
            indices = find(b == 0);
            indices = indices(randperm(num_zeros, num_zeros - num_ones));
            b(indices) = 1; %replace a random subset of 0 with 1 to balance out
        else
            indices = find(b == 1);
            indices = indices(randperm(num_ones, num_ones - num_zeros));
            b(indices) = 0; %replace a random subset of 1 with 0 to balance out
        end
    end
    
if  switch_graph ==1    
    % Plotting the binary pattern of one frame
    stem(b);
    xlabel('Time');
    ylabel('Binary Value');
    title('Binary Pattern of One Frame');
    grid on;

end
