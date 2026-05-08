%% http://stackoverflow.com/questions/4747834/matlab-import-csv-file-with-mixed-data-types
function lineArray = read_mixed_csv(fileName,delimiter,nhead)

% file name is mandatory
if (~exist('fileName','var') || ~ischar(fileName))
  error('Not enough input arguments.'); 
end

% default delimiter
if (~exist('delimiter','var') || ~ischar(delimiter))
  delimiter='\t';
end

% jump header lines
if (~exist('nhead','var') || ~isnumeric(nhead(1)) || nhead(1)<0 )
  nhead=0;
end

fid = fopen(fileName,'r');
lineArray = cell(1024,1);    % Preallocate a cell array (ideally slightly larger than is needed)
lineIndex = 1;               % Index of cell to place the next line in

for j=1:nhead+1
  nextLine = fgetl(fid);              % Read the next line from the file
%  if ~ length(nextLine)
%    tmp = fgetl(fid);                 % Read ^M from dos end of file
%  end
end

% Loop while not at the end of the file
while ~isequal(nextLine,-1)           
  lineArray{lineIndex,1} = nextLine;  % Add the line to the cell array
  lineIndex = lineIndex+1;            % Increment the line index
  nextLine = fgetl(fid);              % Read the next line from the file
%  if length(nextLine)
%    tmp = fgetl(fid);                 % Read ^M from dos end of file
%  end
end
fclose(fid);

% Remove empty cells
lineArray = lineArray(1:lineIndex-1);  

% Process each line
for iLine = 1:lineIndex-1    
  % Manchester, 2015-oct-26
  % added check for empty lines
  if isempty(lineArray{iLine})
    lineData={''};
  else
    % cptec 29-aug-2018
    % remove duplicate spaces, IF space is the separator
    % for other separators, duplicates actually mean an empty column
    %lineData = textscan(regexprep(lineArray{iLine},' +',' '),'%s',...  % Read strings

    lineData = textscan(lineArray{iLine},'%s',...  % Read strings
                        'Delimiter',delimiter);

    lineData = lineData{1};                     % Remove cell encapsulation
    if strcmp(lineArray{iLine}(end),delimiter)  % Account for when the line
      lineData{end+1} = '';                     %   ends with a delimiter
    end
  end
 
  lineArray(iLine,1:numel(lineData)) = lineData;  % Overwrite line data
end
%