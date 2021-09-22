# Vim Timings

Assorted codes for checking completion speed.

![coc.nvim vs nvim-cmp](https://user-images.githubusercontent.com/1269815/134443783-becb0081-8df0-4ef1-b29b-58fbb5deb6ca.png)

- `:so timings.vim`
- `<leader>T` to start recording delays between `InsertCharPre` and `CompleteChanged`
- type some code
- `<leader>T` to stop recording delays
- `:TimingsSave examples/cmp-timings.json nvim-cmp` to export timings with a given title
- `$julia -i -- timings.jl examples/coc-timings.json examples/cmp-timings.json` to plot timing series
- call `timings()` from Julia REPL to refresh plots for updated data

<a href="https://github.com/oblitum/vim-timings/blob/master/LICENSE.md">
    <img src="https://www.gnu.org/graphics/gplv3-127x51.png" alt="GPLv3">
</a>

