function [handles] = LoadStructureData(handles,filename)

floorandstorydata = readtable(filename);

%Not sure what to do with formatting, columns stacked on top of each other
stories = table2array(floorandstorydata(:,'STORY'));
