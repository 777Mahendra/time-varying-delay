function y = timevarying_delay(meanDelay, delayAmp, fj, fs)
    % Generate input sine wave
    N = 39999;  % Number of samples
    n = (1:N);  % Sample indices
    x = sin(2 * pi * 3400 * n / fs);  % Input signal
    
    % Compute time-varying delay D(n)
    D = meanDelay + delayAmp * sin(2 * pi * fj * n / fs);
    
    % Initialize output signal
    y = zeros(size(x));
    
    % Apply time-varying delay using interpolation
    for i = 1:N
        delayed_index = i - D(i);
        
        if delayed_index < 1
            y(i) = 0; % Handle boundary conditions
        else
            lower_index = floor(delayed_index);
            upper_index = ceil(delayed_index);
            alpha = delayed_index - lower_index;
            
            if lower_index < 1
                y(i) = 0; % Prevent negative indexing
            elseif upper_index > N
                y(i) = x(lower_index); % Use nearest valid sample if out of bounds
            else
                % Perform linear interpolation
                y(i) = (1 - alpha) * x(lower_index) + alpha * x(upper_index);
            end
        end
    end
end