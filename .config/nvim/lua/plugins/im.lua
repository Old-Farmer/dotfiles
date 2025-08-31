if not Global_config.im then
  return {}
end

return {
  -- Input method auto switching
  "Old-Farmer/im-autoswitch.nvim",
  -- dev = true,
  event = "BufEnter",
  opts = {
    cmd_os = {
      linux = {
        default_im = "keyboard-us",
        get_im_cmd = "fcitx5-remote -n",
        switch_im_cmd = "fcitx5-remote -s {}",
      },
      macos = {
        default_im = "com.apple.keylayout.ABC",
        get_im_cmd = "im-select",
        switch_im_cmd = "im-select {}",
      },
      windows = {
        default_im = "2052",
        get_im_cmd = "im-select",
        switch_im_cmd = "im-select {}",
      },
    },
    mode = {
      terminal = false,
    },
  },
}
