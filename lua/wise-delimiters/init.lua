local wr = require("wise-delimiters.filewr")
--remup again on update

local M = {}

local i = "i"
local savefile = "delimiters.txt"

local delimiters = {
	['"'] = '"',
	["'"] = "'",
	["{"] = "}",
	["["] = "]",
	["("] = ")",
	["<"] = ">",
}

local closing_delimiters = ""
local opening_delimiters = ""

local function update_delimiters_lookup()
	closing_delimiters = ""
	opening_delimiters = ""
	for opening, closing in pairs(delimiters) do
		closing_delimiters = closing_delimiters .. closing
		opening_delimiters = opening_delimiters .. opening
	end
end

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

local function remap_Tab()
	map(i, "<Tab>", function()
		local line = vim.fn.getline(".")
		local col = vim.fn.col(".")
		local next_char = line:sub(col, col)

		if next_char == "" then
			return "<Tab>"
		end

		for _, value in pairs(delimiters) do
			if value == next_char then
				return "<right>"
			end
		end

		return "<Tab>"
	end, { expr = true })
end

local function remap_backspace()
	map(i, "<BS>", function()
		local line = vim.fn.getline(".")
		local col = vim.fn.col(".")
		local next_char = line:sub(col, col)
		local prev_char = line:sub(col - 1, col - 1)

		if delimiters[prev_char] == next_char then
			return "<right><BS><BS>"
		else
			return "<BS>"
		end
	end, { expr = true })
end

local function remap_delimiters()
	for opening, closing in pairs(delimiters) do
		map(i, opening, opening .. closing .. "<left>")

		if opening == "{" then
			map(i, "{<CR>", "{<CR>}<ESC>O")
		end
	end
end

local function remap_all()
	remap_delimiters()
	remap_backspace()
	remap_Tab()
end

local function add_commands()
	vim.api.nvim_create_user_command("DelimitersList", DelimitersList, { desc = "Lists your delimiters" })
	vim.api.nvim_create_user_command(
		"DelimitersRemove",
		"lua DelimitersRemove(<f-args>)",
		{ desc = "Removes delimiter pair (pass opening delimiter into function)", nargs = 1 }
	)
	vim.api.nvim_create_user_command(
		"DelimitersAdd",
		"lua DelimitersAdd(<f-args>)",
		{ desc = "Adds delimiter pair (pass opening and closing delimiters into function)", nargs = "+" }
	)
end

local function is_char(possible_char)
	return type(possible_char) == "string" and #possible_char == 1
end

M.delimiters_list = function()
	local all_delimiters = ""
	for opening, closing in pairs(delimiters) do
		all_delimiters = all_delimiters .. opening .. "-" .. closing .. "   "
	end
	print("Here are your delimiters: " .. all_delimiters)
end

M.delimiters_add = function(opening, closing)
	if is_char(opening) and is_char(closing) then
		if delimiters[opening] ~= nil then
			print("Delimiters table already contains " .. opening .. " value. No need to add another one.")
			return
		end
		delimiters[opening] = closing
		local added_pair = { [opening] = closing }
		wr.append(added_pair)
		update_delimiters_lookup()
		remap_all()
		print("Delimiters pair   " .. opening .. "-" .. closing .. "   added succesfully.")
		return
	else
		print("Only characters allowed to be delimeters. Pass one character at a time.")
		return
	end
end

M.delimiters_remove = function(opening)
	if not is_char(opening) then
		print("Only characters allowed to be delimeters. Pass one character at a time.")
		return
	end
	if delimiters[opening] ~= nil then
		delimiters[opening] = nil
		wr.rewrite(delimiters)
		update_delimiters_lookup()
		remap_all()
		print("Delimiter pair removed succesfully.")
		return
	end

	print("There is no " .. opening .. " in delimiters table.")
end

function M.setup()
	wr.set_relative_file_path("/" .. savefile)
	wr.init(delimiters)
	local file_delimiters = wr.read()
	delimiters = {}
	for key, value in pairs(file_delimiters) do
		delimiters[key] = value
	end
	update_delimiters_lookup()
	remap_Tab()
	remap_backspace()
	remap_delimiters()
	add_commands()
end

function DelimitersList()
	M.delimiters_list()
end

function DelimitersAdd(opening_delimiter, closing_delimiter)
	M.delimiters_add(opening_delimiter, closing_delimiter)
end

function DelimitersRemove(opening_delimiter)
	M.delimiters_remove(opening_delimiter)
end

return M
