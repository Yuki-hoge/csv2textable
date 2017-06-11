#!/bin/bash

# 使い方の表示(引数足りない時など)
CMDNAME=$(basename $0)
if [ $# -ne 1 ] ; then
  echo "Usage: ./${CMDNAME} csvfile"
  exit 1
fi

CSVF=$1
OUT=${1%.*}

# csvをtexソースに整形して.texを出力，処理，生成されたpdfをopen
ruby csv2textable.rb ${CSVF} > ${OUT}.tex
ptex2pdf -l -ot "-synctex=1 -file-line-error" ${OUT}.tex
open ${OUT}.pdf

# 後始末
rm -f ${OUT}.aux ${OUT}.synctex.gz ${OUT}.log
rm -f ${OUT}.tex