import sys
import glob, os
import json
from string import Template

################################################################################
# Check the input files

abcfiles = []
os.chdir("./")
for file in glob.glob("*.abc"):
  abcfiles.append(file[:-4])

################################################################################
# Create two arrays for the songs.js

sheetTitles = []
sheetTempos = []
sheetABCs   = []

for file in abcfiles:
  with open(file+".json") as f:
    settings = json.load(f)
    sheetTitles.append(settings['title'])
    sheetTempos.append(settings['tempo'])

for file in abcfiles:
  f = open(file+".abc", "r")
  sheetABCs.append(f.readlines())
  f.close

################################################################################
# Create the content of the songs.js

# Prepare the string for the sheetTitles
names = "var sheetTitles = [\n"
for name in sheetTitles:
  names += "  \"" + name + "\",\n"
names = names[:-2] + "\n];"

# Append tempo from info, if it is not present
for sheetIndex, sheet in enumerate(sheetABCs, start=0):
  # Check if it is already present in the abc file
  if not [line for line in sheet if "Q:" in line]:
    # Append if after L:
    for lineIndex, line in enumerate(sheet, start=0):
      if line[0:2] == "L:":
        sheet.insert(lineIndex+1, "Q:"+sheetTempos[sheetIndex]+"\n")
        break

# Prepare the string for the sheetABCs
songs = "var sheetABCs = [\n"
for sheet in sheetABCs:
  for line in sheet:
    songs += "  \"" + line[:-1] + "\\n\" +" + "\n"
  songs = songs[:-6] + "\",\n\n"
songs = songs[:-3] + "\n];"

# Concatenate the strings of sheetTitles and sheetABCs
content = names + "\n\n" + songs

################################################################################
# Write the result to songs.js

f = open("songs.js", "w")
f.write(content)
f.close()
