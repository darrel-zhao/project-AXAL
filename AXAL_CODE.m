% Parameters (ONLY CHANGE PARAMETERS)
n = 50;                                         % # of Players
AB_cut = 0.2;                                   % Cut taken by us
base_prop = 0.01;                               % base proportion (lowest)
hedge = 30;                                     % Hedge per Player

num_trials = 500;
trials = zeros(num_trials, n);

% Generating the simulated trials
for row = 1:num_trials
    trials(row, :) = gen_playerprofits(n, AB_cut, base_prop, hedge);
end

average_profits = mean(trials);

bar(average_profits);


% Function for generating player profit arrays
function [profits, ROIs] = gen_playerprofits(n, AB_cut, base_prop, hedge)
arguments
    n {mustBePositive, mustBeInteger}
    AB_cut {mustBePositive}
    base_prop {mustBePositive}
    hedge {mustBePositive}
end

% Random loss proportion generator
rand_losses = 0.6 * round(rand(1, n), 2);

% Calculate the loss proportions (row vector) and total prize pool (scalar)
loss_props = sort(rand_losses);                 
prize_pool = sum(loss_props)*hedge * (1-AB_cut);    

% Solving for the coeffs for the simplified linear distribution equation
% nx + By = 1, where x is base_prop, B is num_increments, and y 
num_increments = sum(n-1:-1:1);

% Solving for increment (y-variable)
inc = (1 - n*base_prop) / num_increments;

% Use lin_distribute() to create the array of winning proportions
win_props = lin_distribute(n, base_prop, inc);

% Array for winnings and losses per player (in $)
player_revenues = prize_pool * flip(win_props);
player_losses = hedge * loss_props;

% FINAL RESULT: Profits and ROI per player
profits = player_revenues - player_losses;
ROIs = profits ./ (hedge * ones(1,n));

end


% Function for the Linear Distribution Formula
function props = lin_distribute(n, base_prop, inc)

arguments
    n {mustBePositive, mustBeInteger};
    base_prop {mustBePositive};
    inc {mustBePositive};
end

props = zeros(1,n);

% Populate props with the correct values
for ii = 1:n
    props(ii) = base_prop + (ii-1) * inc;
end

end


% Function for the Exponential Distribution Formula (not finished)
function props = exp_distribute(n, base_prop, inc)

arguments
    n {mustBePositive, mustBeInteger};
    base_prop {mustBePositive};
    inc {mustBePositive};
end

props = zeros(1,n);

% Populate props with the correct values
for ii = 1:n-1
    props(ii) = base_prop + 2^(ii-1) * inc;
end

end
