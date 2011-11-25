" Plugins are managed by Vundle. Once VIM is open run :BundleInstall to
" install plugins.

" Plugins requiring no additional configuration or keymaps
Bundle "http://github.com/vim-scripts/Color-Sampler-Pack.git"
Bundle "http://github.com/oscarh/vimerl.git"
Bundle "http://github.com/tpope/vim-git.git"
Bundle "http://github.com/harleypig/vcscommand.vim.git"
Bundle "http://github.com/altercation/vim-colors-solarized.git"
Bundle "http://github.com/tpope/vim-cucumber.git"
Bundle "http://github.com/tpope/vim-endwise.git"
Bundle "http://github.com/tpope/vim-fugitive.git"
Bundle "http://github.com/tpope/vim-haml.git"
Bundle "http://github.com/pangloss/vim-javascript.git"
"Bundle "http://github.com/vim-scripts/L9.git"
Bundle "http://github.com/tpope/vim-rake.git"
Bundle "http://github.com/vim-ruby/vim-ruby.git"
Bundle "http://github.com/ervandew/supertab.git"
Bundle "http://github.com/tomtom/tcomment_vim.git"
Bundle "http://github.com/michaeljsmith/vim-indent-object.git"
Bundle "http://github.com/mhz/vim-matchit.git"
Bundle "http://github.com/kana/vim-textobj-user.git"
Bundle "http://github.com/nelstrom/vim-textobj-rubyblock.git"
Bundle "http://github.com/tpope/vim-repeat.git"
Bundle "http://github.com/vim-scripts/ruby-matchit.git"
" Bundle "http://github.com/wgibbs/vim-irblack.git"

"Additional Plugins
Bundle 'http://github.com/bartekd/vim-dart.git'
Bundle 'http://github.com/mmalecki/vim-node.js.git'
Bundle 'http://github.com/mattn/sonictemplate-vim.git'
Bundle 'https://github.com/klen/pylint-mode.git'
Bundle 'https://github.com/talek/obvious-resize.git'
Bundle 'http://github.com/xolox/vim-lua-ftplugin.git'
Bundle 'https://github.com/t9md/vim-chef.git'
"Bundle 'http://github.com/MarcWeber/vim-addon-ocaml.git'
Bundle 'https://github.com/mileszs/apidock.vim.git'



" Navigation
Bundle 'http://github.com/mutewinter/bufpos.git'
"Bundle 'http://github.com/vim-scripts/FuzzyFinder.git'
"Bundle 'http://github.com/vim-scripts/ZoomWin.git'
"Bundle 'http://github.com/wincent/Command-T.git'
Bundle 'http://github.com/spiiph/vim-space.git'
Bundle 'http://github.com/Lokaltog/vim-easymotion.git'
"Bundle 'http://github.com/mutewinter/LustyJuggler.git'
" UI Additions
Bundle 'http://github.com/mutewinter/vim-indent-guides.git'
Bundle 'http://github.com/dickeytk/status.vim.git'
Bundle 'http://github.com/scrooloose/nerdtree.git'
"Bundle 'http://github.com/mutewinter/ir_black_mod.git'
Bundle 'http://github.com/godlygeek/csapprox.git'
Bundle 'http://github.com/Rykka/ColorV.git'
" OS Integration
Bundle 'http://github.com/mkitt/browser-refresh.vim.git'
" Commands
Bundle 'http://github.com/scrooloose/nerdcommenter.git'
Bundle 'http://github.com/tpope/vim-surround.git'
Bundle 'http://github.com/tpope/vim-speeddating.git'
Bundle 'http://github.com/tpope/vim-fugitive.git'
Bundle 'http://github.com/godlygeek/tabular.git'
Bundle 'http://github.com/mileszs/ack.vim.git'
" Automatic Helpers
Bundle 'http://github.com/vim-scripts/IndexedSearch.git'
Bundle 'http://github.com/xolox/vim-session.git'
Bundle 'http://github.com/Raimondi/delimitMate.git'
Bundle 'http://github.com/scrooloose/syntastic.git'
Bundle 'http://github.com/ervandew/supertab.git'
Bundle 'http://github.com/vim-scripts/AutoComplPop.git'
" Language Additions
Bundle 'http://github.com/vim-ruby/vim-ruby.git'
Bundle 'http://github.com/msanders/cocoa.vim.git'
Bundle 'http://github.com/tpope/vim-haml.git'
Bundle 'http://github.com/pangloss/vim-javascript.git'
Bundle 'http://github.com/kchmck/vim-coffee-script.git'
Bundle 'http://github.com/itspriddle/vim-jquery.git'
Bundle 'http://github.com/tpope/vim-rails.git'
Bundle 'http://github.com/mutewinter/taskpaper.vim.git'
Bundle 'http://github.com/leshill/vim-json.git'
" Libraries
"Bundle 'http://github.com/vim-scripts/L9.git'
Bundle 'http://github.com/tpope/vim-repeat.git'

" Coffee script
  Bundle "http://github.com/kchmck/vim-coffee-script.git"
    au BufNewFile,BufRead *.coffee set filetype=coffee


" ACK
  Bundle "http://github.com/mileszs/ack.vim.git"
    nmap g/ :Ack!<space>
    nmap g* :Ack! -w <C-R><C-W><space>
    nmap ga :AckAdd!<space>
    nmap gn :cnext<CR>
    nmap gp :cprev<CR>
    nmap gq :ccl<CR>
    nmap gl :cwindow<CR>


" Tagbar for navigation by tags using CTags
  Bundle "http://github.com/majutsushi/tagbar.git"
    let g:tagbar_autofocus = 1
    map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
    map <Leader>. :TagbarToggle<CR>


" Ruby focused unit test (wrapped in an if-loaded because it doesn't like
" being loaded twice)
"  if !exists(':RunRubyFocusedUnitTest')
"    Bundle "http://github.com/drewolson/ruby_focused_unit_test_vim.git"
"      nmap <Leader>ra :wa<CR> :RunAllRubyTests<CR>
"      nmap <Leader>rc :wa<CR> :RunRubyFocusedContext<CR>
"      nmap <Leader>rf :wa<CR> :RunRubyFocusedUnitTest<CR>
"      nmap <Leader>rl :wa<CR> :RunLastRubyTest<CR>
"  endif


" Markdown syntax highlighting
  Bundle "http://github.com/tpope/vim-markdown.git"
    augroup mkd
      autocmd BufNewFile,BufRead *.mkd      set ai formatoptions=tcroqn2 comments=n:> filetype=markdown
      autocmd BufNewFile,BufRead *.md       set ai formatoptions=tcroqn2 comments=n:> filetype=markdown
      autocmd BufNewFile,BufRead *.markdown set ai formatoptions=tcroqn2 comments=n:> filetype=markdown
    augroup END


" Markdown preview to quickly preview markdown files
  Bundle "http://github.com/maba/vim-markdown-preview.git"
  map <buffer> <Leader>mp :Mm<CR>


" NERDTree for project drawer
  Bundle "git://github.com/scrooloose/nerdtree.git"
    let NERDTreeHijackNetrw = 0

    nmap gt :NERDTreeToggle<CR>
    nmap g :NERDTree \| NERDTreeToggle \| NERDTreeFind<CR>




" Tabular for aligning text
  Bundle "http://github.com/godlygeek/tabular.git"
    function! CustomTabularPatterns()
      if exists('g:tabular_loaded')
        AddTabularPattern! symbols         / :/l0
        AddTabularPattern! hash            /^[^>]*\zs=>/
        AddTabularPattern! chunks          / \S\+/l0
        AddTabularPattern! assignment      / = /l0
        AddTabularPattern! comma           /^[^,]*,/l1
        AddTabularPattern! colon           /:\zs /l0
        AddTabularPattern! options_hashes  /:\w\+ =>/
      endif
    endfunction

    autocmd VimEnter * call CustomTabularPatterns()

    " shortcut to align text with Tabular
    map <Leader>a :Tabularize<space>


" Fuzzy finder for quickling opening files / buffers
"  Bundle "http://github.com/clones/vim-fuzzyfinder.git"
"    let g:fuf_coveragefile_prompt = '>GoToFile[]>'
"    let g:fuf_coveragefile_exclude = '\v\~$|' .
"    \                                '\.(o|exe|dll|bak|swp|log|sqlite3|png|gif|jpg)$|' .
"    \                                '(^|[/\\])\.(hg|git|bzr|bundle)($|[/\\])|' .
"    \                                '(^|[/\\])(log|tmp|vendor|system|doc|coverage|build|generated)($|[/\\])'
"
"    let g:fuf_keyOpenTabpage = '<D-CR>'
"
"    nmap <Leader>t :FufCoverageFile<CR>
"    nmap <Leader>b :FufBuffer<CR>
"    nmap <Leader>f :FufRenewCache<CR>
"    nmap <Leader>T :FufTagWithCursorWord!<CR>


" ZoomWin to fullscreen a particular buffer without losing others
"  Bundle "http://github.com/vim-scripts/ZoomWin.git"
"    map <Leader>z :ZoomWin<CR>


" Unimpaired for keymaps for quicky manipulating lines and files
  Bundle "http://github.com/tpope/vim-unimpaired.git"
    " Bubble single lines
    nmap <C-Up> [e
    nmap <C-Down> ]e

    " Bubble multiple lines
    vmap <C-Up> [egv
    vmap <C-Down> ]egv


" Syntastic for catching syntax errors on save
  Bundle "http://github.com/scrooloose/syntastic.git"
    let g:syntastic_enable_signs=1
    let g:syntastic_quiet_warnings=1
    let g:syntastic_disabled_filetypes = ['sass']


" gist-vim for quickly creating gists
  Bundle "http://github.com/mattn/gist-vim.git"
    if has("mac")
      let g:gist_clip_command = 'pbcopy'
    elseif has("unix")
      let g:gist_clip_command = 'xclip -selection clipboard'
    endif

    let g:gist_detect_filetype = 1
    let g:gist_open_browser_after_post = 1


" gundo for awesome undo tree visualization
  Bundle "http://github.com/sjl/gundo.vim.git"
    map <Leader>h :GundoToggle<CR>


" rails.vim, nuff' said
  Bundle "http://github.com/tpope/vim-rails.git"
    map <Leader>oc :Rcontroller<Space>
    map <Leader>ov :Rview<Space>
    map <Leader>om :Rmodel<Space>
    map <Leader>oh :Rhelper<Space>
    map <Leader>oj :Rjavascript<Space>
    map <Leader>os :Rstylesheet<Space>
    map <Leader>oi :Rintegration<Space>


" surround for adding surround 'physics'
  Bundle "http://github.com/tpope/vim-surround.git"
    " # to surround with ruby string interpolation
    let g:surround_35 = "#{\r}"
    " - to surround with no-output erb tag
    let g:surround_45 = "<% \r %>"
    " = to surround with output erb tag
    let g:surround_61 = "<%= \r %>"

" Clojure Highlighting"
  Bundle "https://github.com/vim-scripts/VimClojure.git"
  autocmd BufNewFile,BufRead *.clj set filetype=clojure


" Jade Highlighting"
  Bundle "http://github.com/digitaltoad/vim-jade.git"
  autocmd BufNewFile,BufRead *.jade set filetype=jade
