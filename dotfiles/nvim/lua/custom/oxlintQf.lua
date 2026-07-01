vim.api.nvim_create_user_command("OxlintQF", function(opts)
	local dir = opts.args ~= "" and opts.args or vim.fn.getcwd()

	vim.system({ "pnpm", "vp", "lint", dir }, { text = true }, function(out)
		local lines = vim.split(out.stdout .. out.stderr, "\n")
		local qflist = {}

		for _, line in ipairs(lines) do
			local file, lnum, col, msg = line:match("^(.+):(%d+):(%d+): (.+)$")
			if file then
				table.insert(qflist, {
					filename = file,
					lnum = tonumber(lnum),
					col = tonumber(col),
					text = msg,
				})
			end
		end

		vim.schedule(function()
			vim.fn.setqflist(qflist, "r")
			vim.cmd("copen")
		end)
	end)
end, { nargs = "?" })
