#!/bin/bash

operation=0
getAllFiles=0

# Copy target files into the work dir
if [ -z ${1} ]; then 
  echo "Use with an argument"
  echo "  $ ./compile.sh songname   for compiling a single file"
  echo "  $ ./compile.sh -all       for compiling all files"
  echo "  $ ./compile.sh -abclisten for compiling all files to abclisten"
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
fileError=0

if [ $getAllFiles == 1 ]; then  
  for abc_file in *.abc; do
    filename=$(basename -- "$abc_file")
    file="${filename%.*}"

    if [  -f "${file}.json" ]; then

      # if sharing of this file is not wished, add the file to .gitignore
      share=$(jq .share ${file}.json)
      if [ $share == false ]; then  
        echo "${file}.*" >> .gitignore
      fi

      # if this script is executed for abclisten, 
      # get only the files for which sharing is enables
      if [ $operation == 1 ]; then
        if [ $share == true ]; then
          cp ${file}.* tmp/.
          echo "-> "${file}
        fi
      # if this cript is executed for PDFs
      # get all the files, and delete any existing PDFs of them.
      elif [ $operation == 2 ]; then
        rm -f ${file}.pdf
        cp ${file}.* tmp/.
        echo "-> "${file}
      fi

    else
      echo "File Error: ${file}.json for ${file}.abc does not exist!"
      fileError=1
    fi
  done

else
  if [ -f "${1}.abc" ]; then
    if [ -f "${1}.json" ]; then
      rm -f ${1}.pdf
      cp ${1}.* tmp/.
    else
      echo "File Error: ${1}.json for ${1}.abc does not exist!"
      fileError=1
    fi
  else
    echo "File Error: ${1}.abc does not exist!"
    fileError=1
  fi
fi

if [ $fileError == 1 ]; then
  rm -rf tmp
  exit 1
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