$recorder = 1;
$pdf_mode = 1;
$bibtex_use = 2;
$pdflatex = "pdflatex -interaction=nonstopmode -file-line-error-style --shell-escape -synctex=1 %O %S";
$pdf_previewer = "start open -a preview %O %S";
sub asy {return system("asy \"$_[0]\"");}
add_cus_dep("asy","eps",0,"asy");
add_cus_dep("asy","pdf",0,"asy");
add_cus_dep("asy","tex",0,"asy");
