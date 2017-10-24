# vim-clean
[Clean][] plugin for Vim

### Maintainers

- [Camil Staps][camilstaps]
- [Mart Lubbers][dopefishh]

### Contributors

- [mklinik][mklinik]
- [norm2782][norm2782-vim-clean]
- [timjs][timjs-syntax]

---

### Features

* Syntax highlighting for Clean and ABC code
* Folding rules for Clean
* Switching between definition and implementation module
* Automatic imports based on tagfiles (see below)
* Jumping to definition and implementation based on tagfiles (see below)
* Compiler errorformats
* [Cloogle][] integration (note that this requires [curl][])
* Access to the plugin manual via `:h clean`. Make sure to run `:helptags` at
  least once to update the helpfiles.

### Tip: tagfiles

Use [clean-cloogle/cloogle-tags][tags] to build a tagsfile (`:h tags`) on
`/opt/clean/lib`, and add `setlocal tags+=/opt/clean/lib/tags` to your
`.vim/after/ftplugin/clean.vim`. Then you can use `Ctrl-]` to jump to a
definition (for instance).

[camilstaps]: https://camilstaps.nl
[Clean]: http://clean.cs.ru.nl
[Cloogle]: http://cloogle.org
[norm2782-vim-clean]: https://github.com/norm2782/vim-clean
[timjs-syntax]: https://github.com/timjs/vim-clean/tree/timjs-syntax
[dopefishh]: https://github.com/dopefishh
[mklinik]: https://github.com/mklinik
[curl]: https://curl.haxx.se/
[tags]: https://github.com/clean-cloogle/cloogle-tags
