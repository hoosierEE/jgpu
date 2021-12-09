t =: |:".;._2'|'-.~{{)n
|    10 |   0.00003 |    0.00149 |    0.00003 |
|   100 |   0.00028 |    0.00157 |    0.00003 |
|   200 |  0.001639 |    0.00151 |    0.00003 |
|   500 |   0.01648 |    0.00175 |    0.00011 |
|  1000 |   0.07671 |    0.00172 |    0.00012 |
|  2000 |   0.43586 |    0.00265 |    0.00014 |
|  4000 |   3.43190 |    0.00635 |    0.00025 |
|  5000 |   6.48677 |    0.00909 |    0.00036 |
|  6000 |  10.99981 |    0.01261 |    0.00047 |
|  8000 |  25.81416 |    0.02156 |    0.00068 |
| 10000 |  50.19670 |    0.03276 |    0.00106 |
| 15000 | 174.86698 |    0.03281 |    0.00213 |
}}

pd 'reset'
pd 'key cpu gpu(cold) gpu(warm)'
pd 'ylog 1'
pd 'ycaption seconds'
pd 'xcaption square matrix side length'
pd 'xlabel ',":{.t
pd 'ylog 1'
pd }.t
pd 'visible 0'
pd 'pdf ',jpath '~/Desktop/mm_only.pdf'

NB. (_1{::ARGV) p t
