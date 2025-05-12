return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true,
    message_template = "<date> • <author> • <summary>",
    date_format = "%d-%m-%Y %H:%M",
    virtual_text_column = 1
  }
}

