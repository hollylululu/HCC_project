from lxml import html
import requests
import urllib.request
from bs4 import BeautifulSoup
# url = "http://www.hcibib.org/CHI16-1#S6"
# with urllib.request.urlopen(url) as url:
#     s = url.read()

# soup = BeautifulSoup(s, 'html.parser')
# name_box = soup.find('table')
# print (name_box)

# page = requests.get('http://www.hcibib.org/CHI16-1#S6')
# tree = html.fromstring(page.content)
# print (tree)

in_file = './data/chi2014.txt'
out_file = './data/chi2014_out.txt'
# with open(in_file, 'r') as fin:
#     for line in fin:
dict = {}
def next_section(file):
    res = ''
    for line in iter(file.readline, '\n'):
        if line == '\n':  # means the file has no more lines
            continue
        if '%' not in line:
            res += line
        yield line
title = ''
session = ''
author = ''
link = ''
abstract = ''
# with open(in_file,'r') as f:
#     print("Here's the first section:")
#     for line in next_section(f):
#         if "%T" in line:
#             title = line.split("%T")[1]
#         if "%S" in line:
#             session = line.split("%S")[1]
#         if "%A" in line:
#             author = line.split("%A")[1]
#         if "%W" in line:
#             link = line.split("%W")[1]
#         if "%X" in line:
#             abstract = line.split("X")[1]
#         print (title, session)
with open(in_file, 'r') as f:
    lines = f.readlines()
    print (len(lines))
dict = {}
c = 0
i = 0
while i in range(len(lines)):
    j = i
    para = []
    line = lines[i].strip('\n')
    if c not in dict:
        dict[c] = {'title': '', 'session': '', 'author_list': [], 'link': ''}
    if lines[i] != '\n':
        if "%T" in line:
            title = line.split("%T")[1]
            dict[c]['title'] = title
        if "%S" in line:
            session = line.split("%S")[1]
            dict[c]['session'] = session
        if "%A" in line:
            author = line.split("%A")[1]
            dict[c]['author_list'].append(author)
        if "%W" in line:
            link = line.split("%W")[1]
            dict[c]['link'] = link
    else:
        c += 1
    i += 1

print (len(dict))
print (dict[0])

with open(out_file, 'w') as fout:
    for key in dict:
        title = dict[key]['title']
        author_list = dict[key]['author_list']
        link = dict[key]['link']
        session = dict[key]['session']
        for i in range(len(author_list)):
            fout.write('\t'.join([str(key), title, link, session, author_list[i]]))
            fout.write('\n')

author_tp = []

with open('graph.txt', 'w') as fout:
    fout.write('source' + '\t' + 'target' + '\t' + 'value' + '\n')
    for key in dict:
        author_list = dict[key]['author_list']
        for i in range(len(author_list)):
            for j in range(i+1, len(author_list)):
                a1 = author_list[i]
                a2 = author_list[j]
                author_tp.append((author_list[i], author_list[j]))
                fout.write(a1 + '\t' + a2 + '\t' +'1' +'\n')



