data=: {{)n
size    jcpu       afcuda     afcpu
1000   0.056262   0.100719   0.047372
2000   0.427451   0.771741   0.106946
4000   3.39665    5.84454    0.436433
6000  10.9967    18.9904     1.14112
8000  25.978     44.8076     2.80025
11000 69.1119   115.662      4.85914
}}

'name data'=: 1 split cut;._2 data
'x data'=: 1 split |:".&>data

pd 'reset'
pd 'key ',' 'joinstring }.,names
pd 'ylog 1'
pd 'ycaption seconds'
pd 'xcaption square matrix side length'
pd 'xlabel ',":,x
pd 'ylog 1'
pd data
NB. pd 'show'
pd 'visible 0'
pd 'pdf ',jpath '~/Desktop/mm_only.pdf'
