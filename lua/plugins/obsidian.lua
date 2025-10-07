if true then
  -- INFO: Por que eu desabilitei?
  -- Quebrava bullets e checklists nos arquivos do vault.
  return {}
else
  return {
    -- "epwalsh/obsidian.nvim",
    -- https://github.com/epwalsh/obsidian.nvim
    -- NOTE: O fork abaixo resolve compatibilidade com o blink.cmp
    -- https://github.com/epwalsh/obsidian.nvim/issues/770#issuecomment-2698836480
    "obsidian-nvim/obsidian.nvim",
    enabled = true,
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    keys = {
      { "<leader>foq", ":ObsidianQuickSwitch<CR>", desc = "Obsidian Quick Switch" },
    },
    event = { "BufReadPre /home/lpanebr/Obsidian/brain/**.md" },
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- Optional, for completion.
      -- "hrsh7th/nvim-cmp",

      -- Optional, for search and quick-switch functionality.
      "nvim-telescope/telescope.nvim",

      -- Optional, an alternative to telescope for search and quick-switch functionality.
      -- "ibhagwan/fzf-lua"

      -- Optional, another alternative to telescope for search and quick-switch functionality.
      -- "junegunn/fzf",
      -- "junegunn/fzf.vim"

      -- Optional, alternative to nvim-treesitter for syntax highlighting.
      -- "godlygeek/tabular",
      -- "preservim/vim-markdown",
    },
    opts = {
      -- A list of workspace names, paths, and configuration overrides.
      -- If you use the Obsidian app, the 'path' of a workspace should generally be
      -- your vault root (where the `.obsidian` folder is located).
      -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
      -- the workspace to the first workspace in the list whose `path` is a parent of the
      -- current markdown file being edited.
      workspaces = {
        {
          name = "personal",
          path = "/home/lpanebr/Obsidian/brain",
          overrides = {
            -- Optional, for templates (see below).
            templates = {
              subdir = "Templates",
              date_format = "%Y-%m-%d-%a",
              time_format = "%H:%M",
            },
          },
        },
        {
          name = "politicas editoriais",
          path = "/home/lpanebr/Insync-headless/luciano@editoracubo.com.br/Google Drive - Shared drives/EC Consultoria/_ Políticas Editoriais para revistas Editora Cubo/politicas-editoriais-revistas/",
          -- Optional, override certain settings.
        },
      },

      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "",

      -- Optional, if you keep daily notes in a separate directory.
      daily_notes = {
        folder = "daily-notes",
      },

      -- Optional, completion.
      completion = {
        -- Enables completion using nvim_cmp
        nvim_cmp = false,
        -- Enables completion using blink.cmp
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context: follow link, show notes with tag, or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      -- Optional, customize how names/IDs for new notes are created.
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will given an ID that looks
        -- like '20230521080730-my-new-note', and therefore the file name '20230521080730-my-new-note.md'
        -- Alterei para usar o timestamp que é legível.
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        -- return tostring(os.time()) .. "-" .. suffix
        return tostring(os.date("!%Y%m%d%H%M%S")) .. "-" .. suffix
      end,

      -- Optional, set to true if you don't want Obsidian to manage frontmatter.
      disable_frontmatter = true,

      -- Optional, alternatively you can customize the frontmatter data.
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = false,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = false,

      -- Optional, by default commands like `:ObsidianSearch` will attempt to use
      -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
      -- first one they find. By setting this option to your preferred
      -- finder you can attempt it first. Note that if the specified finder
      -- is not installed, or if it the command does not support it, the
      -- remaining finders will be attempted in the original order.
      finder = "telescope.nvim",
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- HACK: fix error, disable completion.nvim_cmp option, manually register sources
      -- local cmp = require("cmp")
      -- cmp.register_source("obsidian", require("cmp_obsidian").new())
      -- cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
      -- cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())

      -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
      -- see also: 'follow_url_func' config option above.
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })
    end,
    ui = { enable = false },
  }
end
