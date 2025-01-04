-- local preview_cmd = "/bin/zathura"
-- local folder = ""

return {
  "CRAG666/code_runner.nvim",
  lazy = false,
  opts = {
    filetype = {
      python = "python3 -i"
    },
  },
  keys = {
    { "<leader>rr", "<cmd>RunCode<cr>",    desc = "[R]un Code" },
    { "<leader>rf", "<cmd>RunFile<cr>",    desc = "[R]un File" },
    -- { "<leader>rft", "<cmd>RunFile tab<cr>", desc = "Run File Tab" },
    { "<leader>rp", "<cmd>RunProject<cr>", desc = "[R]un Project" },
    { "<leader>rc", "<cmd>RunClose<cr>",   desc = "[R]un Close" },
    -- { "<leader>crf", "<cmd>CRFiletype<cr>", desc = "Open Json supported files" },
    -- { "<leader>crp", "<cmd>CRProject<cr>", desc = "Open Json list of projects" },
  },
}