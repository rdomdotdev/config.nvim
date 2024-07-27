vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_user_command("Config", function()
	local config_path = vim.fn.stdpath("config")
	vim.cmd("Ex " .. config_path)
end, {})
