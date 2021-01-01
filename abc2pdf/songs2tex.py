import sys
import glob, os
from string import Template

abcfile = sys.argv[1]
print('ABC File:', abcfile)

################################################################################

svgfiles = []
os.chdir("./")
for file in glob.glob("*.svg"):
    if file.find(abcfile)!=-1:
        svgfiles.append(file[:-4]+".pdf") # for pdf
svgfiles = sorted(svgfiles)
print(','.join(svgfiles))

################################################################################

info_fields = [ ["title", ""],
                ["date",  ""],
                ["scale", ""]]

infofile = open(abcfile+".info", "r")
for line in infofile.readlines():
  for field in info_fields:
    if line.find(field[0])!=-1:
      field[1] = line[len(field[0])+1:].strip()
infofile.close()

################################################################################

tmpfile = open("template.tex", "r")
tmplate = Template(tmpfile.read())
tmpfile.close()

res = tmplate.substitute(
  name  = info_fields[0][1], 
  date  = info_fields[1][1],
  scale = info_fields[2][1],
  link  = "furkanturan.com/listen/index.html?sheet="+
          info_fields[0][1].replace(" ", "\_"),
  files = ','.join(svgfiles))

f = open(abcfile+".tex", "w")
f.write(res)
f.close()

################################################################################
