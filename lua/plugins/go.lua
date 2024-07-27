return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
	},
	config = function()
		require("go").setup()

		-- Run gofmt + goimports on save
		local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
			group = format_sync_grp,
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()',
}
