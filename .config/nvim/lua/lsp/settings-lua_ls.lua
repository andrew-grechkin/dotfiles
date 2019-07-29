return {
    settings = {
        Lua = {
            workspace = {checkThirdParty = false},
            telemetry = {enable = false},
            hint = {enable = true},
        },
    },
    set_prepare = function(_, _) end,
    set_on_attach = function(_, _) end,
}
