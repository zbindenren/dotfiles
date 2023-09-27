local status_ok, dap = pcall(require, "dap")
if not status_ok then
	vim.notify("dap plugin not found!")
	return
end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
	vim.notify("dapui plugin not found!")
	return
end

local dapgo_ok, dapgo = pcall(require, "dap-go")
if not dapgo_ok then
	vim.notify("dap-go plugin not found!")
	return
end

local dapvt_ok, dapvt = pcall(require, "nvim-dap-virtual-text")
if not dapvt_ok then
	vim.notify("dap-go plugin not found!")
	return
end

dapui.setup()
dapgo.setup()
dapvt.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
