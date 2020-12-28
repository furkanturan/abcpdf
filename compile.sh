#!/bin/bash

operation=0
getAllFiles=0

# Copy target files into the work dir
if [ -z ${1} ]; then 
  echo "Use with an argument"
  echo "  $ ./compile.sh songname   for compiling a single file"
  echo "  $ ./compile.sh -all       for compiling all files"
  echo "  $ ./compile.sh -listener  for compiling all files to abclisten"
  exit 1
  
elif [ "$1" == "-abclisten" ]; then
  echo "Compiling all files to abclisten"
  operation=1
  getAllFiles=1

elif [ "$1" == "-all" ]; then
  echo "Compiling all files to tex"
  operation=2
  getAllFiles=1

else
  echo "Compiling $1"
  getAllFiles=0
  operation=2
fi

################################################################################ 

# Create /tmp as the work dir
mkdir -p tmp
  
if [ $getAllFiles == 1 ]; then
  for abc_file in *.abc; do
    filename=$(basename -- "$abc_file")
    file="${filename%.*}"
    echo "-> "${file}
    rm -f ${file}.pdf
    cp ${file}.* tmp/.    
  done

else
  rm -f ${1}.pdf
  cp ${1}.* tmp/.
fi

################################################################################

if [ $operation == 1 ]; then
  # copy the script
  cp abc2pdf/songs2listen.py tmp/.

  # cd into workdir
  cd tmp/

  # execute the convertion script
  python3 songs2listen.py

  # get the output file
  mv songs.js ../abclisten/js/.
  
elif [ $operation == 2 ]; then
  # Create /tmp as the work dir
  mkdir -p tmp
  cp abc2pdf/template.tex tmp/.
  cp abc2pdf/songs2tex.py tmp/.
  cp abc2pdf/abc2pdf.sh   tmp/.

  # cd into workdir
  cd tmp/

  # execute the convertion script
  ./abc2pdf.sh

  # get the pdfs
  for abc_file in *.abc; do
    filename=$(basename -- "$abc_file")
    file="${filename%.*}"
    mv ${file}.pdf ../. 
  done

fi

# delete the work dir
cd ..
rm -rf tmp