require("which-key").add({ "<leader>a", group = "ai", icon = { icon = "󰚩 ", color = "green", cat = "extension" } })

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		"ravitemer/codecompanion-history.nvim",
		{
			"HakonHarnes/img-clip.nvim",
			opts = {
				filetypes = {
					codecompanion = {
						prompt_for_file_name = false,
						template = "[Image]($FILE_PATH)",
						use_absolute_path = true,
					},
				},
			},
		},
	},
	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionChat",
		"CodeCompanionCmd",
		"CodeCompanionHistory",
	},
	opts = {

		adapters = {
			-- copilot
			gemini = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gemini-2.5-pro",
						},
					},
				})
			end,
			claude = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-sonnet-4",
						},
						max_tokens = {
							default = 65536,
						},
					},
				})
			end,
			o1 = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "o1",
						},
						max_tokens = {
							default = 65536,
						},
					},
				})
			end,
			-- OpenRouter
			openrouter_deepseek = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					name = "openrouter",
					env = {
						url = "https://openrouter.ai/api",
						api_key = "OPENROUTER_API_KEY",
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = {
							default = "deepseek/deepseek-r1:free",
						},
					},
				})
			end,
		},

		strategies = {
			chat = {
				adapter = "claude",
				keymaps = {
					send = {
						callback = function(chat)
							vim.cmd("stopinsert")
							chat:add_buf_message({ role = "llm", content = "" })
							chat:submit()
						end,
						index = 1,
						description = "Send",
					},
				},
			},
			inline = {
				adapter = "claude",
			},
			cmd = {
				adapter = "claude",
			},
		},

		opts = {
			-- Set debug logging
			log_level = "DEBUG",
		},

		extensions = {
			history = {
				enabled = true,
				opts = {
					-- Keymap to open history from chat buffer (default: gh)
					keymap = "gh",
					-- Automatically generate titles for new chats
					auto_generate_title = true,
					---On exiting and entering neovim, loads the last chat on opening chat
					continue_last_chat = false,
					---When chat is cleared with `gx` delete the chat from history
					delete_on_clearing_chat = false,
					-- Picker interface ("telescope" or "snacks" or "default")
					picker = "telescope",
					---Enable detailed logging for history extension
					enable_logging = false,
					---Directory path to save the chats
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
					-- Save all chats by default
					auto_save = true,
					-- Keymap to save the current chat manually
					save_chat_keymap = "sc",
				},
			},
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					show_result_in_chat = true, -- Show mcp tool results in chat
					make_vars = true, -- Convert resources to #variables
					make_slash_commands = true, -- Add prompts as /slash commands
				},
			},
		},
	},

	keys = {
		{
			mode = "n",
			"<leader>a:",
			function()
				local user_input = vim.fn.input("CodeCompanionCmd: ")
				vim.cmd("CodeCompanionCmd " .. user_input)
			end,
			desc = "CodeCompanionCmd",
		},
		{
			mode = { "n", "v" },
			"<leader>aa",
			"<CMD>CodeCompanionActions<CR>",
			silent = true,
			desc = "CodeCompanion actions",
		},
		{
			mode = { "n" },
			"<leader>ab",
			"<CMD>CodeCompanionChat @editor #buffer<CR>",
			silent = true,
			desc = "CodeCompanion add buffer to chat",
		},
		{
			mode = { "v" },
			"<leader>ab",
			"<CMD>CodeCompanionChat<CR><CR>@editor #buffer<CR>",
			silent = true,
			desc = "CodeCompanion add buffer to chat",
		},
		{
			mode = { "n", "v" },
			"<leader>ac",
			"<CMD>CodeCompanionChat Toggle<CR>",
			silent = true,
			desc = "CodeCompanion chat",
		},
		{
			mode = "v",
			"<leader>ay",
			"<CMD>CodeCompanionChat Add<CR>",
			silent = true,
			desc = "CodeCompanion add selection to chat",
		},
		{
			mode = "n",
			"<leader>ag",
			"<CMD>CodeCompanion /commit<CR>",
			silent = true,
			desc = "CodeCompanion generate commit",
		},
	},

	config = function(_, opts)
		local spinner = require("plugins.ai.utils.spinner")
		spinner:init()

		require("codecompanion").setup(opts)
		require("plugins.ai.utils.extmarks").setup()
	end,
}
