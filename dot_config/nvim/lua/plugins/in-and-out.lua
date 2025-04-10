return {
  "ysmb-wtsg/in-and-out.nvim",
  keys = {
    {
      "<C-cr>",
      function()
        require("in-and-out").in_and_out()
      end,
      mode = { "i" },
      desc = "In and Out",
    },
  },
}
