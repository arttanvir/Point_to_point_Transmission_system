function d=map2symbols(c,constellation_order,switch_graph)
    
    % M is the total number of constellation points in the modulation scheme
    % m is The modulation index
    % MP = 2(M-1)/3
if constellation_order == 2
    m = 2;  % Modulation index or constellation_order , m = log2(M)
    MP = 2; % Value to achieve average symbol power of 1 after normalization
elseif constellation_order == 4
    m = 4;
    MP = 10;
elseif constellation_order == 6
    m = 6;
    MP = 42;
else
    error('Invalid constellation order');
end

M = 2^m;                       % Number of QAM points in the constellation
x = -sqrt(M) + 1;              % Initialize x-coordinate of QAM points
y = x;                         % Initialize y-coordinate of QAM points
QAM_point = zeros(M, 1);       % Initialize QAM points array

% Generating QAM constellation points for each modulation scheme

for i1 = 1:sqrt(M)
    for j1 = 1:sqrt(M)
        index = (i1-1)*sqrt(M) + j1;    % Calculate index for current QAM point
        QAM_point(index) = x + y*1i;    % Add QAM point to the constellation
        x = x + 2;                      % Increment x-coordinate
    end
    x = -sqrt(M) + 1;                   % Reset x-coordinate
    y = y + 2;                          % Increment y-coordinate
end

QAM_points = QAM_point / sqrt(MP);      % Normalize the QAM constellation

d = zeros(length(c)/m, 1);              % Initialize modulated symbols array

% Perform symbol mapping using Gray coding
for index = 1:m:length(c)
    binary = c(index:index+m-1);                   % Extract binary symbols for current symbol mapping
    modulated_index = 0;                           % Initialize decimal index for current symbol mapping
    for bit = 1:m
        modulated_index = modulated_index*2 + binary(bit);  % Convert binary to decimal
    end
    d((index+m-1)/m) = QAM_points(modulated_index+1);       % Assign the corresponding QAM symbol value
end

if switch_graph == 1
    scatterplot(d)
    %scatter(real(d), imag(d));          % Plot the scatterplot of modulated symbols
    title('Modulation Output');
    grid on;
    axis([-2 2 -2 2]);
end


end