function [app] = loadStructure(filename, app)

handles = app.handles;

% Create the storys vector
handles.numStory = 7; %Story input user
num = handles.numStory:-1:1;
storys = cell(length(num), 1);

% Loop backwards through storys, create vector of story strings for
% structure indexing
for i = 1:length(num)
    storys{i, 1} = strcat('Story ', num2str(num(i)));
end

% Save to handles for later use, bakcwards
handles.storys = storys;

% Find save length of components for loops
handles.numComponents = length(handles.Components);

% Use ALPHABET for string concat, create for pulling data out of excel
% files
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

% Pulling out indices for displacement component costs
disp_start_index = strcat('B', num2str(2));
disp_end_index = strcat(ALPHABET(handles.numComponents+1), num2str(1+handles.numStory));
disp_index = strcat(disp_start_index, ':', disp_end_index);

% Pulling out indices for acceleration componenet cost
a_start_index = strcat('B', num2str(handles.numStory+4));
a_end_index = strcat(ALPHABET(handles.numComponents+1), num2str(3+2*handles.numStory));
a_index = strcat(a_start_index, ':', a_end_index);

% Pull out specific matrices from excel charts
buildingDataIDR = xlsread(filename, disp_index);
buildingDataAcc = xlsread(filename, a_index);

% Pull out specific replacement cost of a Part, demolishionCost, and
% collapse cost
handles.replacementCostPart = xlsread(filename, strcat('F', num2str(9 + 2*handles.numStory), ':F', num2str(9 + 2*handles.numStory)));
handles.demolishionCost = xlsread(filename, strcat('F', num2str(11 + 2*handles.numStory), ':F', num2str(11 + 2*handles.numStory)));
handles.collapseCost = xlsread(filename, strcat('F', num2str(13 + 2*handles.numStory), ':F', num2str(13 + 2*handles.numStory)));

% Load in structure data to corresponding handles array sections
for i = 1:handles.numStory
    if i > 1
        handles.(handles.storys{i}).Money = (buildingDataIDR(i-1, :) ...
                                        + buildingDataAcc(i, :))';
    else
        handles.(handles.storys{i}).Money = (buildingDataAcc(i, :))';
    end
        handles.(handles.storys{i}).NumComp = handles.(handles.storys{i}).Money/handles.replacementCostPart;
end

app.handles = handles;

end

