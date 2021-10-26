# !wget -qO- http://www.jsoftware.com/download/j902/install/j902_linux64.tar.gz | tar xzf -

install_ijs = '''
9!:29]1
9!:27 '2!:55]1'

load 'pacman'
'install' jpkg 'viewmat'
viewmat i.2 3
exit 0
'''

with open('install.ijs', 'w') as f:
    print(install_ijs, file=f)

! j902/bin/jconsole install.ijs
# import subprocess as sub
# sub.run('j902/bin/jconsole install.ijs')
