# Duktape 2.0.0 performance measurement

## Performance summary

<table>
<tr><th></th><th>duk-perf.O2.200</th><th>duk.O2.200</th><th>duk.O2.150</th><th>mujs</th><th>jerry</th><th>lua</th><th>python</th><th>perl</th><th>ruby</th></tr>
<tr><td>test-add-fastint.js</td><td>0.55</td><td>0.65</td><td>0.88</td><td>4.04</td><td>2.55</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-add-float.js</td><td>0.56</td><td>0.71</td><td>0.85</td><td>4.04</td><td>3.87</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-add-nan-fastint.js</td><td>0.63</td><td>0.77</td><td>0.99</td><td>4.04</td><td>3.14</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-add-nan.js</td><td>0.55</td><td>0.64</td><td>0.82</td><td>4.03</td><td>3.86</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-arith-add.js</td><td>2.24</td><td>2.58</td><td>3.30</td><td>15.93</td><td>15.35</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-arith-div.js</td><td>6.95</td><td>7.28</td><td>8.23</td><td>11.17</td><td>19.73</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-arith-mod.js</td><td>6.32</td><td>6.66</td><td>7.84</td><td>13.40</td><td>23.35</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-arith-mul.js</td><td>3.35</td><td>3.66</td><td>4.37</td><td>10.98</td><td>15.89</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-arith-sub.js</td><td>2.33</td><td>2.74</td><td>3.56</td><td>11.09</td><td>15.83</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-append.js</td><td>0.53</td><td>0.53</td><td>0.72</td><td>43.56</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-cons-list.js</td><td>0.81</td><td>0.92</td><td>2.33</td><td>8.18</td><td>2.10</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-foreach.js</td><td>2.52</td><td>2.70</td><td>2.73</td><td>2.82</td><td>1.53</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-literal.js</td><td>1.49</td><td>1.58</td><td>1.80</td><td>54.91</td><td>0.84</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-pop.js</td><td>2.13</td><td>2.21</td><td>7.35</td><td>46.67</td><td>6.71</td><td>1.10</td><td>0.88</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-push.js</td><td>2.40</td><td>2.54</td><td>4.93</td><td>7.85</td><td>3.63</td><td>0.99</td><td>0.52</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-read-lenloop.js</td><td>1.75</td><td>1.88</td><td>2.68</td><td>113.66</td><td>3.94</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-read.js</td><td>1.66</td><td>1.73</td><td>2.10</td><td>216.37</td><td>4.98</td><td>0.94</td><td>1.73</td><td>3.23</td><td>1.44</td></tr>
<tr><td>test-array-sort.js</td><td>3.57</td><td>3.49</td><td>3.46</td><td>n/a</td><td>3.73</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-write-length.js</td><td>1.49</td><td>1.70</td><td>2.83</td><td>3.37</td><td>2.52</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-array-write.js</td><td>1.66</td><td>1.78</td><td>2.64</td><td>233.38</td><td>5.71</td><td>1.13</td><td>2.48</td><td>3.22</td><td>4.02</td></tr>
<tr><td>test-assign-add.js</td><td>3.32</td><td>3.74</td><td>5.21</td><td>34.13</td><td>22.74</td><td>3.19</td><td>13.84</td><td>24.98</td><td>10.17</td></tr>
<tr><td>test-assign-addto-nan.js</td><td>1.01</td><td>1.25</td><td>1.59</td><td>7.38</td><td>5.56</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-addto.js</td><td>3.34</td><td>3.67</td><td>5.29</td><td>34.43</td><td>27.36</td><td>3.25</td><td>16.20</td><td>24.07</td><td>10.21</td></tr>
<tr><td>test-assign-boolean.js</td><td>4.69</td><td>4.68</td><td>4.84</td><td>9.44</td><td>19.35</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-const-int.js</td><td>1.93</td><td>2.53</td><td>2.57</td><td>9.65</td><td>11.07</td><td>2.10</td><td>5.53</td><td>22.37</td><td>4.02</td></tr>
<tr><td>test-assign-const-int2.js</td><td>3.92</td><td>5.77</td><td>9.00</td><td>9.61</td><td>11.08</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-const.js</td><td>3.29</td><td>4.28</td><td>4.28</td><td>9.86</td><td>15.58</td><td>2.14</td><td>5.46</td><td>22.73</td><td>4.06</td></tr>
<tr><td>test-assign-literal.js</td><td>3.33</td><td>3.75</td><td>4.21</td><td>9.97</td><td>21.68</td><td>2.60</td><td>12.04</td><td>n/a</td><td>4.46</td></tr>
<tr><td>test-assign-proplhs-reg.js</td><td>2.47</td><td>2.67</td><td>3.74</td><td>2.41</td><td>4.91</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-proprhs.js</td><td>2.63</td><td>2.92</td><td>4.25</td><td>2.51</td><td>3.54</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-assign-reg.js</td><td>2.46</td><td>2.84</td><td>2.79</td><td>8.90</td><td>14.84</td><td>2.26</td><td>5.75</td><td>23.32</td><td>4.08</td></tr>
<tr><td>test-base64-decode-whitespace.js</td><td>1.89</td><td>1.88</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>8.73</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-base64-decode.js</td><td>1.53</td><td>1.53</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>8.69</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-base64-encode.js</td><td>1.68</td><td>1.68</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>17.08</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-bitwise-ops.js</td><td>1.53</td><td>1.89</td><td>2.61</td><td>14.40</td><td>21.07</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-break-fast.js</td><td>1.30</td><td>1.52</td><td>1.61</td><td>1.22</td><td>1.14</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-break-slow.js</td><td>6.76</td><td>7.43</td><td>8.00</td><td>2.55</td><td>4.15</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-nodejs-read.js</td><td>2.10</td><td>2.31</td><td>2.64</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-nodejs-write.js</td><td>2.79</td><td>3.03</td><td>3.14</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-object-read.js</td><td>2.09</td><td>2.30</td><td>2.60</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-object-write.js</td><td>2.79</td><td>3.05</td><td>3.15</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-plain-read.js</td><td>1.73</td><td>1.89</td><td>2.25</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-buffer-plain-write.js</td><td>1.72</td><td>1.79</td><td>1.82</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-basic-1.js</td><td>7.29</td><td>7.72</td><td>9.25</td><td>6.53</td><td>9.09</td><td>2.23</td><td>5.29</td><td>7.87</td><td>3.40</td></tr>
<tr><td>test-call-basic-2.js</td><td>7.41</td><td>7.73</td><td>9.21</td><td>4.90</td><td>8.18</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-basic-3.js</td><td>9.09</td><td>9.77</td><td>15.00</td><td>12.43</td><td>14.31</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-basic-4.js</td><td>16.02</td><td>17.89</td><td>37.31</td><td>34.48</td><td>35.17</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-native.js</td><td>12.44</td><td>13.39</td><td>13.92</td><td>17.19</td><td>7.69</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-prop.js</td><td>3.99</td><td>4.22</td><td>5.78</td><td>2.87</td><td>4.13</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-reg-new.js</td><td>6.28</td><td>6.40</td><td>6.70</td><td>2.73</td><td>3.22</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-reg.js</td><td>2.83</td><td>3.00</td><td>3.60</td><td>2.28</td><td>3.36</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-call-var.js</td><td>7.77</td><td>8.26</td><td>8.05</td><td>4.36</td><td>3.79</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-compile-mandel-nofrac.js</td><td>10.90</td><td>10.69</td><td>13.29</td><td>5.90</td><td>2.22</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-compile-mandel.js</td><td>13.96</td><td>13.72</td><td>16.50</td><td>5.84</td><td>2.24</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-compile-short.js</td><td>6.38</td><td>6.80</td><td>9.88</td><td>2.11</td><td>0.86</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-compile-string-ascii.js</td><td>6.66</td><td>6.70</td><td>9.17</td><td>6.32</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-continue-fast.js</td><td>1.68</td><td>1.84</td><td>2.23</td><td>1.96</td><td>2.20</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-continue-slow.js</td><td>7.49</td><td>7.88</td><td>8.35</td><td>3.32</td><td>5.91</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-empty-loop-slowpath.js</td><td>1.49</td><td>1.68</td><td>2.01</td><td>0.99</td><td>0.68</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-empty-loop.js</td><td>1.62</td><td>1.65</td><td>2.27</td><td>5.87</td><td>3.16</td><td>1.00</td><td>4.54</td><td>3.44</td><td>3.34</td></tr>
<tr><td>test-enum-basic.js</td><td>3.98</td><td>3.99</td><td>4.53</td><td>0.68</td><td>1.06</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-equals-fastint.js</td><td>0.51</td><td>0.61</td><td>1.17</td><td>2.37</td><td>2.87</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-equals-nonfastint.js</td><td>0.51</td><td>0.62</td><td>1.23</td><td>2.35</td><td>3.93</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-error-create.js</td><td>2.13</td><td>2.12</td><td>3.31</td><td>4.76</td><td>0.80</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-fib.js</td><td>6.32</td><td>6.96</td><td>7.78</td><td>3.30</td><td>4.98</td><td>1.40</td><td>2.45</td><td>6.45</td><td>1.54</td></tr>
<tr><td>test-global-lookup.js</td><td>7.80</td><td>7.87</td><td>10.26</td><td>4.15</td><td>2.20</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-hello-world.js</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td></tr>
<tr><td>test-hex-decode.js</td><td>3.59</td><td>3.65</td><td>3.68</td><td>n/a</td><td>n/a</td><td>n/a</td><td>12.71</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-hex-encode.js</td><td>2.81</td><td>2.82</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>1.42</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jc-serialize-indented.js</td><td>3.33</td><td>3.40</td><td>3.56</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jc-serialize.js</td><td>2.09</td><td>2.22</td><td>2.46</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-hex.js</td><td>3.16</td><td>3.23</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-integer.js</td><td>3.93</td><td>3.82</td><td>4.08</td><td>21.09</td><td>n/a</td><td>n/a</td><td>0.07</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-number.js</td><td>5.23</td><td>5.15</td><td>5.23</td><td>2.41</td><td>n/a</td><td>n/a</td><td>0.29</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-parse-string.js</td><td>5.57</td><td>5.82</td><td>5.80</td><td>45.21</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-fastpath-loop.js</td><td>3.66</td><td>3.61</td><td>3.61</td><td>12.61</td><td>532.24</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-forceslow.js</td><td>9.70</td><td>9.08</td><td>11.19</td><td>2.19</td><td>8.86</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-hex.js</td><td>1.44</td><td>1.49</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep100.js</td><td>1.77</td><td>1.77</td><td>2.45</td><td>1.52</td><td>135.92</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep25.js</td><td>3.11</td><td>3.25</td><td>3.31</td><td>10.34</td><td>240.02</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented-deep500.js</td><td>1.24</td><td>1.17</td><td>1.57</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-indented.js</td><td>5.80</td><td>5.91</td><td>6.34</td><td>14.83</td><td>106.53</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-jsonrpc-message.js</td><td>1.98</td><td>1.97</td><td>1.99</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-nofrac.js</td><td>0.59</td><td>0.61</td><td>0.67</td><td>1.56</td><td>7.26</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize-slowpath-loop.js</td><td>4.27</td><td>4.28</td><td>6.04</td><td>n/a</td><td>6.08</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-serialize.js</td><td>6.25</td><td>5.87</td><td>6.18</td><td>2.20</td><td>8.78</td><td>n/a</td><td>0.51</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-string-bench.js</td><td>3.41</td><td>3.49</td><td>5.29</td><td>49.96</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-json-string-stringify.js</td><td>5.12</td><td>5.17</td><td>5.19</td><td>10.73</td><td>n/a</td><td>n/a</td><td>0.48</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-bufobj-forceslow.js</td><td>4.66</td><td>4.83</td><td>5.61</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-bufobj.js</td><td>1.50</td><td>1.57</td><td>1.65</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize-indented.js</td><td>3.20</td><td>3.40</td><td>3.50</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-jx-serialize.js</td><td>2.15</td><td>2.23</td><td>2.44</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-mandel.js</td><td>2.48</td><td>2.98</td><td>4.36</td><td>13.94</td><td>13.15</td><td>1.60</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-object-garbage-2.js</td><td>4.71</td><td>4.91</td><td>4.87</td><td>49.95</td><td>2.59</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-object-garbage.js</td><td>4.47</td><td>4.51</td><td>4.37</td><td>2.37</td><td>2.76</td><td>3.44</td><td>0.66</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-object-literal.js</td><td>2.80</td><td>2.88</td><td>2.54</td><td>3.89</td><td>2.28</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-read-4.js</td><td>3.14</td><td>3.52</td><td>4.75</td><td>3.65</td><td>3.95</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-read-8.js</td><td>3.27</td><td>3.83</td><td>4.96</td><td>4.52</td><td>3.93</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-read.js</td><td>3.15</td><td>3.64</td><td>4.80</td><td>3.81</td><td>3.94</td><td>1.08</td><td>2.37</td><td>4.89</td><td>11.20</td></tr>
<tr><td>test-prop-write-1024.js</td><td>3.73</td><td>3.33</td><td>5.12</td><td>9.93</td><td>4.48</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-16.js</td><td>3.18</td><td>3.78</td><td>4.58</td><td>4.48</td><td>4.49</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-256.js</td><td>3.35</td><td>3.92</td><td>4.96</td><td>8.36</td><td>4.68</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-32.js</td><td>3.82</td><td>3.44</td><td>6.82</td><td>5.55</td><td>4.66</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-4.js</td><td>2.87</td><td>3.13</td><td>4.37</td><td>3.75</td><td>4.68</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-48.js</td><td>5.56</td><td>4.62</td><td>5.40</td><td>6.62</td><td>4.61</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-64.js</td><td>4.41</td><td>4.15</td><td>4.97</td><td>6.75</td><td>4.75</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write-8.js</td><td>3.09</td><td>3.53</td><td>4.50</td><td>4.66</td><td>4.65</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-prop-write.js</td><td>2.92</td><td>3.23</td><td>4.39</td><td>3.89</td><td>4.65</td><td>1.22</td><td>2.56</td><td>5.12</td><td>15.57</td></tr>
<tr><td>test-random.js</td><td>2.20</td><td>2.30</td><td>6.49</td><td>1.06</td><td>1.93</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-reg-readwrite-object.js</td><td>3.00</td><td>3.09</td><td>3.21</td><td>7.80</td><td>13.44</td><td>1.77</td><td>n/a</td><td>29.13</td><td>3.97</td></tr>
<tr><td>test-reg-readwrite-plain.js</td><td>1.78</td><td>2.03</td><td>2.05</td><td>7.73</td><td>10.82</td><td>1.73</td><td>4.83</td><td>30.80</td><td>4.00</td></tr>
<tr><td>test-regexp-case-insensitive.js</td><td>0.00</td><td>24.82</td><td>24.51</td><td>0.00</td><td>0.00</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-regexp-compile.js</td><td>2.14</td><td>2.17</td><td>2.69</td><td>1.50</td><td>0.43</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-regexp-execute.js</td><td>1.54</td><td>1.49</td><td>1.89</td><td>1.57</td><td>1.08</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-regexp-string-parse.js</td><td>5.94</td><td>5.99</td><td>9.70</td><td>n/a</td><td>n/a</td><td>n/a</td><td>0.51</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-strict-equals-fastint.js</td><td>0.49</td><td>0.58</td><td>1.17</td><td>2.45</td><td>3.04</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-strict-equals-nonfastint.js</td><td>0.57</td><td>0.63</td><td>1.24</td><td>2.43</td><td>3.84</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-array-concat.js</td><td>5.43</td><td>5.52</td><td>6.67</td><td>256.24</td><td>n/a</td><td>2.11</td><td>2.84</td><td>7.56</td><td>7.90</td></tr>
<tr><td>test-string-charlen-ascii.js</td><td>1.12</td><td>1.07</td><td>1.34</td><td>4.72</td><td>0.75</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-charlen-nonascii.js</td><td>2.65</td><td>2.67</td><td>2.82</td><td>7.11</td><td>0.50</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-compare.js</td><td>1.85</td><td>2.13</td><td>3.84</td><td>769.37</td><td>n/a</td><td>2.82</td><td>4.93</td><td>16.59</td><td>5.43</td></tr>
<tr><td>test-string-decodeuri.js</td><td>3.61</td><td>3.60</td><td>3.72</td><td>2.13</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-encodeuri.js</td><td>4.06</td><td>4.05</td><td>4.04</td><td>3.61</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-garbage.js</td><td>5.15</td><td>4.94</td><td>5.38</td><td>1.72</td><td>1.81</td><td>1.54</td><td>1.49</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow-short.js</td><td>11.74</td><td>11.57</td><td>11.91</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow-short2.js</td><td>4.61</td><td>4.59</td><td>5.00</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow.js</td><td>20.53</td><td>20.26</td><td>19.92</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-grow2.js</td><td>1.79</td><td>1.79</td><td>1.79</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-match-short.js</td><td>2.59</td><td>2.64</td><td>2.50</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-match.js</td><td>0.22</td><td>0.23</td><td>0.26</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-miss-short.js</td><td>2.97</td><td>3.09</td><td>3.28</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-intern-miss.js</td><td>1.14</td><td>1.20</td><td>1.19</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-string-plain-concat.js</td><td>0.89</td><td>0.86</td><td>1.09</td><td>1.03</td><td>0.52</td><td>0.63</td><td>0.00</td><td>0.40</td><td>0.77</td></tr>
<tr><td>test-string-uppercase.js</td><td>2.32</td><td>2.21</td><td>2.23</td><td>4.48</td><td>n/a</td><td>n/a</td><td>1.27</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-textdecoder-ascii.js</td><td>2.84</td><td>2.79</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-textdecoder-nonascii.js</td><td>2.79</td><td>2.77</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-textencoder-ascii.js</td><td>3.98</td><td>4.19</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-textencoder-nonascii.js</td><td>11.27</td><td>11.21</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-try-catch-nothrow.js</td><td>2.65</td><td>2.59</td><td>2.93</td><td>2.21</td><td>3.18</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-try-catch-throw.js</td><td>37.57</td><td>38.32</td><td>38.83</td><td>20.59</td><td>14.89</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-try-finally-nothrow.js</td><td>2.97</td><td>3.39</td><td>3.71</td><td>2.06</td><td>3.63</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
<tr><td>test-try-finally-throw.js</td><td>47.16</td><td>48.88</td><td>48.66</td><td>22.93</td><td>17.85</td><td>n/a</td><td>n/a</td><td>n/a</td><td>n/a</td></tr>
</table>

## Setup

Measurement host:

* "Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz" laptop

Duktape is compiled with:

* gcc-4.8.4 (Ubuntu 14.04.3) on x64
* `gcc -O2`
* duk.O2: defaults + debugger and executor interrupt enabled, fastints enabled
* duk-perf.O2: performance-sensitive.yaml as baseline, no debugger or executor interrupt support, fastints enabled

Note that:

* These are microbenchmarks, and don't necessarily represent application
  performance very well.  Microbenchmarks are useful for measuring how well
  different parts of the engine work.

* Only relative numbers matter.  Loop counts differ between test cases so
  the numbers for two tests are not directly comparable.  Absolute numbers
  may also change between test runs if test target is different.

* The measurement process is not very accurate: it's based on running the
  test multiple times and measuring time using the `time` command.
