local M = {}

local gh = require('plum-articler.github')

function M.upload_article()
	local filepath = vim.fn.expand('%:p')

	if not vim.fn.filereadable(filepath) then
		print("File not found: " .. filepath)
		return
	end

	if vim.fn.fnamemodify(filepath, ":e") ~= "md" then
		print("Only markdown files are supported")
		return
	end

	print("Uploading article: " .. filepath)
	gh.push_article(filepath)

	print("Article uploaded")
end

local linter = require('plum-articler.linter')
function M.lint_markdown()
	local filepath = vim.fn.expand('%')
    linter.lint_markdown(filepath)
end

function M.toggle_linter()
	linter.toggle_linter()
end
return M

