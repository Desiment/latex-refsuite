ensure_path( 'TEXINPUTS', './deps//:' );
ensure_path( 'LUAINPUTS', './deps//:' );
$pdf_mode=4;
$lualatex = 'lualatex  %O -halt-on-error -synctex=1 --shell-escape %S';
$out_dir = '.';
$aux_dir = 'build';

