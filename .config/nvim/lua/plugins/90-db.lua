local mysql = {
    Columns = [[DESCRIBE `{table}`]],
    Count = [[SELECT
    COUNT(*)
FROM
    `{table}`
]],
    Indexes = [[SHOW INDEXES
FROM
    `{table}`
]],
    List = [[SELECT
    *
FROM
    `{table}`
LIMIT
    200
]],
    ['Primary Keys'] = [[SELECT
    *
FROM
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE
    TABLE_SCHEMA = '{dbname}'
    AND TABLE_NAME = '{table}'
    AND CONSTRAINT_TYPE = 'PRIMARY KEY'
]],
    ['Foreign Keys'] = [[SELECT
    *
FROM
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE
    TABLE_SCHEMA = '{dbname}'
    AND TABLE_NAME = '{table}'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY'
]],
    ['Table create'] = [[SHOW CREATE
TABLE
    `{table}`
\G]],
    ['Table show'] = [[SHOW TABLE STATUS
LIKE
    '{table}'
]],
}

local postgresql = {
    Columns = [[SELECT
    *
FROM
    information_schema.columns
WHERE
    table_name = '{table}'
    AND table_schema = '{dbname}'
]],
    Count = [[SELECT
    COUNT(*)
FROM
    {table}
]],
    Indexes = [[SELECT
    *
FROM
    pg_indexes
WHERE
    tablename = '{table}'
    AND schemaname = '{dbname}'
]],
    List = [[SELECT
    *
FROM
    {table}
LIMIT
    200
]],
    ['Primary Keys'] = [[SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name     AS foreign_table_name,
    ccu.column_name    AS foreign_column_name,
    rc.update_rule,
    rc.delete_rule
FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.referential_constraints AS rc ON tc.constraint_name = rc.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
WHERE
    constraint_type = 'PRIMARY KEY'
    AND tc.table_name = '{table}'
    AND tc.table_schema = '{dbname}'
]],
    References = [[SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name     AS foreign_table_name,
    ccu.column_name    AS foreign_column_name,
    rc.update_rule,
    rc.delete_rule
FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.referential_constraints AS rc ON tc.constraint_name = rc.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
WHERE
    constraint_type = 'FOREIGN KEY'
    AND ccu.table_name = '{table}'
    AND tc.table_schema = '{dbname}'
]],
    ['Foreign Keys'] = [[SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name     AS foreign_table_name,
    ccu.column_name    AS foreign_column_name,
    rc.update_rule,
    rc.delete_rule
FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.referential_constraints AS rc ON tc.constraint_name = rc.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
WHERE
    constraint_type = 'FOREIGN KEY'
    AND tc.table_name = '{table}'
    AND tc.table_schema = '{dbname}'
]],
}

return {
    { -- https://github.com/kristijanhusak/vim-dadbod-ui
        'andrew-grechkin/vim-dadbod-ui',
        dependencies = {
            { -- https://github.com/tpope/vim-dadbod
                'tpope/vim-dadbod',
                -- cmd = {'DB'},
                -- lazy = true,
            },
        },
        cmd = {'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer'},
        init = function()
            vim.g.db_ui_auto_execute_table_helpers = true
            vim.g.db_ui_force_echo_notifications = true
            vim.g.db_ui_hide_schemas = {'pg_toast'}
            vim.g.db_ui_show_database_icon = true
            vim.g.db_ui_table_helpers = {postgresql = postgresql, mysql = mysql, mysqltsv = mysql}
            vim.g.db_ui_use_nerd_fonts = true
            vim.g.db_ui_use_nvim_notify = true
            vim.g.db_ui_win_position = 'right'
        end,
        keys = {{'<leader><leader>d', ':DBUIToggle<CR>', desc = 'db ui: toggle'}},
    },
    { -- https://github.com/lifepillar/pgsql.vim
        'lifepillar/pgsql.vim',
    },
}
