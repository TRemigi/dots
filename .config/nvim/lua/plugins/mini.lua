return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup({
			{ -- No need to copy this inside `setup()`. Will be used automatically.
				-- Table with textobject id as fields, textobject specification as values.
				-- Also use this to disable builtin textobjects. See |MiniAi.config|.
				custom_textobjects = {},

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Main textobject prefixes
					around = "a",
					inside = "i",

					-- Next/last variants
					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",

					-- Move cursor to corresponding edge of `a` textobject
					goto_left = "g[",
					goto_right = "g]",
				},

				-- Number of lines within which textobject is searched
				n_lines = 50,

				-- How to search for object (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
				search_method = "cover_or_next",

				-- Whether to disable showing non-error feedback
				-- This also affects (purely informational) helper messages shown after
				-- idle time if user input is required.
				silent = false,
			},
		})
		require("mini.comment").setup()
		require("mini.diff").setup()
		require("mini.icons").setup()
		require("mini.move").setup()
		require("mini.pairs").setup()
		require("mini.splitjoin").setup()
		require("mini.surround").setup()
		require("mini.extra").setup()
		require("mini.operators").setup(
			-- No need to copy this inside `setup()`. Will be used automatically.
			{
				-- Each entry configures one operator.
				-- `prefix` defines keys mapped during `setup()`: in Normal mode
				-- to operate on textobject and line, in Visual - on selection.
				-- Evaluate text and replace with output
				evaluate = {
					prefix = "g=",
					-- Function which does the evaluation
					func = nil,
				},
				-- Exchange text regions
				exchange = {
					prefix = "gx",
					-- Whether to reindent new text to match previous indent
					reindent_linewise = true,
				},
				-- Multiply (duplicate) text
				multiply = {
					prefix = "gm",
					-- Function which can modify text before multiplying
					func = nil,
				},
				-- Replace text with register
				replace = {
					prefix = "gr",
					-- Whether to reindent new text to match previous indent
					reindent_linewise = true,
				},
				-- Sort text
				sort = {
					prefix = "gs",
					-- Function which does the sort
					func = nil,
				},
			}
		)
	end,
}
