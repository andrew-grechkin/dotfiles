return { -- https://github.com/redhat-developer/yaml-language-server
    -- filetypes = {'yaml', 'yml'},
    -- root_dir = GET_PROJECT_DIR,
    settings = {
        ['yaml'] = {
            completion = true,
            hover = true,
            -- schemaStore = {enable = false, url = ''},
            schemas = {
                ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
                ['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
                ['https://json.schemastore.org/prettierrc.json'] = '.prettierrc.yaml',
            },
            validate = true,
        },
    },
    set_prepare = function(_, _) end,
    set_on_attach = function(_, _) end,
}
