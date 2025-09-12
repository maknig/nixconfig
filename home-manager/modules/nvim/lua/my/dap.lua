local M = {}

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
			command = vim.fn.expand("probe-rs"), -- make sure probe-rs is installed
			args = { "dap-server", "--port", "${port}" },
		},
	}
	dap.configurations.cpp = {
		{
			name = "Launch with probe-rs",
			type = "probe-rs-debug",
			request = "launch",	
			cwd = "${workspaceFolder}",
			stopOnEntry = true,
            chip = "stm32l431cc",
		    coreConfigs = function()
      -- we must provide program-binary for the core
      local elf = vim.fn.input(
        "Path to ELF for core 0: ",
        vim.fn.getcwd() .. "/build2/re-leva.elf",
        "file"
      )
      return {
        {
          core = 0,              -- target core index
          run = true,            -- start running after reset
          programBinary = elf,   -- <-- THIS IS REQUIRED
		stopOnEntry = true,
        }
      }
    end,	
		},
	}
	-- Handle RTT events (optional, but useful)
	dap.listeners.before["event_probe-rs-rtt-channel-config"]["dap-probe-rs"] = function(session, body)
		vim.notify(string.format("probe-rs RTT channel %d (“%s”) opened", body.channelNumber, body.channelName))
		-- must send this request back to receive RTT data
		session:request("rttWindowOpened", { body.channelNumber, true })
	end

	dap.listeners.before["event_probe-rs-rtt-data"]["dap-probe-rs"] = function(_, body)
		local msg = string.format("RTT ch %d: %s", body.channelNumber, body.data)
		require("dap.repl").append(msg)
	end

	dap.listeners.before["event_probe-rs-show-message"]["dap-probe-rs"] = function(_, body)
		local msg = "probe-rs: " .. body.message
		require("dap.repl").append(msg)
	end
	vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end)
vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end)
vim.keymap.set("n", "<Leader>du", function() dapui.toggle() end)
end

return M
