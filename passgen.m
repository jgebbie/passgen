% Copyright (c) 2012, John Gebbie. All rights reserved.
%
% This library is free software; you can redistribute it and/or modify it
% under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation; either version 2.1 of the License, or (at
% your option) any later version.
%
% This library is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with this library; if not, write to the Free Software Foundation,
% Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA


% Create a password consisting of several random words
%
% Dictionary downloaded from: http://wordlist.sourceforge.net/
%
% Download the "Unofficial Alternate 12 Dicts Package" and extract
% '2of12full.txt into this directory, then run this script.  Some
% parameters are defined below in the "parameters" section.
%
% Author: John Gebbie
% Institution: self
% Creation Date: 10/10/2012

% init
clear;
clc;

% parameters
Nwords = 4;
min_word_len = 4;
max_word_len = 4;

% read in word data
fid = fopen('2of12full.txt','r');
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

