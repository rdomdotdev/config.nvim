return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		local conf = require("telescope.config").values

		-- Telescope Config
		local function toggle_telescope(harpoon_files)
			local get_file_paths = function()
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end
				return file_paths
			end

			local make_finder = function()
				return require("telescope.finders").new_table({
					results = get_file_paths(),
				})
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = make_finder(),
					attach_mappings = function(prompt_buffer_number, map)
						map("n", "d", function()
							local list = harpoon_files
							local remove
							remove = function(item)
								item = item or list.config.create_list_item(list.config)
								local Extensions = require("harpoon.extensions")
								local Logger = require("harpoon.logger")

								local items = list.items
								if item ~= nil then
									for i = 1, list._length do
										local v = items[i]
										print(vim.inspect(v))
										if list.config.equals(v, item) then
											table.remove(items, i)
											list._length = list._length - 1

											Logger:log("HarpoonList:remove", { item = item, index = i })

											Extensions.extensions:emit(
												Extensions.event_names.REMOVE,
												{ list = list, item = item, idx = i }
											)
											break
										end
									end
								end
							end
							local state = require("telescope.actions.state")
							local selected_entry = state.get_selected_entry()
							local current_picker = state.get_current_picker(prompt_buffer_number)

							remove(selected_entry)

							current_picker:refresh(make_finder())
						end)
						return true
					end,
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		--- Harpoon Config
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)

		vim.keymap.set("n", "<leader>h", function()
			toggle_telescope(harpoon:list())
		end)

		vim.keymap.set("n", "<leader>j", function()
			harpoon:list():select(1)
		end)

		vim.keymap.set("n", "<leader>k", function()
			harpoon:list():select(2)
		end)

		vim.keymap.set("n", "<leader>l", function()
			harpoon:list():select(3)
		end)

		vim.keymap.set("n", "<leader>;", function()
			harpoon:list():select(4)
		end)
	end,
}
