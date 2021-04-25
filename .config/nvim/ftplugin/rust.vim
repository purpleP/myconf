let g:rustfmt_command = 'rustup run nightly rustfmt'
fu! RustFormatWrapper()
    call rustfmt#FormatRange(v:lnum, v:lnum + v:count)
endfu
setl fex=RustFormatWrapper()
