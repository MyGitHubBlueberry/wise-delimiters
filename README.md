# Wise delimiters
## Description
I find it really annoying and unfair that neovim treats quotes and braces like single characters. This plugin changes this completely.
Wise delimiters plugin makes sure that you use your delimeters with full comfort. Here is what it provides:
- Closing of your quotes and braces now automated
- Exiting of delimiters using Tab in insert mode
- Deleting both matching delimiters with one backspace press (if you place you cursor right between them)
- Customization of your delimiters: add and remove whatever delimiters you like
- Comfortable nvim command functions, so you can make changes quickly

This idea is not new, you might be familiar with such concept from other code editrors (we don't talk about them).
If you didn't get it or you just want to see how it works, watch the demo below:
<details>
  <summary>Demonstration</summary>
  
https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/f3afc37f-d458-414e-a55a-54754ab743d2


https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/5a5f674d-ba97-49bf-807d-dc89534b0de6

</details>

## Installation
Don't forget to reopen your nvim :)
### Packer
```lua
use 'MyGitHubBlueberry/wise-delimiters'
```
### Lazy
``` lua
{
    'MyGitHubBlueberry/wise-delimiters'
}
```
### Plug
``` lua
Plug  'MyGitHubBlueberry/wise-delimiters'
```
## Setup
``` lua
require("wise-delimiters").setup()
```
## Use
After you called setup function, everything is already done for you, but if you want to customize which delimiters you are using, or remind yourself which you already have, you can use following nvim commands in nvim's command mode:

### List 
This commands reminds you which delimiters you are using. Just execute following line and you will see them under your lua line.
``` lua
:DelimitersList
```
If you didn't change anything yet, after this command execution you will see this:
```
Here are your delimiters: {-}  "-"  '-'  <->  [-]  (-)
```
Delimiters showing up one by one, connected to ther pairs by hyphens.
<details>
  <summary>Demonstration</summary>

https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/893641ec-7c2a-428a-b433-3fdb61221e1c

</details>

### Add
This command accepts two arguments: <i><b> opening </i></b> and <i><b>closing</i></b> delimeters. It allows you to add any delimiter pare, you desire. Exept of those, you already have.
``` lua
:DelimitersAdd <opening_delimiter> <closing_delimiter>
```
For some reason you want to add <i><b>a</i></b> and <i><b>b</i></b> as your delimiters. You can do this by executing following:
``` lua
:DelimitersAdd a b
```
Now <i><b> a </i></b> and <i><b>b</i></b> added to your delimiter list as <i><b>opening</i></b> and <i><b>closing</i></b> delimiters respectively.

<details>
  <summary>Demonstration</summary>


https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/dc27864c-69da-4b57-a789-5029603952be

</details>

### Remove
This function accepts one argument - <i><b>opening delimiter</i></b>. It removes delimiter pare tided-up to it.

``` lua
:DelimitersRemove <opening_delimiter>
```

Lest assume you added those <i><b>a</i></b> and <i><b>b</i></b> from previous example section. We can remove them now with following command:
``` lua
:DelimitersRemove a
```

<details>
  <summary>Demonstration</summary>


https://github.com/MyGitHubBlueberry/wise-delimiters/assets/105305430/57759d15-7459-41ed-8730-b8d7f509d934


</details>
