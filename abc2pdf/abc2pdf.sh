echo "ABC -> SVG"
for abc_file in *.abc; do
  filename=$(basename -- "$abc_file")
  file="${filename%.*}"

  abcm2ps -v ${file}.abc -O tmp_${file}
done

echo "SVG -> PDFTEX"
for svg_file in *.svg; do
  filename=$(basename -- "$svg_file")
  file="${filename%.*}"

  inkscape -D ${file}.svg  -o ${file}.pdf
done

echo "PDFTEX -> TEX"
for abc_file in *.abc; do
  filename=$(basename -- "$abc_file")
  file="${filename%.*}"
  
  python3 songs2tex.py ${file}
  latexmk -f -pdf \
    -pdflatex="pdflatex -synctex=1 -interaction=batchmode %O %S" \
    -use-make ${file}.tex
done