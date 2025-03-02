// @ts-check

import globals from 'globals';
import eslintJs from '@eslint/js';
import eslintTs from 'typescript-eslint'; // https://typescript-eslint.io/getting-started

import eslintConfigPrettier from 'eslint-config-prettier';
import eslintPluginPrettier from 'eslint-plugin-prettier/recommended';

/** @type {import("typescript-eslint").ConfigArray} */
export default eslintTs.config(
    {
        files: ['**/*.{js,mjs,cjs,ts}'],
        ignores: ['dist/*'],
        languageOptions: {globals: globals.browser},
    },
    eslintJs.configs.recommended,
    eslintTs.configs.strict,
    eslintTs.configs.stylistic,
    eslintConfigPrettier,
    eslintPluginPrettier,
    {
        ignores: ['dist/*'],
    },
);
