function app = expectedLoss_IM(app)

handles = app.handles;

% Dat for loop though, loop through all componenets, stories, and Sa values
for j = 1:handles.numComponents
    for i = 1:handles.numStory
        for k = 1:length(handles.hazardDerivative(1,:))
            index = strcat(handles.(handles.Components{j}).EDPtype, num2str(handles.numStory - i + 1));
            % If component has EDP type on a certain floor
            if ismember(index, fieldnames(handles.EDPtype)) == 1
                % Pull out values
                EDP = handles.(handles.Components{j}).EDP;
                PDF = handles.EDPtype.(index).pdf_edp_im(:, k)';
                EL_EDP = handles.(handles.Components{j}).EL_EDP_Story(i, :);
                % Do correponding integration here, convert to IM
                handles.(handles.storys{i}).Loss_IM_comp(j, k) = trapz(EDP, PDF.*EL_EDP);
            else
                % If floor has no components of a certain EDP category,
                % just fill in with loss of 0
                handles.(handles.storys{i}).Loss_IM_comp(j, k) = 0;
            end
        end
    end

end

% Add losses for all components for a given story together
Loss_IM_Story = zeros(handles.numStory, length(handles.hazardCurve(1, :)));
for i = 1:handles.numStory
    Loss_IM_Story(handles.numStory - i + 1, :) = sum(handles.(handles.storys{i}).Loss_IM_comp);
end

% #IM by #Story matrix of losses at each IM for a given story. All stories
% will be summed together later
handles.Loss_IM_Story = Loss_IM_Story;
app.handles = handles;
end