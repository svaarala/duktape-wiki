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

## Raw results

```
test-add-fastint.js                 : duk.O2.140  0.09 duk.O2.140nojson  0.08 duk.O2.131  0.10 duk.O2.125  0.15 duk.O2.113  0.17 duk.O2.102  0.18 mujs  0.40 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.29 node  0.02 luajit   n/a
test-add-float.js                   : duk.O2.140  0.08 duk.O2.140nojson  0.08 duk.O2.131  0.11 duk.O2.125  0.14 duk.O2.113  0.17 duk.O2.102  0.18 mujs  0.40 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.28 node  0.02 luajit   n/a
test-add-nan-fastint.js             : duk.O2.140  0.08 duk.O2.140nojson  0.08 duk.O2.131  0.12 duk.O2.125  0.16 duk.O2.113  0.17 duk.O2.102  0.18 mujs  0.40 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.27 node  0.02 luajit   n/a
test-add-nan.js                     : duk.O2.140  0.08 duk.O2.140nojson  0.07 duk.O2.131  0.11 duk.O2.125  0.15 duk.O2.113  0.17 duk.O2.102  0.18 mujs  0.41 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.27 node  0.02 luajit   n/a
test-array-read.js                  : duk.O2.140  2.17 duk.O2.140nojson  2.13 duk.O2.131  2.30 duk.O2.125  2.64 duk.O2.113  2.94 duk.O2.102  2.99 mujs 226.58 lua  0.95 python  1.77 perl  3.27 ruby  1.46 rhino  0.37 node  0.03 luajit  0.00
test-array-write.js                 : duk.O2.140  2.56 duk.O2.140nojson  2.55 duk.O2.131  2.42 duk.O2.125  3.19 duk.O2.113 16.63 duk.O2.102 15.71 mujs 240.41 lua  1.13 python  2.46 perl  3.27 ruby  4.06 rhino  1.08 node  0.05 luajit  0.00
test-assign-add.js                  : duk.O2.140  5.26 duk.O2.140nojson  5.29 duk.O2.131  8.79 duk.O2.125 11.08 duk.O2.113 10.61 duk.O2.102 11.44 mujs 35.44 lua  3.23 python 13.87 perl 25.10 ruby 10.17 rhino  3.65 node  0.02 luajit  0.00
test-assign-addto-nan.js            : duk.O2.140  1.41 duk.O2.140nojson  1.43 duk.O2.131  2.62 duk.O2.125  3.59 duk.O2.113  2.75 duk.O2.102  2.90 mujs  7.35 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.34 node  0.23 luajit   n/a
test-assign-addto.js                : duk.O2.140  5.28 duk.O2.140nojson  5.25 duk.O2.131 11.37 duk.O2.125 14.95 duk.O2.113 10.71 duk.O2.102 11.52 mujs 35.29 lua  3.22 python 16.36 perl 24.11 ruby 10.23 rhino  3.61 node  0.83 luajit  0.93
test-assign-const-int.js            : duk.O2.140  2.57 duk.O2.140nojson  2.54 duk.O2.131  2.87 duk.O2.125  4.72 duk.O2.113  9.77 duk.O2.102 10.39 mujs  9.69 lua  2.13 python  5.54 perl 22.36 ruby  4.08 rhino  0.33 node  0.03 luajit  0.00
test-assign-const.js                : duk.O2.140  3.99 duk.O2.140nojson  4.00 duk.O2.131  2.85 duk.O2.125  4.74 duk.O2.113 11.04 duk.O2.102 11.54 mujs  9.78 lua  2.12 python  5.51 perl 22.83 ruby  4.05 rhino  0.32 node  0.02 luajit  0.00
test-assign-literal.js              : duk.O2.140  4.32 duk.O2.140nojson  4.36 duk.O2.131  7.08 duk.O2.125  9.28 duk.O2.113 10.88 duk.O2.102 11.64 mujs  9.99 lua  2.61 python 11.99 perl   n/a ruby  4.48 rhino  0.31 node  0.03 luajit  0.00
test-assign-proplhs-reg.js          : duk.O2.140  3.77 duk.O2.140nojson  3.66 duk.O2.131  3.96 duk.O2.125  4.12 duk.O2.113  4.67 duk.O2.102  3.86 mujs  2.41 lua   n/a python   n/a perl   n/a ruby   n/a rhino  1.72 node   n/a luajit   n/a
test-assign-proprhs.js              : duk.O2.140  4.26 duk.O2.140nojson  4.18 duk.O2.131  4.66 duk.O2.125  5.61 duk.O2.113  5.48 duk.O2.102  5.57 mujs  2.48 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.88 node  0.02 luajit   n/a
test-assign-reg.js                  : duk.O2.140  2.88 duk.O2.140nojson  2.87 duk.O2.131  5.30 duk.O2.125  9.65 duk.O2.113  5.39 duk.O2.102  5.55 mujs  8.88 lua  2.27 python  5.83 perl 23.42 ruby  4.13 rhino  0.34 node  0.03 luajit  0.00
test-base64-decode-whitespace.js    : duk.O2.140  1.91 duk.O2.140nojson  1.89 duk.O2.131 11.04 duk.O2.125 10.74 duk.O2.113 10.89 duk.O2.102 10.81 mujs   n/a lua   n/a python  8.77 perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-base64-decode.js               : duk.O2.140  1.53 duk.O2.140nojson  1.54 duk.O2.131  5.46 duk.O2.125  5.54 duk.O2.113  5.97 duk.O2.102  5.34 mujs   n/a lua   n/a python  8.76 perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-base64-encode.js               : duk.O2.140  1.85 duk.O2.140nojson  1.88 duk.O2.131 17.52 duk.O2.125 17.18 duk.O2.113 17.30 duk.O2.102 17.28 mujs   n/a lua   n/a python 17.23 perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-bitwise-ops.js                 : duk.O2.140  0.75 duk.O2.140nojson  0.76 duk.O2.131  0.86 duk.O2.125  1.13 duk.O2.113  5.09 duk.O2.102  5.24 mujs  3.36 lua   n/a python   n/a perl   n/a ruby   n/a rhino  7.84 node  0.02 luajit   n/a
test-break-fast.js                  : duk.O2.140  1.67 duk.O2.140nojson  1.70 duk.O2.131  1.48 duk.O2.125  1.84 duk.O2.113  1.88 duk.O2.102  2.03 mujs  1.20 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.30 node  0.04 luajit   n/a
test-break-slow.js                  : duk.O2.140  7.72 duk.O2.140nojson  7.79 duk.O2.131 11.21 duk.O2.125 11.83 duk.O2.113 11.48 duk.O2.102 11.49 mujs  2.59 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.30 node  0.54 luajit   n/a
test-buffer-nodejs-read.js          : duk.O2.140  2.74 duk.O2.140nojson  2.78 duk.O2.131  2.60 duk.O2.125   n/a duk.O2.113   n/a duk.O2.102   n/a mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node  0.03 luajit   n/a
test-buffer-nodejs-write.js         : duk.O2.140  3.03 duk.O2.140nojson  3.05 duk.O2.131  3.29 duk.O2.125   n/a duk.O2.113   n/a duk.O2.102   n/a mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node  0.05 luajit   n/a
test-buffer-object-read.js          : duk.O2.140  2.89 duk.O2.140nojson  2.72 duk.O2.131  2.65 duk.O2.125 18.66 duk.O2.113 19.11 duk.O2.102 19.82 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-buffer-object-write.js         : duk.O2.140  3.03 duk.O2.140nojson  3.08 duk.O2.131  3.31 duk.O2.125 22.62 duk.O2.113 23.33 duk.O2.102 20.32 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-buffer-plain-read.js           : duk.O2.140  2.21 duk.O2.140nojson  2.26 duk.O2.131  2.16 duk.O2.125  2.46 duk.O2.113  2.72 duk.O2.102  2.75 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-buffer-plain-write.js          : duk.O2.140  1.90 duk.O2.140nojson  1.94 duk.O2.131  1.75 duk.O2.125  2.35 duk.O2.113  5.01 duk.O2.102  3.20 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-call-basic-1.js                : duk.O2.140  9.15 duk.O2.140nojson  9.01 duk.O2.131 12.00 duk.O2.125 12.23 duk.O2.113 14.31 duk.O2.102 13.99 mujs  6.56 lua  2.18 python  5.25 perl  7.77 ruby  3.39 rhino  1.39 node  0.03 luajit  0.00
test-call-basic-2.js                : duk.O2.140  9.11 duk.O2.140nojson  9.02 duk.O2.131 12.01 duk.O2.125 12.28 duk.O2.113 14.50 duk.O2.102 14.02 mujs  4.81 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.64 node  0.03 luajit   n/a
test-call-basic-3.js                : duk.O2.140 14.65 duk.O2.140nojson 14.60 duk.O2.131 20.00 duk.O2.125 19.97 duk.O2.113 21.23 duk.O2.102 21.22 mujs 12.42 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.61 node  0.12 luajit   n/a
test-call-basic-4.js                : duk.O2.140 35.17 duk.O2.140nojson 35.60 duk.O2.131 45.09 duk.O2.125 50.11 duk.O2.113 50.21 duk.O2.102 49.83 mujs 36.46 lua   n/a python   n/a perl   n/a ruby   n/a rhino  1.43 node  0.53 luajit   n/a
test-call-native.js                 : duk.O2.140 14.14 duk.O2.140nojson 13.59 duk.O2.131 18.82 duk.O2.125 18.70 duk.O2.113 20.75 duk.O2.102 20.50 mujs 17.13 lua   n/a python   n/a perl   n/a ruby   n/a rhino  1.47 node  3.71 luajit   n/a
test-compile-mandel-nofrac.js       : duk.O2.140 13.17 duk.O2.140nojson 13.04 duk.O2.131 13.68 duk.O2.125 16.89 duk.O2.113 18.41 duk.O2.102 18.25 mujs  5.87 lua   n/a python   n/a perl   n/a ruby   n/a rhino  7.10 node  0.04 luajit   n/a
test-compile-mandel.js              : duk.O2.140 16.22 duk.O2.140nojson 16.32 duk.O2.131 16.60 duk.O2.125 19.80 duk.O2.113 21.59 duk.O2.102 21.46 mujs  5.85 lua   n/a python   n/a perl   n/a ruby   n/a rhino  7.01 node  0.07 luajit   n/a
test-compile-short.js               : duk.O2.140  9.95 duk.O2.140nojson  9.98 duk.O2.131 10.13 duk.O2.125  9.99 duk.O2.113 10.97 duk.O2.102 10.62 mujs  2.11 lua   n/a python   n/a perl   n/a ruby   n/a rhino  3.64 node  0.17 luajit   n/a
test-continue-fast.js               : duk.O2.140  2.17 duk.O2.140nojson  2.22 duk.O2.131  1.95 duk.O2.125  2.51 duk.O2.113  2.70 duk.O2.102  2.81 mujs  1.96 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.51 node  0.05 luajit   n/a
test-continue-slow.js               : duk.O2.140  8.42 duk.O2.140nojson  8.44 duk.O2.131 11.78 duk.O2.125 12.52 duk.O2.113 12.43 duk.O2.102 12.52 mujs  3.35 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.54 node  0.57 luajit   n/a
test-empty-loop.js                  : duk.O2.140  2.29 duk.O2.140nojson  2.38 duk.O2.131  2.37 duk.O2.125  3.12 duk.O2.113  5.73 duk.O2.102  5.90 mujs  5.83 lua  1.00 python  4.57 perl  3.41 ruby  3.32 rhino  0.66 node  0.07 luajit  0.16
test-fib.js                         : duk.O2.140  7.90 duk.O2.140nojson  7.61 duk.O2.131  8.60 duk.O2.125  9.17 duk.O2.113  9.82 duk.O2.102  9.89 mujs  3.30 lua  1.33 python  2.41 perl  6.43 ruby  1.52 rhino  1.18 node  0.16 luajit  0.27
test-global-lookup.js               : duk.O2.140 10.71 duk.O2.140nojson 10.23 duk.O2.131 11.29 duk.O2.125 11.50 duk.O2.113 11.71 duk.O2.102 11.27 mujs  4.11 lua   n/a python   n/a perl   n/a ruby   n/a rhino  1.14 node  0.02 luajit   n/a
test-hello-world.js                 : duk.O2.140  0.00 duk.O2.140nojson  0.00 duk.O2.131  0.00 duk.O2.125  0.00 duk.O2.113  0.00 duk.O2.102  0.00 mujs  0.00 lua  0.00 python  0.00 perl  0.00 ruby  0.00 rhino  0.22 node  0.02 luajit  0.00
test-hex-decode.js                  : duk.O2.140  3.60 duk.O2.140nojson  3.61 duk.O2.131  5.34 duk.O2.125  5.32 duk.O2.113  9.38 duk.O2.102  9.36 mujs   n/a lua   n/a python 12.51 perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-hex-encode.js                  : duk.O2.140  2.80 duk.O2.140nojson  2.82 duk.O2.131  6.06 duk.O2.125  6.00 duk.O2.113  6.69 duk.O2.102  6.72 mujs   n/a lua   n/a python  1.43 perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-jc-serialize-indented.js       : duk.O2.140  3.64 duk.O2.140nojson 23.03 duk.O2.131 34.18 duk.O2.125 37.45 duk.O2.113 40.70 duk.O2.102 40.49 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-jc-serialize.js                : duk.O2.140  2.48 duk.O2.140nojson 20.93 duk.O2.131 28.54 duk.O2.125 31.37 duk.O2.113 34.76 duk.O2.102 36.39 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-json-parse-hex.js              : duk.O2.140  3.36 duk.O2.140nojson  3.38 duk.O2.131  6.61 duk.O2.125  6.64 duk.O2.113  8.33 duk.O2.102  8.33 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-json-parse-integer.js          : duk.O2.140  3.94 duk.O2.140nojson  4.01 duk.O2.131  4.06 duk.O2.125  4.09 duk.O2.113  4.06 duk.O2.102  4.12 mujs 20.95 lua   n/a python  0.07 perl   n/a ruby   n/a rhino  2.26 node  0.32 luajit   n/a
test-json-parse-number.js           : duk.O2.140  5.19 duk.O2.140nojson  5.21 duk.O2.131  5.10 duk.O2.125  5.04 duk.O2.113  5.25 duk.O2.102  5.27 mujs  2.46 lua   n/a python  0.29 perl   n/a ruby   n/a rhino  1.56 node  0.19 luajit   n/a
test-json-parse-string.js           : duk.O2.140  5.47 duk.O2.140nojson  5.69 duk.O2.131  5.62 duk.O2.125 30.08 duk.O2.113 30.04 duk.O2.102 30.01 mujs 44.72 lua   n/a python   n/a perl   n/a ruby   n/a rhino 22.48 node  6.08 luajit   n/a
test-json-serialize-fastpath-loop.js: duk.O2.140  3.64 duk.O2.140nojson 19.45 duk.O2.131 32.38 duk.O2.125 35.70 duk.O2.113 40.51 duk.O2.102 38.37 mujs 12.57 lua   n/a python   n/a perl   n/a ruby   n/a rhino 111.97 node 32.99 luajit   n/a
test-json-serialize-hex.js          : duk.O2.140  1.45 duk.O2.140nojson  1.49 duk.O2.131  2.78 duk.O2.125 24.35 duk.O2.113 23.75 duk.O2.102 22.47 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-json-serialize-indented-deep100.js: duk.O2.140  2.39 duk.O2.140nojson  2.30 duk.O2.131  3.62 duk.O2.125  3.82 duk.O2.113  3.89 duk.O2.102  3.87 mujs  1.43 lua   n/a python   n/a perl   n/a ruby   n/a rhino 40.94 node  1.05 luajit   n/a
test-json-serialize-indented-deep25.js: duk.O2.140  3.30 duk.O2.140nojson 27.25 duk.O2.131 44.80 duk.O2.125 47.44 duk.O2.113 50.61 duk.O2.102 48.59 mujs 10.29 lua   n/a python   n/a perl   n/a ruby   n/a rhino 61.10 node 13.91 luajit   n/a
test-json-serialize-indented-deep500.js: duk.O2.140  1.45 duk.O2.140nojson  1.44 duk.O2.131  2.37 duk.O2.125  2.44 duk.O2.113  2.49 duk.O2.102  2.41 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino 1246.26 node  0.52 luajit   n/a
test-json-serialize-indented.js     : duk.O2.140  6.25 duk.O2.140nojson 46.83 duk.O2.131 69.94 duk.O2.125 76.16 duk.O2.113 82.02 duk.O2.102 82.05 mujs 14.79 lua   n/a python   n/a perl   n/a ruby   n/a rhino 25.46 node 23.71 luajit   n/a
test-json-serialize-jsonrpc-message.js: duk.O2.140  1.97 duk.O2.140nojson  2.52 duk.O2.131  3.97 duk.O2.125  7.85 duk.O2.113  8.02 duk.O2.102  7.75 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-json-serialize-nofrac.js       : duk.O2.140  0.69 duk.O2.140nojson  4.83 duk.O2.131  0.69 duk.O2.125  6.98 duk.O2.113  7.44 duk.O2.102  7.29 mujs  1.55 lua   n/a python   n/a perl   n/a ruby   n/a rhino  4.14 node  0.61 luajit   n/a
test-json-serialize-slowpath-loop.js: duk.O2.140  5.81 duk.O2.140nojson  5.75 duk.O2.131  8.58 duk.O2.125  9.44 duk.O2.113 10.30 duk.O2.102 10.03 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino 11.92 node  2.97 luajit   n/a
test-json-serialize.js              : duk.O2.140  6.24 duk.O2.140nojson 10.39 duk.O2.131  6.30 duk.O2.125 12.47 duk.O2.113 12.90 duk.O2.102 12.70 mujs  2.17 lua   n/a python  0.51 perl   n/a ruby   n/a rhino  5.40 node  0.70 luajit   n/a
test-json-string-bench.js           : duk.O2.140  5.26 duk.O2.140nojson  5.25 duk.O2.131  5.46 duk.O2.125  5.42 duk.O2.113  6.72 duk.O2.102  6.57 mujs 51.06 lua   n/a python   n/a perl   n/a ruby   n/a rhino  1.98 node  0.25 luajit   n/a
test-json-string-stringify.js       : duk.O2.140  5.14 duk.O2.140nojson  5.19 duk.O2.131  6.47 duk.O2.125 17.75 duk.O2.113 17.82 duk.O2.102 17.09 mujs 10.72 lua   n/a python  0.48 perl   n/a ruby   n/a rhino 18.39 node  5.98 luajit   n/a
test-jx-serialize-indented.js       : duk.O2.140  3.72 duk.O2.140nojson 22.64 duk.O2.131 34.09 duk.O2.125 36.06 duk.O2.113 39.81 duk.O2.102 39.56 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-jx-serialize.js                : duk.O2.140  2.51 duk.O2.140nojson 20.96 duk.O2.131 28.32 duk.O2.125 30.44 duk.O2.113 34.09 duk.O2.102 33.28 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-mandel.js                      : duk.O2.140  4.36 duk.O2.140nojson  4.34 duk.O2.131  4.75 duk.O2.125  5.88 duk.O2.113  6.34 duk.O2.102  6.71 mujs 13.92 lua   n/a python   n/a perl   n/a ruby   n/a rhino  1.60 node  0.21 luajit   n/a
test-prop-read.js                   : duk.O2.140  4.89 duk.O2.140nojson  4.80 duk.O2.131  5.25 duk.O2.125  6.18 duk.O2.113  6.43 duk.O2.102  6.50 mujs  3.76 lua  1.03 python  2.44 perl  4.85 ruby 11.16 rhino  0.67 node  0.02 luajit  0.00
test-prop-write.js                  : duk.O2.140  4.28 duk.O2.140nojson  4.21 duk.O2.131  4.44 duk.O2.125  4.86 duk.O2.113  5.68 duk.O2.102  4.79 mujs  3.73 lua  1.16 python  2.45 perl  4.96 ruby 14.77 rhino  1.90 node  0.03 luajit  0.00
test-reg-readwrite-object.js        : duk.O2.140  3.31 duk.O2.140nojson  3.22 duk.O2.131  7.79 duk.O2.125 10.93 duk.O2.113  7.18 duk.O2.102  7.48 mujs  7.81 lua  1.75 python  4.80 perl 29.30 ruby  4.00 rhino  0.36 node  0.02 luajit  0.00
test-reg-readwrite-plain.js         : duk.O2.140  2.07 duk.O2.140nojson  2.06 duk.O2.131  5.07 duk.O2.125  9.42 duk.O2.113  4.90 duk.O2.102  4.94 mujs  7.75 lua  1.76 python  4.79 perl 32.32 ruby  4.03 rhino  0.38 node  0.01 luajit  0.00
test-regexp-case-insensitive.js     : duk.O2.140 23.44 duk.O2.140nojson 23.42 duk.O2.131 23.37 duk.O2.125 23.50 duk.O2.113 24.28 duk.O2.102 24.39 mujs  0.00 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.23 node  0.01 luajit   n/a
test-regexp-string-parse.js         : duk.O2.140  9.75 duk.O2.140nojson  9.52 duk.O2.131 10.66 duk.O2.125 12.83 duk.O2.113 12.68 duk.O2.102 12.74 mujs   n/a lua   n/a python  0.51 perl   n/a ruby   n/a rhino   n/a node  0.08 luajit   n/a
test-string-array-concat.js         : duk.O2.140  6.68 duk.O2.140nojson  6.79 duk.O2.131  6.49 duk.O2.125  7.83 duk.O2.113 24.22 duk.O2.102 23.52 mujs 261.36 lua  2.11 python  2.84 perl  7.44 ruby  7.84 rhino  1.99 node  0.39 luajit  0.86
test-string-charlen-ascii.js        : duk.O2.140  1.36 duk.O2.140nojson  1.39 duk.O2.131  5.31 duk.O2.125  5.32 duk.O2.113  5.33 duk.O2.102  5.33 mujs  4.70 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.35 node  0.02 luajit   n/a
test-string-charlen-nonascii.js     : duk.O2.140  2.82 duk.O2.140nojson  2.80 duk.O2.131  3.92 duk.O2.125  3.94 duk.O2.113  3.95 duk.O2.102  3.96 mujs  7.14 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.34 node  0.02 luajit   n/a
test-string-compare.js              : duk.O2.140  3.91 duk.O2.140nojson  3.82 duk.O2.131  3.82 duk.O2.125  4.61 duk.O2.113  6.08 duk.O2.102  6.11 mujs 731.42 lua  2.81 python  4.89 perl 16.51 ruby  5.37 rhino  4.43 node  0.87 luajit  0.13
test-string-decodeuri.js            : duk.O2.140  3.59 duk.O2.140nojson  3.59 duk.O2.131  3.58 duk.O2.125  4.15 duk.O2.113  4.08 duk.O2.102  4.16 mujs  2.07 lua   n/a python   n/a perl   n/a ruby   n/a rhino  2.11 node  3.90 luajit   n/a
test-string-encodeuri.js            : duk.O2.140  4.09 duk.O2.140nojson  4.07 duk.O2.131  4.28 duk.O2.125  6.23 duk.O2.113  6.31 duk.O2.102  6.24 mujs  3.63 lua   n/a python   n/a perl   n/a ruby   n/a rhino  6.91 node 40.88 luajit   n/a
test-string-intern-grow-short.js    : duk.O2.140 20.92 duk.O2.140nojson 20.74 duk.O2.131  7.18 duk.O2.125  7.73 duk.O2.113 13.37 duk.O2.102 12.34 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-grow-short2.js   : duk.O2.140  7.35 duk.O2.140nojson  7.35 duk.O2.131  7.27 duk.O2.125  7.81 duk.O2.113 13.32 duk.O2.102 12.45 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-grow.js          : duk.O2.140 39.22 duk.O2.140nojson 39.43 duk.O2.131  4.98 duk.O2.125  4.93 duk.O2.113  5.57 duk.O2.102  5.56 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-grow2.js         : duk.O2.140  3.38 duk.O2.140nojson  3.23 duk.O2.131  5.09 duk.O2.125  5.17 duk.O2.113  5.79 duk.O2.102  5.76 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-match-short.js   : duk.O2.140  2.72 duk.O2.140nojson  2.75 duk.O2.131  2.29 duk.O2.125  2.35 duk.O2.113  2.39 duk.O2.102  2.36 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-match.js         : duk.O2.140  0.36 duk.O2.140nojson  0.36 duk.O2.131  0.96 duk.O2.125  1.00 duk.O2.113  1.03 duk.O2.102  1.03 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-miss-short.js    : duk.O2.140  5.55 duk.O2.140nojson  5.67 duk.O2.131  5.11 duk.O2.125  5.23 duk.O2.113  5.50 duk.O2.102  5.52 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-intern-miss.js          : duk.O2.140  1.27 duk.O2.140nojson  1.27 duk.O2.131  2.53 duk.O2.125  2.59 duk.O2.113  2.80 duk.O2.102  2.75 mujs   n/a lua   n/a python   n/a perl   n/a ruby   n/a rhino   n/a node   n/a luajit   n/a
test-string-plain-concat.js         : duk.O2.140  1.04 duk.O2.140nojson  1.07 duk.O2.131  4.13 duk.O2.125  4.16 duk.O2.113  4.26 duk.O2.102  4.15 mujs  1.03 lua  0.60 python  0.00 perl  0.41 ruby  0.81 rhino  0.30 node  0.02 luajit  0.63
test-string-uppercase.js            : duk.O2.140  2.21 duk.O2.140nojson  2.22 duk.O2.131  2.65 duk.O2.125  3.54 duk.O2.113  3.35 duk.O2.102  3.48 mujs  4.50 lua   n/a python  1.28 perl   n/a ruby   n/a rhino  1.67 node  0.09 luajit   n/a
test-try-catch-nothrow.js           : duk.O2.140  3.05 duk.O2.140nojson  3.04 duk.O2.131  2.57 duk.O2.125  2.76 duk.O2.113  2.39 duk.O2.102  2.45 mujs  2.22 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.30 node  0.33 luajit   n/a
test-try-catch-throw.js             : duk.O2.140 41.50 duk.O2.140nojson 39.62 duk.O2.131 39.86 duk.O2.125 39.99 duk.O2.113 39.29 duk.O2.102 38.20 mujs 20.53 lua   n/a python   n/a perl   n/a ruby   n/a rhino 133.42 node  8.02 luajit   n/a
test-try-finally-nothrow.js         : duk.O2.140  3.63 duk.O2.140nojson  3.68 duk.O2.131  2.81 duk.O2.125  3.32 duk.O2.113  3.12 duk.O2.102  3.18 mujs  2.06 lua   n/a python   n/a perl   n/a ruby   n/a rhino  0.32 node  0.54 luajit   n/a
test-try-finally-throw.js           : duk.O2.140 51.09 duk.O2.140nojson 49.40 duk.O2.131 46.12 duk.O2.125 45.92 duk.O2.113 45.58 duk.O2.102 45.41 mujs 22.90 lua   n/a python   n/a perl   n/a ruby   n/a rhino 130.83 node 10.05 luajit   n/a
```
