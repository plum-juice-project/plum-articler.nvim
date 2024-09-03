local M = {}

function M.setup(opts)
   opts = opts or {}

	local commands = require('plum-articler.commands')

    -- commands 
	vim.api.nvim_create_user_command('UploadArticle', commands.upload_article, {})
    vim.api.nvim_create_user_command('LintMarkdown', commands.lint_markdown, {})

	vim.keymap.set("n", "<Leader>u", ":UploadArticle<CR>", {})
	vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged"}, {
		pattern = "*.md",
		callback = commands.lint_markdown,
	})

	vim.api.nvim_create_user_command("ToogleLinter", commands.toggle_linter, {})
end
return M
