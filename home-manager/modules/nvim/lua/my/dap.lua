local M = {}

local function parse_cargo_config()
	local cwd = vim.fn.getcwd()
	local path = cwd .. "/.cargo/config.toml"
	if vim.fn.filereadable(path) == 0 then
		path = cwd .. "/.cargo/config"
	end
	if vim.fn.filereadable(path) == 0 then
		return { chip = nil, target = nil }
	end
	local content = table.concat(vim.fn.readfile(path), "\n")
	local chip = content:match("%-%-chip%s+([%w_]+)")
	local target = content:match('target%s*=%s*"([^"]+)"')
	return { chip = chip, target = target }
end

local function find_elf(target)
	if not target then
		return ""
	end
	local dir = vim.fn.getcwd() .. "/target/" .. target .. "/debug"
	if vim.fn.isdirectory(dir) == 0 then
		return ""
	end
	for _, entry in ipairs(vim.fn.readdir(dir)) do
		local full = dir .. "/" .. entry
		if vim.fn.isdirectory(full) == 0 and not entry:find("%.") then
			return full
		end
	end
	return ""
end

function M.setup()
	local dap = require("dap")
	local dapui = require("dapui")

	dapui.setup({
		-- optional custom layout
		layouts = {
			{
				elements = {
					"scopes",
					"breakpoints",
					"stacks",
					"watches",
				},
				size = 40, -- width of the sidebar
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 10, -- height of the bottom panel
				position = "bottom",
			},
		},
	})
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	dap.adapters["probe-rs-debug"] = {
		type = "server",
		port = "${port}",
		executable = {
			command = "probe-rs",
			args = { "dap-server", "--port", "${port}" },
		},
	}
	local probe_rs_config = {
		name = "Launch with probe-rs",
		type = "probe-rs-debug",
		request = "launch",
		cwd = vim.fn.getcwd(),
		stopOnEntry = true,
		chip = function()
			local cargo = parse_cargo_config()
			return cargo.chip or vim.fn.input("Chip: ")
		end,
		coreConfigs = function()
			local cargo = parse_cargo_config()
			local default_elf = find_elf(cargo.target)
			local elf = vim.fn.input("Path to ELF: ", default_elf, "file")
			return {
				{
					core = 0,
					run = true,
					programBinary = elf,
					stopOnEntry = true,
					rttEnabled = true,
				},
			}
		end,
	}
	dap.configurations.rust = { probe_rs_config }
	dap.configurations.cpp = { probe_rs_config }

	dap.listeners.before["event_probe-rs-rtt-channel-config"]["dap-probe-rs"] = function(session, body)
		session:request("rttWindowOpened", { channelNumber = body.channelNumber, windowIsOpen = true })
	end

	dap.listeners.before["event_probe-rs-rtt-data"]["dap-probe-rs"] = function(_, body)
		require("dap.repl").append(body.data)
	end
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP continue" })
	vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP step over" })
	vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP step into" })
	vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP step out" })
	vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
	vim.keymap.set("n", "<Leader>B", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "DAP conditional breakpoint" })
	vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP open REPL" })
	vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP run last" })
	vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP UI toggle" })
end

return M
