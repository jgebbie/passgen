% Create a password consisting of several random words
%
% Dictionary downloaded from: http://wordlist.sourceforge.net/
%
% Download and extract the "Unofficial Alternate 12 Dicts Package" into
% this directory, then run this script.
%
% Author: John Gebbie
% Institution: self
% Creation Date: 10/10/2012

% init
clear;
clc;

% parameters
Nwords = 6;
min_word_len = 4;
max_word_len = 4;

% read in word data
fid = fopen('2of12.txt','r');
assert(fid ~= -1);
try
    all = textscan(fid,'%s');
    all = all{1};
catch e
    fclose(fid); fid = -1; %#ok
    rethrow(e);
end
fclose(fid); fid = -1;

% filter words
shortlist = {};
for n = 1:length(all)
    if min_word_len <= length(all{n}) && length(all{n}) <= max_word_len;
        shortlist{end+1} = all{n}; %#ok
    end
end

% build password
password = '';
for n = 1:Nwords
    if n > 1;
        password = [ password ' ' ]; %#ok
    end
    password = [ password shortlist{randi(length(shortlist))} ]; %#ok
end

% compute bits of entropy
entropy_bits = log(length(shortlist))/log(2)*Nwords;

% print it out
fprintf('%s (entropy = %.1f bits)\n', password, entropy_bits);

