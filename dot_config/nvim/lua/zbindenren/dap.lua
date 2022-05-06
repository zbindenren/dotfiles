local status_ok, dap = pcall(require, "dap")
if not status_ok then
	vim.notify("dap plugin not found!")
	return
end

local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
	vim.notify("dapui plugin not found!")
	return
end

local status_ok, dapgo = pcall(require, "dap-go")
if not status_ok then
	vim.notify("dap-go plugin not found!")
	return
end

local status_ok, dapvt = pcall(require, "nvim-dap-virtual-text")
if not status_ok then
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
