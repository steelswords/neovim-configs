# steelswords's NeoVim config

 This is my NeoVim config. Like most who chronically tweak their setup, it's a
 work in progress.

 This is usually pulled in and installed by my Confounditall system in my
 [configs repo](https://github.com/steelswords/configs/tree/confounditall).

# FAQs & Helpful Tips

## mason-lspconfig always fails on a `:PlugUpdate`.

Yeah, it does that because it overwrites the `stable` tag every time. Git
(rightfully, IMO) balks because that would overwrite data.

To fix it, cd to
`~/.local/share/nvim/plugged/mason-lspconfig.nvim` and run
```
git fetch --tags --force
git config fetch.pruneTags true
```

That will update the tag for this time and make it so you don't have to worry
about it next time.
