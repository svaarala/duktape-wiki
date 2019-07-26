# Duktape 1.4.0 performance measurement

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
<tr><th></th><th>duk<br />1.4.0<br />json</th><th>duk<br />1.4.0<br />&nbsp;</th><th>duk<br />1.3.1<br />json</th><th>duk<br />1.2.5<br />&nbsp;</th><th>duk<br />1.1.3<br />&nbsp;</th><th>duk<br />1.0.2<br />&nbsp;</th><th>mujs</th><th>lua<br />5.1</th><th>python</th><th>perl</th><th>ruby</th><th>rhino</th><th>node</th><th>luajit</th></tr>
<tr><td>test-add-fastint.js</td><td>0.09</td><td>0.08</td><td>0.10</td><td>0.15</td><td>0.17</td><td>0.18</td><td>0.40</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.29</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-add-float.js</td><td>0.08</td><td>0.08</td><td>0.11</td><td>0.14</td><td>0.17</td><td>0.18</td><td>0.40</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.28</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-add-nan-fastint.js</td><td>0.08</td><td>0.08</td><td>0.12</td><td>0.16</td><td>0.17</td><td>0.18</td><td>0.40</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.27</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-add-nan.js</td><td>0.08</td><td>0.07</td><td>0.11</td><td>0.15</td><td>0.17</td><td>0.18</td><td>0.41</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.27</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-array-read.js</td><td>2.17</td><td>2.13</td><td>2.30</td><td>2.64</td><td>2.94</td><td>2.99</td><td>226.58</td><td>0.95</td><td>1.77</td><td>3.27</td><td>1.46</td><td>0.37</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-array-write.js</td><td>2.56</td><td>2.55</td><td>2.42</td><td>3.19</td><td>16.63</td><td>15.71</td><td>240.41</td><td>1.13</td><td>2.46</td><td>3.27</td><td>4.06</td><td>1.08</td><td>0.05</td><td>0.00</td></tr>
<tr><td>test-assign-add.js</td><td>5.26</td><td>5.29</td><td>8.79</td><td>11.08</td><td>10.61</td><td>11.44</td><td>35.44</td><td>3.23</td><td>13.87</td><td>25.10</td><td>10.17</td><td>3.65</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-assign-addto-nan.js</td><td>1.41</td><td>1.43</td><td>2.62</td><td>3.59</td><td>2.75</td><td>2.90</td><td>7.35</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.34</td><td>0.23</td><td>n/a</td></tr>
<tr><td>test-assign-addto.js</td><td>5.28</td><td>5.25</td><td>11.37</td><td>14.95</td><td>10.71</td><td>11.52</td><td>35.29</td><td>3.22</td><td>16.36</td><td>24.11</td><td>10.23</td><td>3.61</td><td>0.83</td><td>0.93</td></tr>
<tr><td>test-assign-const-int.js</td><td>2.57</td><td>2.54</td><td>2.87</td><td>4.72</td><td>9.77</td><td>10.39</td><td>9.69</td><td>2.13</td><td>5.54</td><td>22.36</td><td>4.08</td><td>0.33</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-assign-const.js</td><td>3.99</td><td>4.00</td><td>2.85</td><td>4.74</td><td>11.04</td><td>11.54</td><td>9.78</td><td>2.12</td><td>5.51</td><td>22.83</td><td>4.05</td><td>0.32</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-assign-literal.js</td><td>4.32</td><td>4.36</td><td>7.08</td><td>9.28</td><td>10.88</td><td>11.64</td><td>9.99</td><td>2.61</td><td>11.99</td><td>n/a</td><td>4.48</td><td>0.31</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-assign-proplhs-reg.js</td><td>3.77</td><td>3.66</td><td>3.96</td><td>4.12</td><td>4.67</td><td>3.86</td><td>2.41</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.72</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-proprhs.js</td><td>4.26</td><td>4.18</td><td>4.66</td><td>5.61</td><td>5.48</td><td>5.57</td><td>2.48</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.88</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-assign-reg.js</td><td>2.88</td><td>2.87</td><td>5.30</td><td>9.65</td><td>5.39</td><td>5.55</td><td>8.88</td><td>2.27</td><td>5.83</td><td>23.42</td><td>4.13</td><td>0.34</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-base64-decode-whitespace.js</td><td>1.91</td><td>1.89</td><td>11.04</td><td>10.74</td><td>10.89</td><td>10.81</td><td>n/a</td><td>n/a</td><td>8.77</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-base64-decode.js</td><td>1.53</td><td>1.54</td><td>5.46</td><td>5.54</td><td>5.97</td><td>5.34</td><td>n/a</td><td>n/a</td><td>8.76</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-base64-encode.js</td><td>1.85</td><td>1.88</td><td>17.52</td><td>17.18</td><td>17.30</td><td>17.28</td><td>n/a</td><td>n/a</td><td>17.23</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-bitwise-ops.js</td><td>0.75</td><td>0.76</td><td>0.86</td><td>1.13</td><td>5.09</td><td>5.24</td><td>3.36</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>7.84</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-break-fast.js</td><td>1.67</td><td>1.70</td><td>1.48</td><td>1.84</td><td>1.88</td><td>2.03</td><td>1.20</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.30</td><td>0.04</td><td>n/a</td></tr>
<tr><td>test-break-slow.js</td><td>7.72</td><td>7.79</td><td>11.21</td><td>11.83</td><td>11.48</td><td>11.49</td><td>2.59</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.30</td><td>0.54</td><td>n/a</td></tr>
<tr><td>test-buffer-nodejs-read.js</td><td>2.74</td><td>2.78</td><td>2.60</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.03</td><td>n/a</td></tr>
<tr><td>test-buffer-nodejs-write.js</td><td>3.03</td><td>3.05</td><td>3.29</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.05</td><td>n/a</td></tr>
<tr><td>test-buffer-object-read.js</td><td>2.89</td><td>2.72</td><td>2.65</td><td>18.66</td><td>19.11</td><td>19.82</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-object-write.js</td><td>3.03</td><td>3.08</td><td>3.31</td><td>22.62</td><td>23.33</td><td>20.32</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-plain-read.js</td><td>2.21</td><td>2.26</td><td>2.16</td><td>2.46</td><td>2.72</td><td>2.75</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-plain-write.js</td><td>1.90</td><td>1.94</td><td>1.75</td><td>2.35</td><td>5.01</td><td>3.20</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-basic-1.js</td><td>9.15</td><td>9.01</td><td>12.00</td><td>12.23</td><td>14.31</td><td>13.99</td><td>6.56</td><td>2.18</td><td>5.25</td><td>7.77</td><td>3.39</td><td>1.39</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-call-basic-2.js</td><td>9.11</td><td>9.02</td><td>12.01</td><td>12.28</td><td>14.50</td><td>14.02</td><td>4.81</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.64</td><td>0.03</td><td>n/a</td></tr>
<tr><td>test-call-basic-3.js</td><td>14.65</td><td>14.60</td><td>20.00</td><td>19.97</td><td>21.23</td><td>21.22</td><td>12.42</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.61</td><td>0.12</td><td>n/a</td></tr>
<tr><td>test-call-basic-4.js</td><td>35.17</td><td>35.60</td><td>45.09</td><td>50.11</td><td>50.21</td><td>49.83</td><td>36.46</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.43</td><td>0.53</td><td>n/a</td></tr>
<tr><td>test-call-native.js</td><td>14.14</td><td>13.59</td><td>18.82</td><td>18.70</td><td>20.75</td><td>20.50</td><td>17.13</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.47</td><td>3.71</td><td>n/a</td></tr>
<tr><td>test-compile-mandel-nofrac.js</td><td>13.17</td><td>13.04</td><td>13.68</td><td>16.89</td><td>18.41</td><td>18.25</td><td>5.87</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>7.10</td><td>0.04</td><td>n/a</td></tr>
<tr><td>test-compile-mandel.js</td><td>16.22</td><td>16.32</td><td>16.60</td><td>19.80</td><td>21.59</td><td>21.46</td><td>5.85</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>7.01</td><td>0.07</td><td>n/a</td></tr>
<tr><td>test-compile-short.js</td><td>9.95</td><td>9.98</td><td>10.13</td><td>9.99</td><td>10.97</td><td>10.62</td><td>2.11</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>3.64</td><td>0.17</td><td>n/a</td></tr>
<tr><td>test-continue-fast.js</td><td>2.17</td><td>2.22</td><td>1.95</td><td>2.51</td><td>2.70</td><td>2.81</td><td>1.96</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.51</td><td>0.05</td><td>n/a</td></tr>
<tr><td>test-continue-slow.js</td><td>8.42</td><td>8.44</td><td>11.78</td><td>12.52</td><td>12.43</td><td>12.52</td><td>3.35</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.54</td><td>0.57</td><td>n/a</td></tr>
<tr><td>test-empty-loop.js</td><td>2.29</td><td>2.38</td><td>2.37</td><td>3.12</td><td>5.73</td><td>5.90</td><td>5.83</td><td>1.00</td><td>4.57</td><td>3.41</td><td>3.32</td><td>0.66</td><td>0.07</td><td>0.16</td></tr>
<tr><td>test-fib.js</td><td>7.90</td><td>7.61</td><td>8.60</td><td>9.17</td><td>9.82</td><td>9.89</td><td>3.30</td><td>1.33</td><td>2.41</td><td>6.43</td><td>1.52</td><td>1.18</td><td>0.16</td><td>0.27</td></tr>
<tr><td>test-global-lookup.js</td><td>10.71</td><td>10.23</td><td>11.29</td><td>11.50</td><td>11.71</td><td>11.27</td><td>4.11</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.14</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-hello-world.js</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.22</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-hex-decode.js</td><td>3.60</td><td>3.61</td><td>5.34</td><td>5.32</td><td>9.38</td><td>9.36</td><td>n/a</td><td>n/a</td><td>12.51</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-hex-encode.js</td><td>2.80</td><td>2.82</td><td>6.06</td><td>6.00</td><td>6.69</td><td>6.72</td><td>n/a</td><td>n/a</td><td>1.43</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jc-serialize-indented.js</td><td>3.64</td><td>23.03</td><td>34.18</td><td>37.45</td><td>40.70</td><td>40.49</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jc-serialize.js</td><td>2.48</td><td>20.93</td><td>28.54</td><td>31.37</td><td>34.76</td><td>36.39</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-hex.js</td><td>3.36</td><td>3.38</td><td>6.61</td><td>6.64</td><td>8.33</td><td>8.33</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-integer.js</td><td>3.94</td><td>4.01</td><td>4.06</td><td>4.09</td><td>4.06</td><td>4.12</td><td>20.95</td><td>n/a</td><td>0.07</td><td>n/a</td><td>n/a</td><td>2.26</td><td>0.32</td><td>n/a</td></tr>
<tr><td>test-json-parse-number.js</td><td>5.19</td><td>5.21</td><td>5.10</td><td>5.04</td><td>5.25</td><td>5.27</td><td>2.46</td><td>n/a</td><td>0.29</td><td>n/a</td><td>n/a</td><td>1.56</td><td>0.19</td><td>n/a</td></tr>
<tr><td>test-json-parse-string.js</td><td>5.47</td><td>5.69</td><td>5.62</td><td>30.08</td><td>30.04</td><td>30.01</td><td>44.72</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>22.48</td><td>6.08</td><td>n/a</td></tr>
<tr><td>test-json-serialize-fastpath-loop.js</td><td>3.64</td><td>19.45</td><td>32.38</td><td>35.70</td><td>40.51</td><td>38.37</td><td>12.57</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>111.97</td><td>32.99</td><td>n/a</td></tr>
<tr><td>test-json-serialize-hex.js</td><td>1.45</td><td>1.49</td><td>2.78</td><td>24.35</td><td>23.75</td><td>22.47</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep100.js</td><td>2.39</td><td>2.30</td><td>3.62</td><td>3.82</td><td>3.89</td><td>3.87</td><td>1.43</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>40.94</td><td>1.05</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep25.js</td><td>3.30</td><td>27.25</td><td>44.80</td><td>47.44</td><td>50.61</td><td>48.59</td><td>10.29</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>61.10</td><td>13.91</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep500.js</td><td>1.45</td><td>1.44</td><td>2.37</td><td>2.44</td><td>2.49</td><td>2.41</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1246.26</td><td>0.52</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented.js</td><td>6.25</td><td>46.83</td><td>69.94</td><td>76.16</td><td>82.02</td><td>82.05</td><td>14.79</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>25.46</td><td>23.71</td><td>n/a</td></tr>
<tr><td>test-json-serialize-jsonrpc-message.js</td><td>1.97</td><td>2.52</td><td>3.97</td><td>7.85</td><td>8.02</td><td>7.75</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-nofrac.js</td><td>0.69</td><td>4.83</td><td>0.69</td><td>6.98</td><td>7.44</td><td>7.29</td><td>1.55</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>4.14</td><td>0.61</td><td>n/a</td></tr>
<tr><td>test-json-serialize-slowpath-loop.js</td><td>5.81</td><td>5.75</td><td>8.58</td><td>9.44</td><td>10.30</td><td>10.03</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>11.92</td><td>2.97</td><td>n/a</td></tr>
<tr><td>test-json-serialize.js</td><td>6.24</td><td>10.39</td><td>6.30</td><td>12.47</td><td>12.90</td><td>12.70</td><td>2.17</td><td>n/a</td><td>0.51</td><td>n/a</td><td>n/a</td><td>5.40</td><td>0.70</td><td>n/a</td></tr>
<tr><td>test-json-string-bench.js</td><td>5.26</td><td>5.25</td><td>5.46</td><td>5.42</td><td>6.72</td><td>6.57</td><td>51.06</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.98</td><td>0.25</td><td>n/a</td></tr>
<tr><td>test-json-string-stringify.js</td><td>5.14</td><td>5.19</td><td>6.47</td><td>17.75</td><td>17.82</td><td>17.09</td><td>10.72</td><td>n/a</td><td>0.48</td><td>n/a</td><td>n/a</td><td>18.39</td><td>5.98</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-indented.js</td><td>3.72</td><td>22.64</td><td>34.09</td><td>36.06</td><td>39.81</td><td>39.56</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize.js</td><td>2.51</td><td>20.96</td><td>28.32</td><td>30.44</td><td>34.09</td><td>33.28</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-mandel.js</td><td>4.36</td><td>4.34</td><td>4.75</td><td>5.88</td><td>6.34</td><td>6.71</td><td>13.92</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.60</td><td>0.21</td><td>n/a</td></tr>
<tr><td>test-prop-read.js</td><td>4.89</td><td>4.80</td><td>5.25</td><td>6.18</td><td>6.43</td><td>6.50</td><td>3.76</td><td>1.03</td><td>2.44</td><td>4.85</td><td>11.16</td><td>0.67</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-prop-write.js</td><td>4.28</td><td>4.21</td><td>4.44</td><td>4.86</td><td>5.68</td><td>4.79</td><td>3.73</td><td>1.16</td><td>2.45</td><td>4.96</td><td>14.77</td><td>1.90</td><td>0.03</td><td>0.00</td></tr>
<tr><td>test-reg-readwrite-object.js</td><td>3.31</td><td>3.22</td><td>7.79</td><td>10.93</td><td>7.18</td><td>7.48</td><td>7.81</td><td>1.75</td><td>4.80</td><td>29.30</td><td>4.00</td><td>0.36</td><td>0.02</td><td>0.00</td></tr>
<tr><td>test-reg-readwrite-plain.js</td><td>2.07</td><td>2.06</td><td>5.07</td><td>9.42</td><td>4.90</td><td>4.94</td><td>7.75</td><td>1.76</td><td>4.79</td><td>32.32</td><td>4.03</td><td>0.38</td><td>0.01</td><td>0.00</td></tr>
<tr><td>test-regexp-case-insensitive.js</td><td>23.44</td><td>23.42</td><td>23.37</td><td>23.50</td><td>24.28</td><td>24.39</td><td>0.00</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.23</td><td>0.01</td><td>n/a</td></tr>
<tr><td>test-regexp-string-parse.js</td><td>9.75</td><td>9.52</td><td>10.66</td><td>12.83</td><td>12.68</td><td>12.74</td><td>n/a</td><td>n/a</td><td>0.51</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.08</td><td>n/a</td></tr>
<tr><td>test-string-array-concat.js</td><td>6.68</td><td>6.79</td><td>6.49</td><td>7.83</td><td>24.22</td><td>23.52</td><td>261.36</td><td>2.11</td><td>2.84</td><td>7.44</td><td>7.84</td><td>1.99</td><td>0.39</td><td>0.86</td></tr>
<tr><td>test-string-charlen-ascii.js</td><td>1.36</td><td>1.39</td><td>5.31</td><td>5.32</td><td>5.33</td><td>5.33</td><td>4.70</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.35</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-string-charlen-nonascii.js</td><td>2.82</td><td>2.80</td><td>3.92</td><td>3.94</td><td>3.95</td><td>3.96</td><td>7.14</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.34</td><td>0.02</td><td>n/a</td></tr>
<tr><td>test-string-compare.js</td><td>3.91</td><td>3.82</td><td>3.82</td><td>4.61</td><td>6.08</td><td>6.11</td><td>731.42</td><td>2.81</td><td>4.89</td><td>16.51</td><td>5.37</td><td>4.43</td><td>0.87</td><td>0.13</td></tr>
<tr><td>test-string-decodeuri.js</td><td>3.59</td><td>3.59</td><td>3.58</td><td>4.15</td><td>4.08</td><td>4.16</td><td>2.07</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>2.11</td><td>3.90</td><td>n/a</td></tr>
<tr><td>test-string-encodeuri.js</td><td>4.09</td><td>4.07</td><td>4.28</td><td>6.23</td><td>6.31</td><td>6.24</td><td>3.63</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>6.91</td><td>40.88</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow-short.js</td><td>20.92</td><td>20.74</td><td>7.18</td><td>7.73</td><td>13.37</td><td>12.34</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow-short2.js</td><td>7.35</td><td>7.35</td><td>7.27</td><td>7.81</td><td>13.32</td><td>12.45</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow.js</td><td>39.22</td><td>39.43</td><td>4.98</td><td>4.93</td><td>5.57</td><td>5.56</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow2.js</td><td>3.38</td><td>3.23</td><td>5.09</td><td>5.17</td><td>5.79</td><td>5.76</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-match-short.js</td><td>2.72</td><td>2.75</td><td>2.29</td><td>2.35</td><td>2.39</td><td>2.36</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-match.js</td><td>0.36</td><td>0.36</td><td>0.96</td><td>1.00</td><td>1.03</td><td>1.03</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-miss-short.js</td><td>5.55</td><td>5.67</td><td>5.11</td><td>5.23</td><td>5.50</td><td>5.52</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-miss.js</td><td>1.27</td><td>1.27</td><td>2.53</td><td>2.59</td><td>2.80</td><td>2.75</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-plain-concat.js</td><td>1.04</td><td>1.07</td><td>4.13</td><td>4.16</td><td>4.26</td><td>4.15</td><td>1.03</td><td>0.60</td><td>0.00</td><td>0.41</td><td>0.81</td><td>0.30</td><td>0.02</td><td>0.63</td></tr>
<tr><td>test-string-uppercase.js</td><td>2.21</td><td>2.22</td><td>2.65</td><td>3.54</td><td>3.35</td><td>3.48</td><td>4.50</td><td>n/a</td><td>1.28</td><td>n/a</td><td>n/a</td><td>1.67</td><td>0.09</td><td>n/a</td></tr>
<tr><td>test-try-catch-nothrow.js</td><td>3.05</td><td>3.04</td><td>2.57</td><td>2.76</td><td>2.39</td><td>2.45</td><td>2.22</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.30</td><td>0.33</td><td>n/a</td></tr>
<tr><td>test-try-catch-throw.js</td><td>41.50</td><td>39.62</td><td>39.86</td><td>39.99</td><td>39.29</td><td>38.20</td><td>20.53</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>133.42</td><td>8.02</td><td>n/a</td></tr>
<tr><td>test-try-finally-nothrow.js</td><td>3.63</td><td>3.68</td><td>2.81</td><td>3.32</td><td>3.12</td><td>3.18</td><td>2.06</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.32</td><td>0.54</td><td>n/a</td></tr>
<tr><td>test-try-finally-throw.js</td><td>51.09</td><td>49.40</td><td>46.12</td><td>45.92</td><td>45.58</td><td>45.41</td><td>22.90</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>130.83</td><td>10.05</td><td>n/a</td></tr>
</table>
