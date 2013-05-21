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

% filter out words that do not meet certain criteria
shortlist = {};
for n = 1:length(all)
    word = all{n};
    
    % skip words that are not the right length
    if length(word) < min_word_len
        continue;
    end
    if length(word) > max_word_len
        continue;
    end
    
    % skip any words that have punctuation
    if any(~isletter(word))
        continue;
    end
    
    % make lowercase
    word = lower(word);
    
    % append to the shortlist of words
    shortlist{end+1} = word; %#ok
end

% build password
password = '';
n = 1;
while n <= Nwords
    word = shortlist{randi(length(shortlist))};
    
    if n > 1;
        password = [ password ' ' ]; %#ok
    end
    
    % append
    password = [ password word ]; %#ok
    
    % increment
    n = n+1;
end

% compute bits of entropy
entropy_bits = log(length(shortlist))/log(2)*Nwords;

% print it out
fprintf('%s (entropy = %.1f bits)\n', password, entropy_bits);

% take out the spaces
password(password == ' ') = [];
fprintf('%s (no space)\n', password);

% add uppercase, punctuation, and number
password(1) = upper(password(1));           % capitalize first char
rand_num = int2str(randi(10)-1);
punct_chars = '!@#$%^&*;,./';
rand_punct = punct_chars(randi(length(punct_chars)));
password = [password, rand_num, rand_punct];

% compute bits of entropy
entropy_bits = entropy_bits + ...
    log(10)/log(2) + log(length(punct_chars))/log(2);

% print out modified password
fprintf('%s (entropy = %.1f bits)\n', password, entropy_bits);

