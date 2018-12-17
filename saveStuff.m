function saveStuff(app)

[file,path] = uiputfile('*.mat');
filename = fullfile(path, file);

miscData = app.handles;
handles = app.handles;

results.AAL = handles.AAL;
results.hazardDerivative = handles.hazardDerivative;
results.hazardCurve = handles.hazardCurve;
results.deaggregationLossRatios = handles.ratio;
plots.hazardCurve = app.UIAxes2;
plots.collapseCurve = app.UIAxes;
plots.eventProbability = app.UIAxes6;
plots.lossEstimation = app.UIAxes4;

results.medCollapse = handles.CollapseMedian;
results.stdCollapse = handles.CollapseStd;
results.MAF_Collapse = handles.MAF_c;

save(filename, 'plots', 'results', 'miscData')
end


