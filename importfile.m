function [dat] = importfile(filename, loadBehav)
%IMPORTFILE1 Import numeric data from a text file as column vectors.
%  [dat] = IMPORTFILE1(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [dat]= IMPORTFILE1(FILENAME, loadBehav) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%               if loadBehav == 1: loads the behavioral data to dat structure.
%
% Example:
%   [dat]= importfile('regret_2016-03-15_s01_r01.mat.tsv',1);
%
%    See also TEXTSCAN.

% Jin : added data parsing and interpolation features on 2016/02/11
% Auto-generated by MATLAB on 2016/02/05 17:45:56
%% Initialize variables.
startRow = 2;
endRow = inf;
delimiter = '\t';
if nargin < 1
    dir = pwd; 
    filename = 'regret_2016-03-15_s01_r01.mat.tsv';
    filename = [dir,'/data/test/',filename];
    loadBehav = 1;
    bfilename = [dir,'/data/test/','regret_2016-03-15_s01_r01.mat'];
elseif  nargin< 2
    dir = pwd;
    filename = [dir,'/data/test/',filename];
    loadBehav = 1;
    bfilename = [dir,'/data/test/','regret_2016-03-15_s01_r01.mat'];
end


%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [2,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]);
rawCellColumns = raw(:, [1,3,4]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
pre.timestamp = rawCellColumns(:, 1);
pre.time = cell2mat(rawNumericColumns(:, 1));
pre.fix = rawCellColumns(:, 2);
pre.state = rawCellColumns(:, 3);
pre.rawx = cell2mat(rawNumericColumns(:, 2));
pre.rawy = cell2mat(rawNumericColumns(:, 3));
pre.avgx = cell2mat(rawNumericColumns(:, 4));
pre.avgy = cell2mat(rawNumericColumns(:, 5));
pre.psize = cell2mat(rawNumericColumns(:, 6));
pre.Lrawx = cell2mat(rawNumericColumns(:, 7));
pre.Lrawy = cell2mat(rawNumericColumns(:, 8));
pre.Lavgx = cell2mat(rawNumericColumns(:, 9));
pre.Lavgy = cell2mat(rawNumericColumns(:, 10));
pre.Lpsize = cell2mat(rawNumericColumns(:, 11));
pre.Lpupilx = cell2mat(rawNumericColumns(:, 12));
pre.Lpupily = cell2mat(rawNumericColumns(:, 13));
pre.Rrawx = cell2mat(rawNumericColumns(:, 14));
pre.Rrawy = cell2mat(rawNumericColumns(:, 15));
pre.Ravgx = cell2mat(rawNumericColumns(:, 16));
pre.Ravgy = cell2mat(rawNumericColumns(:, 17));
pre.Rpsize = cell2mat(rawNumericColumns(:, 18));
pre.Rpupilx = cell2mat(rawNumericColumns(:, 19));
pre.Rpupily = cell2mat(rawNumericColumns(:, 20));

%% Jin: Reorganize data to include a event row. 
ix = ~isnan(pre.time); % Get indexes for data / excludes non data message triggers
post.timestamp = pre.timestamp(ix);
post.time = pre.time(ix);
post.fix = pre.fix(ix);
post.state = str2double(pre.state(ix));
post.rawx = pre.rawx(ix);
post.rawy = pre.rawy(ix);
post.avgx = pre.avgx(ix);
post.avgy = pre.avgy(ix);
post.psize = pre.psize(ix);
post.Lrawx = pre.Lrawx(ix);
post.Lrawy = pre.Lrawy(ix);
post.Lavgx = pre.Lavgx(ix);
post.Lavgy = pre.Lavgy(ix);
post.Lpsize = pre.Lpsize(ix);
post.Lpupilx = pre.Lpupilx(ix);
post.Lpupily = pre.Lpupily(ix);
post.Rrawx = pre.Rrawx(ix);
post.Rrawy = pre.Rrawy(ix);
post.Ravgx = pre.Ravgx(ix);
post.Ravgy = pre.Ravgy(ix);
post.Rpsize = pre.Rpsize(ix);
post.Rpupilx = pre.Rpupilx(ix);
post.Rpupily = pre.Rpupily(ix);
%% Jin: Get rid of nonsense data values of x >  1440 or y > 990 ????
% xmax = 1440; ymax = 990;
% ix = post.rawx>xmax|post.rawy>990;  % Get indexes for data / excludes non data message triggers

%% Jin: Categorize event
post.event_cell = pre.state(~logical([0; ~ix(1:end-1,1)]));
post.event_cell = post.event_cell(1:end-1);
post.event_num = zeros(length(post.event_cell),1);
post.event_ix = zeros(length(post.event_cell),1);
for i = 1:length(post.event_cell)
    if length(post.event_cell{i})>2
        post.event_ix(i,1) = 1;
        % 1 : get choice, 2: chose left, 3: chose right, 4: result, 5: 
        if strcmp(post.event_cell{i},'Get Choice')
            post.event_num(i,1) = 1;
        elseif strcmp(post.event_cell{i},'Chose left')
            post.event_num(i,1) = 2;
        elseif strcmp(post.event_cell{i},'Chose right')
            post.event_num(i,1) = 3;
        elseif strcmp(post.event_cell{i},'Result Left')
            post.event_num(i,1) = 4;
        elseif strcmp(post.event_cell{i},'Result Right')
            post.event_num(i,1) = 5;
        elseif strcmp(post.event_cell{i},'Regret left')
            post.event_num(i,1) = 6;
        elseif strcmp(post.event_cell{i},'Regret right')
            post.event_num(i,1) = 7;
        else
            post.vent_num(i,1) = 8;
        end
    end
end

%% Jin: Interpolate data. 
intp = struct();
intp.timestamp = post.timestamp;
intp.time = post.time;
intp.fix = post.fix;
intp.state = post.state;
intp.rawx = post.rawx;
intp.rawy = post.rawy;
intp.avgx = post.avgx;
intp.avgy = post.avgy;
intp.psize = post.psize;
% intp.Lrawx = post.Lrawx;
% intp.Lrawy = post.Lrawy;
% intp.Lavgx = post.Lavgx;
% intp.Lavgy = post.Lavgy;
% intp.Lpsize = post.Lpsize;
% intp.Lpupilx = post.Lpupilx;
% intp.Lpupily = post.Lpupily;
% intp.Rrawx = post.Rrawx;
% intp.Rrawy = post.Rrawy;
% intp.Ravgx = post.Ravgx;
% intp.Ravgy = post.Ravgy;
% intp.Rpsize = post.Rpsize;
% intp.Rpupilx = post.Rpupilx;
% intp.Rpupily = post.Rpupily;
intp.event_cell = post.event_cell;
intp.event_num = post.event_num;
intp.event_ix = post.event_ix;

%% Interpolation of data
idx = (post.state~=8&post.state~=16); % idx for good signals
% vq  = interp1(post.time(idx),post.psize(idx),post.time(~idx));
% intp.psize = post.psize; intp.psize(~idx) = vq;
intp.intpRate = 1 - sum(idx)/length(idx);
vq  = interp1(post.time(idx),[post.rawx(idx) post.rawy(idx) intp.avgx(idx),...
    intp.avgy(idx),intp.psize(idx)],post.time(~idx));
intp.rawx(~idx) = vq(:,1);
intp.rawy(~idx) = vq(:,2);
intp.avgx(~idx) = vq(:,3);
intp.avgy(~idx) = vq(:,4);
intp.psize(~idx) = vq(:,5);

%%
header.fn = filename;

dat.intp = intp; 
dat.pre = pre; 
dat.post = post; 
dat.header = header; 

%% LOAD BEHAVIORAL DATA FILE
if loadBehav ==1 
    load(bfilename,'d','p');
    %% Separate regret trials 
    d.regretCond = [];
    for i=1:20
        c = d.response(i); nc = mod(c,2)+1;
        if d.payoff(1,i,c) > d.payoff(1,i,nc); % regret
            d.regretCond(i,1) = 1;
        else
            d.regretCond(i,1) = 2;  % no regret
        end
    end
%% Bin analyses to different trial types
    d.choice1 = {};
    d.choice2 = [];
    d.result1 = [];
    d.result2 = []; 
    trial = 1;
    for i = 1:length(intp.psize)
        cond = intp.event_num(i);
        switch cond
            case 1 % get choice segment
                x=i+1;
                while intp.event_num(x)==0 % probably zero
                    x=x+1;
                end
                d.choice1{i,1} = {intp.psize(i:x-1,1)'};
            case {2,3} % chose left / right
                d.choice2(trial,:) = intp.psize(i:i+59,1)'; % 2 second ISI
            case {4,5} % result left / right
                d.result1(trial,:) = intp.psize(i:i+119,1)'; % 4 second ISI
            case {6,7} % regret result left right
                d.result2(trial,:) = intp.psize(i:i+119,1)'; % 4 second ISI
                trial = trial +1;
        end
    end
%% Compare pupilsize timeseries 
    d.regretPsize = d.result2(d.regretCond==1,:);
    d.nonregretPsize = d.result2(d.regretCond==2,:);
%% Save to dat
    dat.d = d; 
    dat.p = p;
end
end