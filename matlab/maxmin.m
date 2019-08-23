function [Max,Min] = maxmin(Data)
%MAXMIN finds max- and min-value in the matrix Data 
%       regardless of Not-a-Numbers.
%

Data = Data(find(~isnan(Data)));
Max  = max(Data);
Min  = min(Data);

