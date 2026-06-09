-- https://github.com/meanderingprogrammer/render-markdown.nvim
--
-- checklist bug - https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/545
-- rendering markdown task lists, the first 3 letters are missing and the hierarchy/indentation is rendered incorrectly, and it was later closed as not planned :: solutiuon apply right_pad
return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    preset = 'obsidian',
    checkbox = {
      right_pad = 5,
    },
    bullet = {
      right_pad = 1,
    },
    code = {
      sign = true,
      language_icon = true,
    },
  },
}
