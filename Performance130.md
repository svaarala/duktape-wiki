# Duktape 1.3.0 performance measurement

Measured using an "Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz" laptop.
Duktape is compiled with gcc-4.8.4 (Ubuntu 14.04.3) on x64, using
`gcc -O2`, debugger and interrupt executor support enabled, fastints
enabled.

Note that:

* These are microbenchmarks, and don't necessarily represent application
  performance very well.  Microbenchmarks are useful for measuring how well
  different parts of the engine work.

* The measurement process is not very accurate: it's based on running the
  test multiple times and measuring time using the `time` command.

## Performance summary

<table>
<tr>
<th>Testcase</th>
<th>duk 1.3.0</th>
<th>duk 1.2.3</th>
<th>duk 1.1.3</th>
<th>rhino</th>
<th>lua</th>
<th>python</th>
<th>perl</th>
<th>ruby</th>
</tr>
<tr>
<td>test-array-read.js</td>
<td>4.13</td>
<td>5.62</td>
<td>7.96</td>
<td>0.99</td>
<td>1.19</td>
<td>5.64</td>
<td>5.34</td>
<td>4.41</td>
</tr>
<tr>
<td>test-array-write.js</td>
<td>4.37</td>
<td>6.04</td>
<td>22.21</td>
<td>1.59</td>
<td>1.38</td>
<td>6.30</td>
<td>5.32</td>
<td>6.89</td>
</tr>
<tr>
<td>test-bitwise-ops.js</td>
<td>0.85</td>
<td>1.11</td>
<td>5.06</td>
<td>8.41</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-buffer-nodejs-read.js</td>
<td>4.61</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-buffer-nodejs-write.js</td>
<td>5.52</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-buffer-object-read.js</td>
<td>4.62</td>
<td>21.63</td>
<td>25.47</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-buffer-object-write.js</td>
<td>5.53</td>
<td>24.61</td>
<td>28.58</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-buffer-plain-read.js</td>
<td>4.24</td>
<td>5.25</td>
<td>7.70</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-buffer-plain-write.js</td>
<td>3.75</td>
<td>5.28</td>
<td>10.55</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-call-basic.js</td>
<td>14.42</td>
<td>15.52</td>
<td>20.05</td>
<td>3.87</td>
<td>2.41</td>
<td>9.02</td>
<td>9.70</td>
<td>6.24</td>
</tr>
<tr>
<td>test-compile-mandel-nofrac.js</td>
<td>13.21</td>
<td>16.52</td>
<td>18.38</td>
<td>7.54</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-compile-mandel.js</td>
<td>16.32</td>
<td>19.49</td>
<td>21.45</td>
<td>7.58</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-compile-short.js</td>
<td>10.17</td>
<td>9.91</td>
<td>11.07</td>
<td>4.11</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-const-load.js</td>
<td>5.96</td>
<td>9.48</td>
<td>10.88</td>
<td>0.30</td>
<td>2.10</td>
<td>5.41</td>
<td>24.22</td>
<td>4.01</td>
</tr>
<tr>
<td>test-empty-loop.js</td>
<td>2.33</td>
<td>3.10</td>
<td>5.73</td>
<td>0.66</td>
<td>0.94</td>
<td>4.50</td>
<td>3.40</td>
<td>3.30</td>
</tr>
<tr>
<td>test-fib.js</td>
<td>8.57</td>
<td>9.39</td>
<td>9.77</td>
<td>1.22</td>
<td>1.32</td>
<td>2.39</td>
<td>6.39</td>
<td>1.51</td>
</tr>
<tr>
<td>test-global-lookup.js</td>
<td>9.98</td>
<td>10.59</td>
<td>11.52</td>
<td>1.22</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-hello-world.js</td>
<td>0.00</td>
<td>0.00</td>
<td>0.00</td>
<td>0.23</td>
<td>0.00</td>
<td>0.00</td>
<td>0.00</td>
<td>0.00</td>
</tr>
<tr>
<td>test-hex-decode.js</td>
<td>5.30</td>
<td>5.30</td>
<td>9.30</td>
<td>n/a</td>
<td>n/a</td>
<td>12.33</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-hex-encode.js</td>
<td>26.28</td>
<td>26.32</td>
<td>28.56</td>
<td>n/a</td>
<td>n/a</td>
<td>2.85</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-json-integer-parse.js</td>
<td>0.41</td>
<td>0.42</td>
<td>0.41</td>
<td>1.07</td>
<td>n/a</td>
<td>0.07</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-json-number-parse.js</td>
<td>5.09</td>
<td>4.98</td>
<td>5.23</td>
<td>1.58</td>
<td>n/a</td>
<td>0.29</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-json-serialize.js</td>
<td>1.56</td>
<td>3.08</td>
<td>3.21</td>
<td>3.29</td>
<td>n/a</td>
<td>0.51</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-json-string-bench.js</td>
<td>5.41</td>
<td>5.38</td>
<td>6.63</td>
<td>2.11</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-json-string-parse.js</td>
<td>0.55</td>
<td>2.99</td>
<td>2.99</td>
<td>2.46</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-json-string-stringify.js</td>
<td>1.23</td>
<td>3.53</td>
<td>3.50</td>
<td>6.15</td>
<td>n/a</td>
<td>0.48</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-prop-read.js</td>
<td>7.58</td>
<td>8.48</td>
<td>12.00</td>
<td>1.07</td>
<td>1.24</td>
<td>6.17</td>
<td>6.86</td>
<td>14.56</td>
</tr>
<tr>
<td>test-prop-write.js</td>
<td>6.95</td>
<td>7.75</td>
<td>11.47</td>
<td>2.14</td>
<td>1.42</td>
<td>6.49</td>
<td>6.91</td>
<td>18.21</td>
</tr>
<tr>
<td>test-reg-load.js</td>
<td>2.75</td>
<td>4.29</td>
<td>5.29</td>
<td>0.30</td>
<td>2.25</td>
<td>5.70</td>
<td>n/a</td>
<td>4.04</td>
</tr>
<tr>
<td>test-reg-readwrite-object.js</td>
<td>3.72</td>
<td>5.33</td>
<td>7.03</td>
<td>0.34</td>
<td>1.72</td>
<td>4.72</td>
<td>28.35</td>
<td>3.87</td>
</tr>
<tr>
<td>test-reg-readwrite-plain.js</td>
<td>2.48</td>
<td>3.93</td>
<td>4.67</td>
<td>0.37</td>
<td>1.72</td>
<td>4.73</td>
<td>30.16</td>
<td>3.98</td>
</tr>
<tr>
<td>test-regexp-string-parse.js</td>
<td>10.51</td>
<td>12.59</td>
<td>12.43</td>
<td>n/a</td>
<td>n/a</td>
<td>0.46</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-string-array-concat.js</td>
<td>6.37</td>
<td>7.52</td>
<td>24.43</td>
<td>2.02</td>
<td>2.06</td>
<td>2.83</td>
<td>7.40</td>
<td>7.74</td>
</tr>
<tr>
<td>test-string-compare.js</td>
<td>3.76</td>
<td>4.56</td>
<td>6.07</td>
<td>5.67</td>
<td>2.80</td>
<td>4.85</td>
<td>16.13</td>
<td>5.30</td>
</tr>
<tr>
<td>test-string-decodeuri.js</td>
<td>3.54</td>
<td>4.10</td>
<td>4.02</td>
<td>1.91</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-string-encodeuri.js</td>
<td>4.29</td>
<td>6.17</td>
<td>6.24</td>
<td>6.82</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-string-intern-match.js</td>
<td>2.35</td>
<td>2.36</td>
<td>2.41</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-string-intern-miss.js</td>
<td>2.51</td>
<td>2.54</td>
<td>2.76</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
<td>n/a</td>
</tr>
<tr>
<td>test-string-plain-concat.js</td>
<td>4.06</td>
<td>4.07</td>
<td>4.06</td>
<td>0.31</td>
<td>0.59</td>
<td>0.00</td>
<td>0.41</td>
<td>0.71</td>
</tr>
<tr>
<td>test-string-uppercase.js</td>
<td>2.55</td>
<td>3.28</td>
<td>3.26</td>
<td>2.55</td>
<td>n/a</td>
<td>1.21</td>
<td>n/a</td>
<td>n/a</td>
</tr>
</table>


## Raw results

```
for i in tests/perf/*.js; do \
		printf '%-30s:' "`basename $i`"; \
		printf ' duk.O2.130 %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  ./duk.O2.130 $i`"; \
		printf ' duk.O2.123 %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  ./duk.O2.123 $i`"; \
		printf ' duk.O2.113 %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  ./duk.O2.113 $i`"; \
		printf ' rhino %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  rhino $i`"; \
		printf ' lua %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  lua ${i%%.js}.lua`"; \
		printf ' python %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  python ${i%%.js}.py`"; \
		printf ' perl %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  perl ${i%%.js}.pl`"; \
		printf ' ruby %5s' "`python util/time_multi.py --count 5 --sleep 10 --mode min  ruby ${i%%.js}.rb`"; \
		printf '\n'; \
	done
test-array-read.js            : duk.O2.130  4.13 duk.O2.123  5.62 duk.O2.113  7.96 rhino  0.99 lua  1.19 python  5.64 perl  5.34 ruby  4.41
test-array-write.js           : duk.O2.130  4.37 duk.O2.123  6.04 duk.O2.113 22.21 rhino  1.59 lua  1.38 python  6.30 perl  5.32 ruby  6.89
test-bitwise-ops.js           : duk.O2.130  0.85 duk.O2.123  1.11 duk.O2.113  5.06 rhino  8.41 lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-nodejs-read.js    : duk.O2.130  4.61 duk.O2.123   n/a duk.O2.113   n/a rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-nodejs-write.js   : duk.O2.130  5.52 duk.O2.123   n/a duk.O2.113   n/a rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-object-read.js    : duk.O2.130  4.62 duk.O2.123 21.63 duk.O2.113 25.47 rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-object-write.js   : duk.O2.130  5.53 duk.O2.123 24.61 duk.O2.113 28.58 rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-plain-read.js     : duk.O2.130  4.24 duk.O2.123  5.25 duk.O2.113  7.70 rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-plain-write.js    : duk.O2.130  3.75 duk.O2.123  5.28 duk.O2.113 10.55 rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-call-basic.js            : duk.O2.130 14.42 duk.O2.123 15.52 duk.O2.113 20.05 rhino  3.87 lua  2.41 python  9.02 perl  9.70 ruby  6.24
test-compile-mandel-nofrac.js : duk.O2.130 13.21 duk.O2.123 16.52 duk.O2.113 18.38 rhino  7.54 lua   n/a python   n/a perl   n/a ruby   n/a
test-compile-mandel.js        : duk.O2.130 16.32 duk.O2.123 19.49 duk.O2.113 21.45 rhino  7.58 lua   n/a python   n/a perl   n/a ruby   n/a
test-compile-short.js         : duk.O2.130 10.17 duk.O2.123  9.91 duk.O2.113 11.07 rhino  4.11 lua   n/a python   n/a perl   n/a ruby   n/a
test-const-load.js            : duk.O2.130  5.96 duk.O2.123  9.48 duk.O2.113 10.88 rhino  0.30 lua  2.10 python  5.41 perl 24.22 ruby  4.01
test-empty-loop.js            : duk.O2.130  2.33 duk.O2.123  3.10 duk.O2.113  5.73 rhino  0.66 lua  0.94 python  4.50 perl  3.40 ruby  3.30
test-fib.js                   : duk.O2.130  8.57 duk.O2.123  9.39 duk.O2.113  9.77 rhino  1.22 lua  1.32 python  2.39 perl  6.39 ruby  1.51
test-global-lookup.js         : duk.O2.130  9.98 duk.O2.123 10.59 duk.O2.113 11.52 rhino  1.22 lua   n/a python   n/a perl   n/a ruby   n/a
test-hello-world.js           : duk.O2.130  0.00 duk.O2.123  0.00 duk.O2.113  0.00 rhino  0.23 lua  0.00 python  0.00 perl  0.00 ruby  0.00
test-hex-decode.js            : duk.O2.130  5.30 duk.O2.123  5.30 duk.O2.113  9.30 rhino   n/a lua   n/a python 12.33 perl   n/a ruby   n/a
test-hex-encode.js            : duk.O2.130 26.28 duk.O2.123 26.32 duk.O2.113 28.56 rhino   n/a lua   n/a python  2.85 perl   n/a ruby   n/a
test-json-integer-parse.js    : duk.O2.130  0.41 duk.O2.123  0.42 duk.O2.113  0.41 rhino  1.07 lua   n/a python  0.07 perl   n/a ruby   n/a
test-json-number-parse.js     : duk.O2.130  5.09 duk.O2.123  4.98 duk.O2.113  5.23 rhino  1.58 lua   n/a python  0.29 perl   n/a ruby   n/a
test-json-serialize.js        : duk.O2.130  1.56 duk.O2.123  3.08 duk.O2.113  3.21 rhino  3.29 lua   n/a python  0.51 perl   n/a ruby   n/a
test-json-string-bench.js     : duk.O2.130  5.41 duk.O2.123  5.38 duk.O2.113  6.63 rhino  2.11 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-string-parse.js     : duk.O2.130  0.55 duk.O2.123  2.99 duk.O2.113  2.99 rhino  2.46 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-string-stringify.js : duk.O2.130  1.23 duk.O2.123  3.53 duk.O2.113  3.50 rhino  6.15 lua   n/a python  0.48 perl   n/a ruby   n/a
test-prop-read.js             : duk.O2.130  7.58 duk.O2.123  8.48 duk.O2.113 12.00 rhino  1.07 lua  1.24 python  6.17 perl  6.86 ruby 14.56
test-prop-write.js            : duk.O2.130  6.95 duk.O2.123  7.75 duk.O2.113 11.47 rhino  2.14 lua  1.42 python  6.49 perl  6.91 ruby 18.21
test-reg-load.js              : duk.O2.130  2.75 duk.O2.123  4.29 duk.O2.113  5.29 rhino  0.30 lua  2.25 python  5.70 perl   n/a ruby  4.04
test-reg-readwrite-object.js  : duk.O2.130  3.72 duk.O2.123  5.33 duk.O2.113  7.03 rhino  0.34 lua  1.72 python  4.72 perl 28.35 ruby  3.87
test-reg-readwrite-plain.js   : duk.O2.130  2.48 duk.O2.123  3.93 duk.O2.113  4.67 rhino  0.37 lua  1.72 python  4.73 perl 30.16 ruby  3.98
test-regexp-string-parse.js   : duk.O2.130 10.51 duk.O2.123 12.59 duk.O2.113 12.43 rhino   n/a lua   n/a python  0.46 perl   n/a ruby   n/a
test-string-array-concat.js   : duk.O2.130  6.37 duk.O2.123  7.52 duk.O2.113 24.43 rhino  2.02 lua  2.06 python  2.83 perl  7.40 ruby  7.74
test-string-compare.js        : duk.O2.130  3.76 duk.O2.123  4.56 duk.O2.113  6.07 rhino  5.67 lua  2.80 python  4.85 perl 16.13 ruby  5.30
test-string-decodeuri.js      : duk.O2.130  3.54 duk.O2.123  4.10 duk.O2.113  4.02 rhino  1.91 lua   n/a python   n/a perl   n/a ruby   n/a
test-string-encodeuri.js      : duk.O2.130  4.29 duk.O2.123  6.17 duk.O2.113  6.24 rhino  6.82 lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-match.js   : duk.O2.130  2.35 duk.O2.123  2.36 duk.O2.113  2.41 rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-miss.js    : duk.O2.130  2.51 duk.O2.123  2.54 duk.O2.113  2.76 rhino   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-plain-concat.js   : duk.O2.130  4.06 duk.O2.123  4.07 duk.O2.113  4.06 rhino  0.31 lua  0.59 python  0.00 perl  0.41 ruby  0.71
test-string-uppercase.js      : duk.O2.130  2.55 duk.O2.123  3.28 duk.O2.113  3.26 rhino  2.55 lua   n/a python  1.21 perl   n/a ruby   n/a
```
