---@param name string The named export, e.g. "Option"
---@param alias? string Optional alias, e.g. "O"
---@param package? string The package to import from, defaults to "effect"
local function add_effect_import(name, alias, package)
	local pkg = package or "effect"
	local import_str = (alias and alias ~= "") and (name .. " as " .. alias) or name
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local pkg_line_idx = nil
	for i, line in ipairs(lines) do
		if line:match("from ['\"]" .. vim.pesc(pkg) .. "['\"]") then
			pkg_line_idx = i
			break
		end
	end

	if pkg_line_idx then
		local line = lines[pkg_line_idx]
		local before, imports, after = line:match("^(import%s*{)(.+)(}%s*from%s*['\"]" .. vim.pesc(pkg) .. "['\"].*)")

		if before and imports and after then
			if imports:match("%f[%w]" .. name .. "%f[%W]") then
				vim.notify("'" .. name .. "' already imported from '" .. pkg .. "'", vim.log.levels.WARN)
				return
			end
			local new_line = before .. imports .. ", " .. import_str .. after
			vim.api.nvim_buf_set_lines(0, pkg_line_idx - 1, pkg_line_idx, false, { new_line })
		else
			local new_import = "import { " .. import_str .. " } from '" .. pkg .. "'"
			vim.api.nvim_buf_set_lines(0, pkg_line_idx - 1, pkg_line_idx - 1, false, { new_import })
		end
	else
		local last_import_idx = 0
		for i, line in ipairs(lines) do
			if line:match("^import ") then
				last_import_idx = i
			end
		end
		local new_import = "import { " .. import_str .. " } from '" .. pkg .. "'"
		vim.api.nvim_buf_set_lines(0, last_import_idx, last_import_idx, false, { new_import })
	end

	vim.notify("Imported: " .. import_str .. " from '" .. pkg .. "'", vim.log.levels.INFO)
end

local effect_imports = {
	{ name = "Array", alias = "A", package = "effect" },
	{ name = "Option", alias = "O", package = "effect" },
	{ name = "String", alias = "Str", package = "effect" },
	{ name = "Schema", alias = "S", package = "effect" },
	{ name = "Effect", alias = nil, package = "effect" },
	{ name = "pipe", alias = nil, package = "effect" },
	{ name = "flow", alias = nil, package = "effect" },
	{ name = "Data", alias = nil, package = "effect" },
	{ name = "DateTime", alias = nil, package = "effect" },
	{ name = "Duration", alias = nil, package = "effect" },
	{ name = "HashMap", alias = nil, package = "effect" },
	{ name = "HttpApi", alias = nil, package = "effect/unstable/httpapi" },
	{ name = "HttpApiGroup", alias = nil, package = "effect/unstable/httpapi" },
	{ name = "HttpApiEndpoint", alias = nil, package = "effect/unstable/httpapi" },
}

local function pick_effect_import()
	local max_name_width = 0
	for _, item in ipairs(effect_imports) do
		if #item.name > max_name_width then
			max_name_width = #item.name
		end
	end

	local max_alias_width = 0
	for _, item in ipairs(effect_imports) do
		local w = item.alias and #item.alias or 0
		if w > max_alias_width then
			max_alias_width = w
		end
	end

	Snacks.picker.pick({
		title = "Effect Import",
		items = vim.tbl_map(function(item)
			local pkg = item.package or "effect"
			local import_str = item.alias and (item.name .. " as " .. item.alias) or item.name
			return {
				text = item.name .. (item.alias and (" as " .. item.alias) or "") .. " " .. pkg,
				name = item.name,
				alias = item.alias,
				package = pkg,
				preview = "import { " .. import_str .. " } from '" .. pkg .. "'",
			}
		end, effect_imports),
		format = function(item)
			local name_col = string.format("%-20s", item.name)
			local alias_col = string.format("%-10s", item.alias or "")
			return {
				{ name_col, "SnacksPickerLabel" },
				{ alias_col, "Comment" },
				{ item.package, "Number" },
			}
		end,
		preview = function(ctx)
			ctx.preview:reset()
			ctx.preview:set_lines({ "", "  " .. ctx.item.preview, "" })
			ctx.preview:highlight({ ft = "typescript" })
		end,
		confirm = function(picker, item)
			picker:close()
			add_effect_import(item.name, item.alias, item.package)
		end,
	})
end

vim.keymap.set("n", "<leader>li", pick_effect_import, { desc = "Effect: pick import" })
