# ABC &rightarrow; LaTeX &rightarrow; PDF

This is a simple tool to convert ABC (formatted music) to PDF (music sheet). First, it embeds them into a LaTeX file as vector images, then compiles the LaTeX files to PDF. 

It also creates produces inpput file for the [abclisten](https://github.com/furkanturan/abclisten) subrepository, which turns the ABC files into online sheet music and make them playable.

## How to use?

* Type your music sheet using abc notation, and add it to the main directory with `.abc` extension.

* Provide extra info in a file having the same name as the `.abc` file, but with an `.info` extention. For now, only several info fields are supported. 
    
  * A title to the PDF.
  * The date it is added. You can leave it empty.
  * A scaling factor for the sheet in the PDF file.
  * If the `.abc` file does not set the tempo, you can provide the tempo information here. This will not be printed to the TEX file, but will be used if the file is compiled for the listener.

  You can create the info file as:

  ```
  title=Name of the song
  date=1 January 2020
  scale=0.80
  tempo=1/4=120
  ```

* In the next step you can execute the `./compile` script. You should execute it with an argument explained below:

  * `$ ./compile.sh songname` for compiling a single file
  * `$ ./compile.sh -all` for compiling all files
  * `$ ./compile.sh -abclisten` for compiling all files to listener

## Dependencies

It uses:
* `abcm2ps` for converting `abc` sheet into `svg` images
* `inkscape` to convert `svg` images to `pdf`
* `python3` to prepare `tex` files that include the `pdf` sheet input
* `pdflatex` to compile the `tex` files into `pdf` sheet