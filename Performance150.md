# Duktape 1.5.0 performance measurement

Measurement host:

* "Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz" laptop

Duktape is compiled with:

* gcc-4.8.4 (Ubuntu 14.04.3) on x64
* `gcc -O2`
* debugger and interrupt executor support enabled
* fastints enabled (not default)
* `JSON.stringify()` fast path enabled for columns marked "json",
  disabled otherwise (default)

Note that:

* These are microbenchmarks, and don't necessarily represent application
  performance very well.  Microbenchmarks are useful for measuring how well
  different parts of the engine work.

* Only relative numbers matter.  Loop counts differ between test cases so
  the numbers for two tests are not directly comparable.  Absolute numbers
  may also change between test runs if test target is different.

* The measurement process is not very accurate: it's based on running the
  test multiple times and measuring time using the `time` command.

* Rhino, Node.js, and LuaJIT are JIT-based engines which are typically
  10-100x faster than interpreting engines (like Duktape, MuJS, Lua, etc).
  Some microbenchmark results may be non-representative because a JIT engine
  may e.g. eliminate repeated assignments, intended to exercise assignment
  performance, as dead code.

## Performance summary

<table>
<tr><th></th><th>duk.O2.150json</th><th>duk.O2.150nojson</th><th>duk.O2.140json</th><th>duk.O2.140nojson</th><th>duk.O2.130</th><th>duk.O2.125</th><th>duk.O2.113</th><th>duk.O2.102</th><th>|</th><th>0.39</th><th>n/a</th><th>n/a</th><th>n/a</th><th>n/a</th><th>rhino</th><th>node</th><th>luajit</th></tr>
<tr><td>test-add-fastint.js</td><td>0.08</td><td>0.08</td><td>0.08</td><td>0.08</td><td>0.10</td><td>0.15</td><td>0.17</td><td>0.18</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.28</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-add-float.js</td><td>0.07</td><td>0.08</td><td>0.07</td><td>0.07</td><td>0.11</td><td>0.14</td><td>0.17</td><td>0.20</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.29</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-add-nan-fastint.js</td><td>0.09</td><td>0.09</td><td>0.14</td><td>0.09</td><td>0.13</td><td>0.16</td><td>0.17</td><td>0.18</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.27</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-add-nan.js</td><td>0.08</td><td>0.08</td><td>0.07</td><td>0.07</td><td>0.11</td><td>0.15</td><td>0.17</td><td>0.18</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.28</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-array-read.js</td><td>2.13</td><td>2.16</td><td>2.10</td><td>2.10</td><td>2.02</td><td>2.61</td><td>2.97</td><td>2.97</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.38</td><td>0.05</td><td>0.00</td></tr>
<tr><td>test-array-write.js</td><td>2.59</td><td>2.53</td><td>2.59</td><td>2.59</td><td>2.45</td><td>3.16</td><td>16.43</td><td>16.54</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.07</td><td>0.05</td><td>0.00</td></tr>
<tr><td>test-assign-add.js</td><td>5.19</td><td>5.20</td><td>5.23</td><td>5.22</td><td>8.76</td><td>11.03</td><td>10.55</td><td>11.42</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>3.60</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-assign-addto-nan.js</td><td>1.54</td><td>1.57</td><td>1.43</td><td>1.43</td><td>2.10</td><td>3.58</td><td>2.74</td><td>2.94</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.33</td><td>0.23</td><td>n/a</td></tr>
<tr><td>test-assign-addto.js</td><td>5.19</td><td>5.22</td><td>5.22</td><td>5.26</td><td>8.84</td><td>14.79</td><td>10.60</td><td>11.41</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>3.45</td><td>0.81</td><td>0.92</td></tr>
<tr><td>test-assign-const-int.js</td><td>2.61</td><td>2.62</td><td>2.59</td><td>2.56</td><td>6.98</td><td>4.76</td><td>9.76</td><td>10.30</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.31</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-assign-const.js</td><td>4.25</td><td>4.24</td><td>3.92</td><td>4.01</td><td>6.06</td><td>4.74</td><td>11.08</td><td>11.56</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.32</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-assign-literal.js</td><td>4.17</td><td>4.27</td><td>4.26</td><td>4.33</td><td>7.03</td><td>9.22</td><td>10.75</td><td>11.50</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.32</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-assign-proplhs-reg.js</td><td>3.67</td><td>3.71</td><td>3.80</td><td>3.63</td><td>3.96</td><td>4.10</td><td>4.59</td><td>3.85</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.70</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-proprhs.js</td><td>4.18</td><td>4.18</td><td>4.23</td><td>4.16</td><td>4.69</td><td>5.60</td><td>5.43</td><td>5.50</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.83</td><td>0.03</td><td>n/a</td></tr>
<tr><td>test-assign-reg.js</td><td>2.79</td><td>2.84</td><td>2.88</td><td>2.89</td><td>2.86</td><td>9.57</td><td>5.38</td><td>5.54</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.32</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-base64-decode-whitespace.js</td><td>1.84</td><td>1.94</td><td>1.92</td><td>1.88</td><td>11.01</td><td>10.40</td><td>10.95</td><td>10.69</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-base64-decode.js</td><td>1.51</td><td>1.51</td><td>1.52</td><td>1.50</td><td>5.99</td><td>5.27</td><td>5.76</td><td>5.25</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-base64-encode.js</td><td>1.81</td><td>1.86</td><td>1.84</td><td>1.82</td><td>17.37</td><td>17.10</td><td>16.91</td><td>16.91</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-bitwise-ops.js</td><td>0.66</td><td>0.72</td><td>0.76</td><td>0.80</td><td>0.91</td><td>1.15</td><td>5.05</td><td>5.32</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>7.82</td><td>0.06</td><td>n/a</td></tr>
<tr><td>test-break-fast.js</td><td>1.59</td><td>1.60</td><td>1.70</td><td>1.73</td><td>1.49</td><td>1.90</td><td>1.91</td><td>1.98</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.30</td><td>0.04</td><td>n/a</td></tr>
<tr><td>test-break-slow.js</td><td>7.96</td><td>7.90</td><td>7.79</td><td>7.76</td><td>11.25</td><td>11.77</td><td>11.50</td><td>11.56</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.29</td><td>0.54</td><td>n/a</td></tr>
<tr><td>test-buffer-nodejs-read.js</td><td>2.60</td><td>2.64</td><td>2.79</td><td>2.69</td><td>2.49</td><td>n/a</td><td>n/a</td><td>n/a</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-buffer-nodejs-write.js</td><td>3.04</td><td>3.10</td><td>3.06</td><td>3.06</td><td>3.31</td><td>n/a</td><td>n/a</td><td>n/a</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>0.05</td><td>n/a</td></tr>
<tr><td>test-buffer-object-read.js</td><td>2.67</td><td>2.69</td><td>2.83</td><td>2.75</td><td>2.43</td><td>18.63</td><td>19.26</td><td>18.96</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-object-write.js</td><td>3.06</td><td>3.10</td><td>3.06</td><td>3.08</td><td>3.34</td><td>21.86</td><td>22.13</td><td>20.24</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-plain-read.js</td><td>2.25</td><td>2.25</td><td>2.25</td><td>2.28</td><td>2.00</td><td>2.49</td><td>2.72</td><td>2.75</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-plain-write.js</td><td>1.83</td><td>1.86</td><td>1.91</td><td>1.87</td><td>1.77</td><td>2.34</td><td>5.05</td><td>3.20</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-basic-1.js</td><td>9.18</td><td>9.32</td><td>9.13</td><td>9.08</td><td>12.19</td><td>12.25</td><td>14.28</td><td>14.00</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.42</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-call-basic-2.js</td><td>9.14</td><td>9.31</td><td>9.13</td><td>9.00</td><td>12.12</td><td>12.20</td><td>14.45</td><td>14.03</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.62</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-call-basic-3.js</td><td>14.80</td><td>15.00</td><td>14.78</td><td>14.68</td><td>19.59</td><td>19.91</td><td>21.24</td><td>21.30</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.60</td><td>0.12</td><td>n/a</td></tr>
<tr><td>test-call-basic-4.js</td><td>36.96</td><td>36.57</td><td>35.56</td><td>35.61</td><td>45.09</td><td>49.39</td><td>50.37</td><td>49.92</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.53</td><td>0.52</td><td>n/a</td></tr>
<tr><td>test-call-native.js</td><td>13.74</td><td>13.78</td><td>14.16</td><td>13.59</td><td>18.86</td><td>18.73</td><td>20.85</td><td>20.62</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.51</td><td>3.78</td><td>n/a</td></tr>
<tr><td>test-compile-mandel-nofrac.js</td><td>13.22</td><td>13.32</td><td>13.26</td><td>13.19</td><td>13.31</td><td>16.96</td><td>18.52</td><td>18.36</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>7.05</td><td>0.07</td><td>n/a</td></tr>
<tr><td>test-compile-mandel.js</td><td>16.50</td><td>16.49</td><td>16.27</td><td>16.18</td><td>16.45</td><td>19.96</td><td>21.64</td><td>21.52</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>7.03</td><td>0.03</td><td>n/a</td></tr>
<tr><td>test-compile-short.js</td><td>9.91</td><td>10.12</td><td>9.99</td><td>9.96</td><td>10.23</td><td>10.08</td><td>11.08</td><td>10.81</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>3.65</td><td>0.16</td><td>n/a</td></tr>
<tr><td>test-continue-fast.js</td><td>2.15</td><td>2.16</td><td>2.20</td><td>2.17</td><td>1.91</td><td>2.52</td><td>2.73</td><td>2.76</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.51</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-continue-slow.js</td><td>8.46</td><td>8.45</td><td>8.44</td><td>8.45</td><td>11.82</td><td>12.61</td><td>12.46</td><td>12.57</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.51</td><td>0.57</td><td>n/a</td></tr>
<tr><td>test-empty-loop.js</td><td>2.27</td><td>2.26</td><td>2.30</td><td>2.38</td><td>2.36</td><td>3.13</td><td>5.74</td><td>5.88</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.69</td><td>0.07</td><td>0.11</td></tr>
<tr><td>test-fib.js</td><td>7.78</td><td>8.74</td><td>7.96</td><td>7.67</td><td>8.71</td><td>9.18</td><td>10.10</td><td>9.76</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.16</td><td>0.15</td><td>0.30</td></tr>
<tr><td>test-global-lookup.js</td><td>10.12</td><td>11.81</td><td>10.87</td><td>10.17</td><td>10.05</td><td>10.60</td><td>11.67</td><td>11.16</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.17</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-hello-world.js</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.23</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-hex-decode.js</td><td>3.61</td><td>3.60</td><td>3.65</td><td>3.61</td><td>5.34</td><td>5.37</td><td>9.39</td><td>9.38</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-hex-encode.js</td><td>2.83</td><td>2.83</td><td>2.87</td><td>2.84</td><td>6.05</td><td>6.04</td><td>6.73</td><td>6.70</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jc-serialize-indented.js</td><td>3.48</td><td>22.53</td><td>3.65</td><td>23.01</td><td>34.32</td><td>37.12</td><td>41.21</td><td>44.81</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jc-serialize.js</td><td>2.39</td><td>21.08</td><td>2.51</td><td>21.39</td><td>28.90</td><td>30.87</td><td>34.59</td><td>34.21</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-hex.js</td><td>3.39</td><td>3.37</td><td>3.45</td><td>3.42</td><td>6.63</td><td>6.66</td><td>8.36</td><td>8.36</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-integer.js</td><td>4.12</td><td>4.10</td><td>3.98</td><td>4.07</td><td>4.08</td><td>4.08</td><td>4.09</td><td>4.19</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>2.21</td><td>0.36</td><td>n/a</td></tr>
<tr><td>test-json-parse-number.js</td><td>5.17</td><td>5.17</td><td>5.21</td><td>5.17</td><td>5.11</td><td>5.07</td><td>5.27</td><td>5.26</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.57</td><td>0.17</td><td>n/a</td></tr>
<tr><td>test-json-parse-string.js</td><td>5.74</td><td>5.56</td><td>5.50</td><td>5.71</td><td>5.64</td><td>30.27</td><td>30.29</td><td>30.26</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>22.59</td><td>6.42</td><td>n/a</td></tr>
<tr><td>test-json-serialize-fastpath-loop.js</td><td>3.55</td><td>19.80</td><td>3.68</td><td>19.43</td><td>32.52</td><td>35.84</td><td>39.21</td><td>38.29</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>111.82</td><td>34.78</td><td>n/a</td></tr>
<tr><td>test-json-serialize-forceslow.js</td><td>10.90</td><td>10.30</td><td>11.14</td><td>10.30</td><td>12.55</td><td>12.56</td><td>12.99</td><td>12.59</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>5.55</td><td>0.70</td><td>n/a</td></tr>
<tr><td>test-json-serialize-hex.js</td><td>1.45</td><td>1.47</td><td>1.52</td><td>1.48</td><td>2.76</td><td>24.40</td><td>23.80</td><td>22.51</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep100.js</td><td>2.35</td><td>2.34</td><td>2.39</td><td>2.29</td><td>3.66</td><td>3.74</td><td>3.86</td><td>3.85</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>40.37</td><td>0.99</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep25.js</td><td>3.28</td><td>28.09</td><td>3.36</td><td>27.47</td><td>45.28</td><td>46.98</td><td>55.20</td><td>49.53</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>61.82</td><td>14.03</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep500.js</td><td>1.48</td><td>1.49</td><td>1.45</td><td>1.44</td><td>2.37</td><td>2.42</td><td>2.51</td><td>2.47</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1267.28</td><td>0.52</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented.js</td><td>6.26</td><td>44.53</td><td>6.29</td><td>45.62</td><td>67.72</td><td>75.11</td><td>81.32</td><td>82.33</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>25.33</td><td>23.61</td><td>n/a</td></tr>
<tr><td>test-json-serialize-jsonrpc-message.js</td><td>2.00</td><td>2.56</td><td>2.02</td><td>2.56</td><td>4.00</td><td>7.83</td><td>8.05</td><td>7.77</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-nofrac.js</td><td>0.69</td><td>4.76</td><td>0.71</td><td>4.82</td><td>0.72</td><td>6.83</td><td>7.42</td><td>7.30</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>4.17</td><td>0.62</td><td>n/a</td></tr>
<tr><td>test-json-serialize-slowpath-loop.js</td><td>5.90</td><td>5.92</td><td>5.83</td><td>5.78</td><td>8.68</td><td>9.45</td><td>10.33</td><td>10.13</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>11.82</td><td>2.95</td><td>n/a</td></tr>
<tr><td>test-json-serialize.js</td><td>6.20</td><td>10.13</td><td>6.24</td><td>10.35</td><td>6.23</td><td>12.53</td><td>12.93</td><td>12.78</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>5.39</td><td>0.70</td><td>n/a</td></tr>
<tr><td>test-json-string-bench.js</td><td>5.23</td><td>5.30</td><td>5.29</td><td>5.33</td><td>5.44</td><td>5.44</td><td>6.67</td><td>6.61</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>2.09</td><td>0.26</td><td>n/a</td></tr>
<tr><td>test-json-string-stringify.js</td><td>5.06</td><td>5.04</td><td>5.21</td><td>5.23</td><td>6.43</td><td>17.76</td><td>17.83</td><td>17.11</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>18.37</td><td>5.99</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-bufobj-forceslow.js</td><td>5.20</td><td>4.54</td><td>5.73</td><td>5.19</td><td>6.14</td><td>n/a</td><td>n/a</td><td>n/a</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-bufobj.js</td><td>1.12</td><td>4.35</td><td>1.09</td><td>4.93</td><td>5.98</td><td>n/a</td><td>n/a</td><td>n/a</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-indented.js</td><td>3.46</td><td>22.49</td><td>3.68</td><td>22.65</td><td>34.04</td><td>35.92</td><td>40.11</td><td>40.16</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize.js</td><td>2.41</td><td>20.72</td><td>2.54</td><td>21.21</td><td>28.79</td><td>30.82</td><td>34.32</td><td>33.58</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-mandel.js</td><td>4.34</td><td>4.39</td><td>4.38</td><td>4.37</td><td>4.70</td><td>5.89</td><td>6.39</td><td>6.75</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.57</td><td>0.21</td><td>n/a</td></tr>
<tr><td>test-object-garbage.js</td><td>4.34</td><td>4.56</td><td>4.61</td><td>4.64</td><td>4.57</td><td>4.81</td><td>5.03</td><td>4.91</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.97</td><td>0.14</td><td>0.00</td></tr>
<tr><td>test-prop-read.js</td><td>4.76</td><td>4.81</td><td>4.91</td><td>4.88</td><td>5.26</td><td>6.20</td><td>6.47</td><td>6.49</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.66</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-prop-write.js</td><td>4.20</td><td>4.18</td><td>4.29</td><td>4.15</td><td>4.45</td><td>4.90</td><td>5.63</td><td>4.77</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.87</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-reg-readwrite-object.js</td><td>3.17</td><td>3.19</td><td>3.16</td><td>3.18</td><td>3.76</td><td>10.59</td><td>7.05</td><td>7.40</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.35</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-reg-readwrite-plain.js</td><td>2.04</td><td>2.02</td><td>2.04</td><td>2.04</td><td>2.55</td><td>9.33</td><td>4.71</td><td>4.89</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.36</td><td>0.04</td><td>0.00</td></tr>
<tr><td>test-regexp-case-insensitive.js</td><td>24.31</td><td>24.39</td><td>23.24</td><td>23.27</td><td>23.25</td><td>23.34</td><td>24.17</td><td>24.15</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.23</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-regexp-string-parse.js</td><td>9.68</td><td>9.71</td><td>9.55</td><td>9.43</td><td>10.51</td><td>12.69</td><td>12.53</td><td>12.54</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>0.08</td><td>n/a</td></tr>
<tr><td>test-string-array-concat.js</td><td>6.59</td><td>6.48</td><td>7.01</td><td>6.86</td><td>6.46</td><td>7.70</td><td>23.97</td><td>23.21</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.97</td><td>0.44</td><td>0.86</td></tr>
<tr><td>test-string-charlen-ascii.js</td><td>1.36</td><td>1.30</td><td>1.35</td><td>1.38</td><td>5.27</td><td>5.34</td><td>5.36</td><td>5.37</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.33</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-string-charlen-nonascii.js</td><td>2.80</td><td>2.79</td><td>2.80</td><td>2.80</td><td>3.95</td><td>3.96</td><td>3.92</td><td>3.89</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.33</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-string-compare.js</td><td>3.77</td><td>3.75</td><td>3.94</td><td>3.87</td><td>3.81</td><td>4.65</td><td>6.11</td><td>6.11</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>4.49</td><td>0.86</td><td>0.18</td></tr>
<tr><td>test-string-decodeuri.js</td><td>3.66</td><td>3.71</td><td>3.57</td><td>3.57</td><td>3.59</td><td>4.20</td><td>4.09</td><td>4.16</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>2.08</td><td>3.92</td><td>n/a</td></tr>
<tr><td>test-string-encodeuri.js</td><td>4.04</td><td>4.05</td><td>4.17</td><td>4.13</td><td>4.35</td><td>6.31</td><td>6.26</td><td>6.26</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>6.91</td><td>41.41</td><td>n/a</td></tr>
<tr><td>test-string-garbage.js</td><td>8.52</td><td>8.49</td><td>8.49</td><td>8.46</td><td>8.70</td><td>9.39</td><td>9.50</td><td>9.24</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.00</td><td>0.02</td><td>1.33</td></tr>
<tr><td>test-string-intern-grow-short.js</td><td>21.18</td><td>21.08</td><td>20.82</td><td>20.64</td><td>7.27</td><td>7.70</td><td>13.29</td><td>12.44</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow-short2.js</td><td>7.50</td><td>7.57</td><td>7.38</td><td>7.32</td><td>7.35</td><td>7.76</td><td>13.18</td><td>12.49</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow.js</td><td>38.85</td><td>39.29</td><td>39.60</td><td>39.62</td><td>4.93</td><td>4.98</td><td>5.59</td><td>5.50</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow2.js</td><td>3.30</td><td>3.29</td><td>3.29</td><td>3.23</td><td>5.05</td><td>5.19</td><td>5.76</td><td>5.73</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-match-short.js</td><td>2.70</td><td>2.69</td><td>2.69</td><td>2.75</td><td>2.25</td><td>2.30</td><td>2.35</td><td>2.26</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-match.js</td><td>0.38</td><td>0.37</td><td>0.37</td><td>0.39</td><td>0.97</td><td>1.03</td><td>1.06</td><td>1.05</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-miss-short.js</td><td>5.49</td><td>5.51</td><td>5.47</td><td>5.49</td><td>5.11</td><td>5.25</td><td>5.50</td><td>5.40</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-miss.js</td><td>1.29</td><td>1.28</td><td>1.31</td><td>1.33</td><td>2.57</td><td>2.60</td><td>2.80</td><td>2.73</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-plain-concat.js</td><td>1.03</td><td>1.07</td><td>1.02</td><td>1.09</td><td>4.05</td><td>4.14</td><td>4.10</td><td>4.12</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.30</td><td>0.03</td><td>0.65</td></tr>
<tr><td>test-string-uppercase.js</td><td>2.23</td><td>2.16</td><td>2.18</td><td>2.15</td><td>2.58</td><td>3.31</td><td>3.36</td><td>3.48</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>1.62</td><td>0.09</td><td>n/a</td></tr>
<tr><td>test-try-catch-nothrow.js</td><td>2.91</td><td>2.93</td><td>3.01</td><td>3.05</td><td>2.56</td><td>2.80</td><td>2.37</td><td>2.43</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.31</td><td>0.36</td><td>n/a</td></tr>
<tr><td>test-try-catch-throw.js</td><td>39.17</td><td>38.58</td><td>39.09</td><td>39.14</td><td>37.91</td><td>38.05</td><td>38.45</td><td>38.32</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>133.09</td><td>8.01</td><td>n/a</td></tr>
<tr><td>test-try-finally-nothrow.js</td><td>3.74</td><td>3.73</td><td>3.64</td><td>3.65</td><td>2.86</td><td>3.31</td><td>3.10</td><td>3.21</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>0.29</td><td>0.53</td><td>n/a</td></tr>
<tr><td>test-try-finally-throw.js</td><td>49.13</td><td>48.05</td><td>48.98</td><td>48.67</td><td>45.77</td><td>45.74</td><td>45.25</td><td>45.08</td><td>mujs</td><td>lua</td><td>python</td><td>perl</td><td>ruby</td><td>|</td><td>134.35</td><td>10.04</td><td>n/a</td></tr>
</table>
</body>
</html>
