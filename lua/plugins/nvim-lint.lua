-- Meu diagnóstico de Markdown não estava respeitando o arquivo de config em
-- $HOME/.markdownlint.yaml
-- Achei a solução em https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
--
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", "/home/lpanebr/.markdownlint.yaml", "--" },
      },
    },
  },
}
