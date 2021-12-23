% FigHandle = reconstitutePulse(CelestaLogPath, ExistingFigHandle(OPTIONAL))
function FigHandle = reconstitutePulse(CelestaLogPath, ExistingFigHandle)
    % Parameter settings
    FontSize = 15;
    LineWidth = 1.5;
    BoxOnOrOff = 'off';
    
    % Read the log file (comma-separated)
    LogTable = readtable(CelestaLogPath, 'FileType', 'text');
    InstantaneousPowers = LogTable.Var2;
    
    % Calculate the empirical cumulative distribution (plotting inhibited)
    [ECP, EvalPts] = ecdf(InstantaneousPowers);
    
    % Plot
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
    set(gca, 'FontSize', FontSize, 'LineWidth', LineWidth, 'box', BoxOnOrOff);
end
