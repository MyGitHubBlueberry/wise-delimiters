# Wise delimiters
## Description
This is nvim plugin that makes sure that you use your delimeters with full comfort. 
When you type opening delimeter this plugin types pair for it as well and puts your cursor between the delimeters. Then you can delete them both if you press backspace or exit from them by pressing tab in insert mode. In other cases tab and backspace work noramlly.
This idea is not new, you might be familiar with such concept from other code editrors (we don't talk about them).
If you didn't get the idea of if you just want to see how it works, watch the demo below:
<details>
  <summary>Demonstration</summary>
  
https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/f3afc37f-d458-414e-a55a-54754ab743d2


https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/5a5f674d-ba97-49bf-807d-dc89534b0de6

</details>

## Installation
### Packer
```lua
use {
    'MyGitHubBlueberry/wise-delimiters',
    config = function()
        require("wise-delimiters").setup()
    end
}
```
### Lazy
``` lua
require("lazy").setup('MyGitHubBlueberry/wise-delimiters', {
    require("wise-delimiters").setup()
})
```
### Plug
``` lua
Plug 'MyGitHubBlueberry/wise-delimiters'

-- Configure the plugin using the setup function:
vim.cmd([[
    let g:plug_wise_delimiters_config = {
        \ 'on_startup': 1,
        \ 'on_demand': 1,
        \ 'config': function()
            \ call wise_delimiters#setup()
        \ endfunction
    \ }
]])
```
