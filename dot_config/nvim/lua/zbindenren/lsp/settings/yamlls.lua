return {
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
			format = { enabled = false },
			validate = true, -- TODO: conflicts between Kubernetes resources and kustomization.yaml
			completion = true,
			hover = true,
		},
	},
}
