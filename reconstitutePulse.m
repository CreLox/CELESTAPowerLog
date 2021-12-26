% [PulseProperty, FigHandle] = reconstitutePulse(CelestaLogPath,
% ExistingFigHandle(OPTIONAL))
% -------------------------------------------------------------------------
% median(PulseProperty.Durations) ~= actual exposure time * empirical
% factor (1.4 ~ 1.5)
function [PulseProperty, FigHandle] = reconstitutePulse(CelestaLogPath, ...
    ExistingFigHandle)
    
    % Plotting parameters
    FontSize = 15;
    LineWidth = 1.5;
    BoxOnOrOff = 'off';
    % Filtering parameters
    PowerThreshold = 5; % mW
    SamplingIntervalThreshold = 0.15; % s
    
    % Read the log file (comma-separated)
    LogTable = readtable(CelestaLogPath, 'FileType', 'text');
    InstantaneousPowers = LogTable.Var2;
    
    % Calculate the empirical cumulative distribution (plotting inhibited)
    [ECP, EvalPts] = ecdf(InstantaneousPowers);
    
    % New figure: plot instantaneous power readout-t
    figure;
    scatter(LogTable.Var1, LogTable.Var2, 'k.');
    xlabel('Time');
    ylabel('Instantaneous power (mW)');
    set(gca, 'FontSize', FontSize, 'LineWidth', LineWidth, ...
        'box', BoxOnOrOff);
    
    % Plot the inverse ECDF and set it as the current active figure
    if ~exist('ExistingFigHandle', 'var') || isempty(ExistingFigHandle)
        FigHandle = figure;
        stairs(ECP, EvalPts, 'k', 'LineWidth', LineWidth);
    else
        FigHandle = figure(ExistingFigHandle);
        hold on;
        stairs(ECP, EvalPts, 'LineWidth', LineWidth);
    end
    xlabel('Empirical cumulative probability'); % ECP
    ylabel('Instantaneous power (mW)');
    set(gca, 'FontSize', FontSize, 'LineWidth', LineWidth, ...
        'box', BoxOnOrOff);
    
    % Identify individual pulses and calculate their properties
    FilteredLogTable = LogTable(InstantaneousPowers >= PowerThreshold, :);
    RecordIntervals = seconds(diff(FilteredLogTable.Var1));
    
    PulseProperty.Durations = zeros(1, length(RecordIntervals));
    PulseProperty.AvgSamplingIntervals = zeros(1, length(RecordIntervals));
    ThisPulseDuration = 0;
    TheseIntervals = zeros(1, length(RecordIntervals));
    j = 1;
    k = 1;
    for i = 1 : length(RecordIntervals)
        if (RecordIntervals(i) < SamplingIntervalThreshold)
            ThisPulseDuration = ThisPulseDuration + RecordIntervals(i);
            TheseIntervals(k) = RecordIntervals(i);
            k = k + 1;
        else
            TheseIntervals = TheseIntervals(TheseIntervals > 0);
            PulseProperty.AvgSamplingIntervals(j) = mean(TheseIntervals);
            PulseProperty.Durations(j) = ThisPulseDuration + ...
                PulseProperty.AvgSamplingIntervals(j);
            ThisPulseDuration = 0;
            TheseIntervals = zeros(1, length(RecordIntervals));
            j = j + 1;
            k = 1;
        end
    end
    TheseIntervals = TheseIntervals(TheseIntervals > 0);
    PulseProperty.AvgSamplingIntervals(j) = mean(TheseIntervals);
    PulseProperty.Durations(j) = ThisPulseDuration + ...
        PulseProperty.AvgSamplingIntervals(j);
    PulseProperty.Durations = PulseProperty.Durations(1 : j);
    PulseProperty.AvgSamplingIntervals = ...
        PulseProperty.AvgSamplingIntervals(1 : j);
    
end
