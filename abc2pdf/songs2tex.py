import sys
import glob, os
import json
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

with open(abcfile+".json") as f:
  settings = json.load(f)

################################################################################

tmpfile = open("template.tex", "r")
tmplate = Template(tmpfile.read())
tmpfile.close()

res = tmplate.substitute(
  name  = settings['title'], 
  date  = settings['date'], 
  scale = settings['scale'], 
  link  = "music.furkanturan.com/listen.html?sheet="+
          settings['title'].replace(" ", "\_"),
  files = ','.join(svgfiles))

f = open(abcfile+".tex", "w")
f.write(res)
f.close()

################################################################################