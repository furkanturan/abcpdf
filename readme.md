# ABC &rightarrow; LaTeX &rightarrow; PDF

This repo provides a set of scripts to convert ABC (formatted music) to PDF (music sheet). First, it embeds ABC sheet into a LaTeX file as vector image(s), then compiles the LaTeX files to PDF. 

It also produces input file for the [abclisten](https://github.com/furkanturan/abclisten) subrepository, which turns the ABC files into an online sheet music and make them playable.

## How to use?

* Type a music sheet using ABC notation, and add it to the main directory with `.abc` extension.

* Provide extra json in a file having the same name as the `.abc` file. For now, the following information fields are supported.
    
  * **title:** A title to the PDF.
  * **date:** The date it is added. For me, this is the date, on which I started practicing the specific song.
  * **scale:** A scaling factor for the sheet in the PDF file.
  * **size:** A size, like font size for the size of the note in the PDF file.
  * **tempo:** If the `.abc` file does not set the tempo, this field can provide the tempo information. This will not be printed to the TEX file, but will be used if the file is compiled for the [abclisten](https://github.com/furkanturan/abclisten).
  * **share:** A boolean field to dictate if the file will be shared or not. For example, it might be a copyrighted song. If sharing is disabled, the file will be exempted from [abclisten](https://github.com/furkanturan/abclisten), and it will be added to `.gitignore` to disable committing it.

  An example `.json` file is as follows:

  ```
  {
    "title" : "Name of the song",
    "date"  : "1 January 2020",
    "scale" : 0.82,
    "size"  : 0.75,
    "tempo" : "1/4=120",
    "share" : true
  }
  ```

* In the next step you can execute the `./compile` script. You should execute it with an argument explained below:

  * `$ ./compile.sh songname` for compiling a single file
  * `$ ./compile.sh -all` for compiling all files
  * `$ ./compile.sh -abclisten` for compiling all files to listener

## Dependencies

It uses:
* `abcm2ps` to convert `abc` sheet into `svg` images
* `inkscape` to convert `svg` images to `pdf`
* `python3` to prepare `tex` files that include the `pdf` sheet input
* `pdflatex` to compile the `tex` files into `pdf` sheet
* `jq` to parse `.json` files