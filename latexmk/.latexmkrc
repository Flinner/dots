# It is hard to grep logs with line breaks!
$ENV{max_print_line} = $log_wrap = 1000;

$out_dir = '/tmp/tex';

$pdf_mode = 1;
$pdflatex =    'pdflatex --shell-escape -interaction=nonstopmode -synctex=1 %O %S;';
$pdflualatex = 'lualatex --shell-escape -interaction=nonstopmode -synctex=1 %O %S;';

# https://stackoverflow.com/questions/71868294/set-zathura-as-a-default-viewer-while-using-latexmk
$pdf_previewer = 'zathura';

