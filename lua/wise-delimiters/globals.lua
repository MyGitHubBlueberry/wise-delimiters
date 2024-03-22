local M = require("wise-delimiters.init")

function DelimitersList()
    M.delimiters_list()
end

function DelimitersAdd(opening_delimiter, closing_delimiter)
    M.delimiters_add(opening_delimiter, closing_delimiter)
end

function DelimitersRemove(opening_delimiter)
    M.delimiters_remove(opening_delimiter)
end
