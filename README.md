# # plum-articler.nvim

Plum-Articler is a nvim extension that helps you to write articles in markdown format, upload them to our blog platform and publish them.
It is available a version for [VSCode](https://github.com/plum-juice-project/plum-articler)

## Features
Create a new article and upload it to the blog platform
Create a new markdown file and write your article. Then, use the `:PlumUploadArticle` command to upload the article to the blog platform. The article will be uploaded to the blog platform and you will receive a link to the article.

### Edit an existing articlea
__TODO__ 

If you want to edit an existing article, you can use the `:PlumEditArticle`. This command will download the article from the blog platform and open it in vscode. After editing the article, you can upload it again using the plum-articler: Save article command.

### Preview an article
__TODO__

After writing an article, you can preview it using the `:PlumPreview` command. This is useful to see how the article will look like when published, the preview render use the same markdown style as the blog platform. TODO: currently the preview doesn't support vue components.

### Article resources manager
__TODO__


## Installation

### Requirements
- gh (GitHub CLI) installed and configured, will be used to authenticate with github and upload the article to the blog platform.


### Using vim-plug
```vim
Plug 'plum-juice-project/plum-articler.nvim'
```

### Using Lazy.vim
```lua
    {
        'plum-juice-project/plum-articler.nvim',
        opts = {},
    }
```

## Shortcuts

| Command | Shortcut |
| --- | --- |
| PlumUploadArticle | <Leader>u |
| PlumEditArticle | ... |
| PlumPreview | ... |

## Development

If you want to contribute to the extension, you can clone the repository and set your Lazy.nvim configuration to use the local version of the extension.

```lua
    {
        dir = '~/path/to/plum-articler.nvim',
        opts = {},
    }
```

