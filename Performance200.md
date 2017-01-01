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

## Raw results

```
for i in tests/perf/*.js; do \
		printf '%-36s:' "`basename $i`"; \
		printf ' duk-perf.O2.200 %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  ./duk-perf.O2.200 $i`"; \
		printf ' duk.O2.200 %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  ./duk.O2.200 $i`"; \
		printf ' duk.O2.150 %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  ./duk.O2.150 $i`"; \
		printf ' mujs %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  mujs $i`"; \
		printf ' jerry %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  jerry $i`"; \
		printf ' lua %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  lua ${i%%.js}.lua`"; \
		printf ' python %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  /usr/bin/python2 ${i%%.js}.py`"; \
		printf ' perl %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  perl ${i%%.js}.pl`"; \
		printf ' ruby %5s' "`/usr/bin/python2 util/time_multi.py --count 4 --sleep 0 --sleep-factor 2.0 --mode min  ruby ${i%%.js}.rb`"; \
		printf '\n'; \
	done
test-add-fastint.js                 : duk-perf.O2.200  0.55 duk.O2.200  0.65 duk.O2.150  0.88 mujs  4.04 jerry  2.55 lua   n/a python   n/a perl   n/a ruby   n/a
test-add-float.js                   : duk-perf.O2.200  0.56 duk.O2.200  0.71 duk.O2.150  0.85 mujs  4.04 jerry  3.87 lua   n/a python   n/a perl   n/a ruby   n/a
test-add-nan-fastint.js             : duk-perf.O2.200  0.63 duk.O2.200  0.77 duk.O2.150  0.99 mujs  4.04 jerry  3.14 lua   n/a python   n/a perl   n/a ruby   n/a
test-add-nan.js                     : duk-perf.O2.200  0.55 duk.O2.200  0.64 duk.O2.150  0.82 mujs  4.03 jerry  3.86 lua   n/a python   n/a perl   n/a ruby   n/a
test-arith-add.js                   : duk-perf.O2.200  2.24 duk.O2.200  2.58 duk.O2.150  3.30 mujs 15.93 jerry 15.35 lua   n/a python   n/a perl   n/a ruby   n/a
test-arith-div.js                   : duk-perf.O2.200  6.95 duk.O2.200  7.28 duk.O2.150  8.23 mujs 11.17 jerry 19.73 lua   n/a python   n/a perl   n/a ruby   n/a
test-arith-mod.js                   : duk-perf.O2.200  6.32 duk.O2.200  6.66 duk.O2.150  7.84 mujs 13.40 jerry 23.35 lua   n/a python   n/a perl   n/a ruby   n/a
test-arith-mul.js                   : duk-perf.O2.200  3.35 duk.O2.200  3.66 duk.O2.150  4.37 mujs 10.98 jerry 15.89 lua   n/a python   n/a perl   n/a ruby   n/a
test-arith-sub.js                   : duk-perf.O2.200  2.33 duk.O2.200  2.74 duk.O2.150  3.56 mujs 11.09 jerry 15.83 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-append.js                : duk-perf.O2.200  0.53 duk.O2.200  0.53 duk.O2.150  0.72 mujs 43.56 jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-array-cons-list.js             : duk-perf.O2.200  0.81 duk.O2.200  0.92 duk.O2.150  2.33 mujs  8.18 jerry  2.10 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-foreach.js               : duk-perf.O2.200  2.52 duk.O2.200  2.70 duk.O2.150  2.73 mujs  2.82 jerry  1.53 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-literal.js               : duk-perf.O2.200  1.49 duk.O2.200  1.58 duk.O2.150  1.80 mujs 54.91 jerry  0.84 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-pop.js                   : duk-perf.O2.200  2.13 duk.O2.200  2.21 duk.O2.150  7.35 mujs 46.67 jerry  6.71 lua  1.10 python  0.88 perl   n/a ruby   n/a
test-array-push.js                  : duk-perf.O2.200  2.40 duk.O2.200  2.54 duk.O2.150  4.93 mujs  7.85 jerry  3.63 lua  0.99 python  0.52 perl   n/a ruby   n/a
test-array-read-lenloop.js          : duk-perf.O2.200  1.75 duk.O2.200  1.88 duk.O2.150  2.68 mujs 113.66 jerry  3.94 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-read.js                  : duk-perf.O2.200  1.66 duk.O2.200  1.73 duk.O2.150  2.10 mujs 216.37 jerry  4.98 lua  0.94 python  1.73 perl  3.23 ruby  1.44
test-array-sort.js                  : duk-perf.O2.200  3.57 duk.O2.200  3.49 duk.O2.150  3.46 mujs   n/a jerry  3.73 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-write-length.js          : duk-perf.O2.200  1.49 duk.O2.200  1.70 duk.O2.150  2.83 mujs  3.37 jerry  2.52 lua   n/a python   n/a perl   n/a ruby   n/a
test-array-write.js                 : duk-perf.O2.200  1.66 duk.O2.200  1.78 duk.O2.150  2.64 mujs 233.38 jerry  5.71 lua  1.13 python  2.48 perl  3.22 ruby  4.02
test-assign-add.js                  : duk-perf.O2.200  3.32 duk.O2.200  3.74 duk.O2.150  5.21 mujs 34.13 jerry 22.74 lua  3.19 python 13.84 perl 24.98 ruby 10.17
test-assign-addto-nan.js            : duk-perf.O2.200  1.01 duk.O2.200  1.25 duk.O2.150  1.59 mujs  7.38 jerry  5.56 lua   n/a python   n/a perl   n/a ruby   n/a
test-assign-addto.js                : duk-perf.O2.200  3.34 duk.O2.200  3.67 duk.O2.150  5.29 mujs 34.43 jerry 27.36 lua  3.25 python 16.20 perl 24.07 ruby 10.21
test-assign-boolean.js              : duk-perf.O2.200  4.69 duk.O2.200  4.68 duk.O2.150  4.84 mujs  9.44 jerry 19.35 lua   n/a python   n/a perl   n/a ruby   n/a
test-assign-const-int.js            : duk-perf.O2.200  1.93 duk.O2.200  2.53 duk.O2.150  2.57 mujs  9.65 jerry 11.07 lua  2.10 python  5.53 perl 22.37 ruby  4.02
test-assign-const-int2.js           : duk-perf.O2.200  3.92 duk.O2.200  5.77 duk.O2.150  9.00 mujs  9.61 jerry 11.08 lua   n/a python   n/a perl   n/a ruby   n/a
test-assign-const.js                : duk-perf.O2.200  3.29 duk.O2.200  4.28 duk.O2.150  4.28 mujs  9.86 jerry 15.58 lua  2.14 python  5.46 perl 22.73 ruby  4.06
test-assign-literal.js              : duk-perf.O2.200  3.33 duk.O2.200  3.75 duk.O2.150  4.21 mujs  9.97 jerry 21.68 lua  2.60 python 12.04 perl   n/a ruby  4.46
test-assign-proplhs-reg.js          : duk-perf.O2.200  2.47 duk.O2.200  2.67 duk.O2.150  3.74 mujs  2.41 jerry  4.91 lua   n/a python   n/a perl   n/a ruby   n/a
test-assign-proprhs.js              : duk-perf.O2.200  2.63 duk.O2.200  2.92 duk.O2.150  4.25 mujs  2.51 jerry  3.54 lua   n/a python   n/a perl   n/a ruby   n/a
test-assign-reg.js                  : duk-perf.O2.200  2.46 duk.O2.200  2.84 duk.O2.150  2.79 mujs  8.90 jerry 14.84 lua  2.26 python  5.75 perl 23.32 ruby  4.08
test-base64-decode-whitespace.js    : duk-perf.O2.200  1.89 duk.O2.200  1.88 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python  8.73 perl   n/a ruby   n/a
test-base64-decode.js               : duk-perf.O2.200  1.53 duk.O2.200  1.53 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python  8.69 perl   n/a ruby   n/a
test-base64-encode.js               : duk-perf.O2.200  1.68 duk.O2.200  1.68 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python 17.08 perl   n/a ruby   n/a
test-bitwise-ops.js                 : duk-perf.O2.200  1.53 duk.O2.200  1.89 duk.O2.150  2.61 mujs 14.40 jerry 21.07 lua   n/a python   n/a perl   n/a ruby   n/a
test-break-fast.js                  : duk-perf.O2.200  1.30 duk.O2.200  1.52 duk.O2.150  1.61 mujs  1.22 jerry  1.14 lua   n/a python   n/a perl   n/a ruby   n/a
test-break-slow.js                  : duk-perf.O2.200  6.76 duk.O2.200  7.43 duk.O2.150  8.00 mujs  2.55 jerry  4.15 lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-nodejs-read.js          : duk-perf.O2.200  2.10 duk.O2.200  2.31 duk.O2.150  2.64 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-nodejs-write.js         : duk-perf.O2.200  2.79 duk.O2.200  3.03 duk.O2.150  3.14 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-object-read.js          : duk-perf.O2.200  2.09 duk.O2.200  2.30 duk.O2.150  2.60 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-object-write.js         : duk-perf.O2.200  2.79 duk.O2.200  3.05 duk.O2.150  3.15 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-plain-read.js           : duk-perf.O2.200  1.73 duk.O2.200  1.89 duk.O2.150  2.25 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-buffer-plain-write.js          : duk-perf.O2.200  1.72 duk.O2.200  1.79 duk.O2.150  1.82 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-call-basic-1.js                : duk-perf.O2.200  7.29 duk.O2.200  7.72 duk.O2.150  9.25 mujs  6.53 jerry  9.09 lua  2.23 python  5.29 perl  7.87 ruby  3.40
test-call-basic-2.js                : duk-perf.O2.200  7.41 duk.O2.200  7.73 duk.O2.150  9.21 mujs  4.90 jerry  8.18 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-basic-3.js                : duk-perf.O2.200  9.09 duk.O2.200  9.77 duk.O2.150 15.00 mujs 12.43 jerry 14.31 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-basic-4.js                : duk-perf.O2.200 16.02 duk.O2.200 17.89 duk.O2.150 37.31 mujs 34.48 jerry 35.17 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-native.js                 : duk-perf.O2.200 12.44 duk.O2.200 13.39 duk.O2.150 13.92 mujs 17.19 jerry  7.69 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-prop.js                   : duk-perf.O2.200  3.99 duk.O2.200  4.22 duk.O2.150  5.78 mujs  2.87 jerry  4.13 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-reg-new.js                : duk-perf.O2.200  6.28 duk.O2.200  6.40 duk.O2.150  6.70 mujs  2.73 jerry  3.22 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-reg.js                    : duk-perf.O2.200  2.83 duk.O2.200  3.00 duk.O2.150  3.60 mujs  2.28 jerry  3.36 lua   n/a python   n/a perl   n/a ruby   n/a
test-call-var.js                    : duk-perf.O2.200  7.77 duk.O2.200  8.26 duk.O2.150  8.05 mujs  4.36 jerry  3.79 lua   n/a python   n/a perl   n/a ruby   n/a
test-compile-mandel-nofrac.js       : duk-perf.O2.200 10.90 duk.O2.200 10.69 duk.O2.150 13.29 mujs  5.90 jerry  2.22 lua   n/a python   n/a perl   n/a ruby   n/a
test-compile-mandel.js              : duk-perf.O2.200 13.96 duk.O2.200 13.72 duk.O2.150 16.50 mujs  5.84 jerry  2.24 lua   n/a python   n/a perl   n/a ruby   n/a
test-compile-short.js               : duk-perf.O2.200  6.38 duk.O2.200  6.80 duk.O2.150  9.88 mujs  2.11 jerry  0.86 lua   n/a python   n/a perl   n/a ruby   n/a
test-compile-string-ascii.js        : duk-perf.O2.200  6.66 duk.O2.200  6.70 duk.O2.150  9.17 mujs  6.32 jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-continue-fast.js               : duk-perf.O2.200  1.68 duk.O2.200  1.84 duk.O2.150  2.23 mujs  1.96 jerry  2.20 lua   n/a python   n/a perl   n/a ruby   n/a
test-continue-slow.js               : duk-perf.O2.200  7.49 duk.O2.200  7.88 duk.O2.150  8.35 mujs  3.32 jerry  5.91 lua   n/a python   n/a perl   n/a ruby   n/a
test-empty-loop-slowpath.js         : duk-perf.O2.200  1.49 duk.O2.200  1.68 duk.O2.150  2.01 mujs  0.99 jerry  0.68 lua   n/a python   n/a perl   n/a ruby   n/a
test-empty-loop.js                  : duk-perf.O2.200  1.62 duk.O2.200  1.65 duk.O2.150  2.27 mujs  5.87 jerry  3.16 lua  1.00 python  4.54 perl  3.44 ruby  3.34
test-enum-basic.js                  : duk-perf.O2.200  3.98 duk.O2.200  3.99 duk.O2.150  4.53 mujs  0.68 jerry  1.06 lua   n/a python   n/a perl   n/a ruby   n/a
test-equals-fastint.js              : duk-perf.O2.200  0.51 duk.O2.200  0.61 duk.O2.150  1.17 mujs  2.37 jerry  2.87 lua   n/a python   n/a perl   n/a ruby   n/a
test-equals-nonfastint.js           : duk-perf.O2.200  0.51 duk.O2.200  0.62 duk.O2.150  1.23 mujs  2.35 jerry  3.93 lua   n/a python   n/a perl   n/a ruby   n/a
test-error-create.js                : duk-perf.O2.200  2.13 duk.O2.200  2.12 duk.O2.150  3.31 mujs  4.76 jerry  0.80 lua   n/a python   n/a perl   n/a ruby   n/a
test-fib.js                         : duk-perf.O2.200  6.32 duk.O2.200  6.96 duk.O2.150  7.78 mujs  3.30 jerry  4.98 lua  1.40 python  2.45 perl  6.45 ruby  1.54
test-global-lookup.js               : duk-perf.O2.200  7.80 duk.O2.200  7.87 duk.O2.150 10.26 mujs  4.15 jerry  2.20 lua   n/a python   n/a perl   n/a ruby   n/a
test-hello-world.js                 : duk-perf.O2.200  0.00 duk.O2.200  0.00 duk.O2.150  0.00 mujs  0.00 jerry  0.00 lua  0.00 python  0.00 perl  0.00 ruby  0.00
test-hex-decode.js                  : duk-perf.O2.200  3.59 duk.O2.200  3.65 duk.O2.150  3.68 mujs   n/a jerry   n/a lua   n/a python 12.71 perl   n/a ruby   n/a
test-hex-encode.js                  : duk-perf.O2.200  2.81 duk.O2.200  2.82 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python  1.42 perl   n/a ruby   n/a
test-jc-serialize-indented.js       : duk-perf.O2.200  3.33 duk.O2.200  3.40 duk.O2.150  3.56 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-jc-serialize.js                : duk-perf.O2.200  2.09 duk.O2.200  2.22 duk.O2.150  2.46 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-parse-hex.js              : duk-perf.O2.200  3.16 duk.O2.200  3.23 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-parse-integer.js          : duk-perf.O2.200  3.93 duk.O2.200  3.82 duk.O2.150  4.08 mujs 21.09 jerry   n/a lua   n/a python  0.07 perl   n/a ruby   n/a
test-json-parse-number.js           : duk-perf.O2.200  5.23 duk.O2.200  5.15 duk.O2.150  5.23 mujs  2.41 jerry   n/a lua   n/a python  0.29 perl   n/a ruby   n/a
test-json-parse-string.js           : duk-perf.O2.200  5.57 duk.O2.200  5.82 duk.O2.150  5.80 mujs 45.21 jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-fastpath-loop.js: duk-perf.O2.200  3.66 duk.O2.200  3.61 duk.O2.150  3.61 mujs 12.61 jerry 532.24 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-forceslow.js    : duk-perf.O2.200  9.70 duk.O2.200  9.08 duk.O2.150 11.19 mujs  2.19 jerry  8.86 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-hex.js          : duk-perf.O2.200  1.44 duk.O2.200  1.49 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-indented-deep100.js: duk-perf.O2.200  1.77 duk.O2.200  1.77 duk.O2.150  2.45 mujs  1.52 jerry 135.92 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-indented-deep25.js: duk-perf.O2.200  3.11 duk.O2.200  3.25 duk.O2.150  3.31 mujs 10.34 jerry 240.02 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-indented-deep500.js: duk-perf.O2.200  1.24 duk.O2.200  1.17 duk.O2.150  1.57 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-indented.js     : duk-perf.O2.200  5.80 duk.O2.200  5.91 duk.O2.150  6.34 mujs 14.83 jerry 106.53 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-jsonrpc-message.js: duk-perf.O2.200  1.98 duk.O2.200  1.97 duk.O2.150  1.99 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-nofrac.js       : duk-perf.O2.200  0.59 duk.O2.200  0.61 duk.O2.150  0.67 mujs  1.56 jerry  7.26 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize-slowpath-loop.js: duk-perf.O2.200  4.27 duk.O2.200  4.28 duk.O2.150  6.04 mujs   n/a jerry  6.08 lua   n/a python   n/a perl   n/a ruby   n/a
test-json-serialize.js              : duk-perf.O2.200  6.25 duk.O2.200  5.87 duk.O2.150  6.18 mujs  2.20 jerry  8.78 lua   n/a python  0.51 perl   n/a ruby   n/a
test-json-string-bench.js           : duk-perf.O2.200  3.41 duk.O2.200  3.49 duk.O2.150  5.29 mujs 49.96 jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-json-string-stringify.js       : duk-perf.O2.200  5.12 duk.O2.200  5.17 duk.O2.150  5.19 mujs 10.73 jerry   n/a lua   n/a python  0.48 perl   n/a ruby   n/a
test-jx-serialize-bufobj-forceslow.js: duk-perf.O2.200  4.66 duk.O2.200  4.83 duk.O2.150  5.61 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-jx-serialize-bufobj.js         : duk-perf.O2.200  1.50 duk.O2.200  1.57 duk.O2.150  1.65 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-jx-serialize-indented.js       : duk-perf.O2.200  3.20 duk.O2.200  3.40 duk.O2.150  3.50 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-jx-serialize.js                : duk-perf.O2.200  2.15 duk.O2.200  2.23 duk.O2.150  2.44 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-mandel.js                      : duk-perf.O2.200  2.48 duk.O2.200  2.98 duk.O2.150  4.36 mujs 13.94 jerry 13.15 lua  1.60 python   n/a perl   n/a ruby   n/a
test-object-garbage-2.js            : duk-perf.O2.200  4.71 duk.O2.200  4.91 duk.O2.150  4.87 mujs 49.95 jerry  2.59 lua   n/a python   n/a perl   n/a ruby   n/a
test-object-garbage.js              : duk-perf.O2.200  4.47 duk.O2.200  4.51 duk.O2.150  4.37 mujs  2.37 jerry  2.76 lua  3.44 python  0.66 perl   n/a ruby   n/a
test-object-literal.js              : duk-perf.O2.200  2.80 duk.O2.200  2.88 duk.O2.150  2.54 mujs  3.89 jerry  2.28 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-read-4.js                 : duk-perf.O2.200  3.14 duk.O2.200  3.52 duk.O2.150  4.75 mujs  3.65 jerry  3.95 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-read-8.js                 : duk-perf.O2.200  3.27 duk.O2.200  3.83 duk.O2.150  4.96 mujs  4.52 jerry  3.93 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-read.js                   : duk-perf.O2.200  3.15 duk.O2.200  3.64 duk.O2.150  4.80 mujs  3.81 jerry  3.94 lua  1.08 python  2.37 perl  4.89 ruby 11.20
test-prop-write-1024.js             : duk-perf.O2.200  3.73 duk.O2.200  3.33 duk.O2.150  5.12 mujs  9.93 jerry  4.48 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-16.js               : duk-perf.O2.200  3.18 duk.O2.200  3.78 duk.O2.150  4.58 mujs  4.48 jerry  4.49 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-256.js              : duk-perf.O2.200  3.35 duk.O2.200  3.92 duk.O2.150  4.96 mujs  8.36 jerry  4.68 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-32.js               : duk-perf.O2.200  3.82 duk.O2.200  3.44 duk.O2.150  6.82 mujs  5.55 jerry  4.66 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-4.js                : duk-perf.O2.200  2.87 duk.O2.200  3.13 duk.O2.150  4.37 mujs  3.75 jerry  4.68 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-48.js               : duk-perf.O2.200  5.56 duk.O2.200  4.62 duk.O2.150  5.40 mujs  6.62 jerry  4.61 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-64.js               : duk-perf.O2.200  4.41 duk.O2.200  4.15 duk.O2.150  4.97 mujs  6.75 jerry  4.75 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write-8.js                : duk-perf.O2.200  3.09 duk.O2.200  3.53 duk.O2.150  4.50 mujs  4.66 jerry  4.65 lua   n/a python   n/a perl   n/a ruby   n/a
test-prop-write.js                  : duk-perf.O2.200  2.92 duk.O2.200  3.23 duk.O2.150  4.39 mujs  3.89 jerry  4.65 lua  1.22 python  2.56 perl  5.12 ruby 15.57
test-random.js                      : duk-perf.O2.200  2.20 duk.O2.200  2.30 duk.O2.150  6.49 mujs  1.06 jerry  1.93 lua   n/a python   n/a perl   n/a ruby   n/a
test-reg-readwrite-object.js        : duk-perf.O2.200  3.00 duk.O2.200  3.09 duk.O2.150  3.21 mujs  7.80 jerry 13.44 lua  1.77 python   n/a perl 29.13 ruby  3.97
test-reg-readwrite-plain.js         : duk-perf.O2.200  1.78 duk.O2.200  2.03 duk.O2.150  2.05 mujs  7.73 jerry 10.82 lua  1.73 python  4.83 perl 30.80 ruby  4.00
test-regexp-case-insensitive.js     : duk-perf.O2.200  0.00 duk.O2.200 24.82 duk.O2.150 24.51 mujs  0.00 jerry  0.00 lua   n/a python   n/a perl   n/a ruby   n/a
test-regexp-compile.js              : duk-perf.O2.200  2.14 duk.O2.200  2.17 duk.O2.150  2.69 mujs  1.50 jerry  0.43 lua   n/a python   n/a perl   n/a ruby   n/a
test-regexp-execute.js              : duk-perf.O2.200  1.54 duk.O2.200  1.49 duk.O2.150  1.89 mujs  1.57 jerry  1.08 lua   n/a python   n/a perl   n/a ruby   n/a
test-regexp-string-parse.js         : duk-perf.O2.200  5.94 duk.O2.200  5.99 duk.O2.150  9.70 mujs   n/a jerry   n/a lua   n/a python  0.51 perl   n/a ruby   n/a
test-strict-equals-fastint.js       : duk-perf.O2.200  0.49 duk.O2.200  0.58 duk.O2.150  1.17 mujs  2.45 jerry  3.04 lua   n/a python   n/a perl   n/a ruby   n/a
test-strict-equals-nonfastint.js    : duk-perf.O2.200  0.57 duk.O2.200  0.63 duk.O2.150  1.24 mujs  2.43 jerry  3.84 lua   n/a python   n/a perl   n/a ruby   n/a
test-string-array-concat.js         : duk-perf.O2.200  5.43 duk.O2.200  5.52 duk.O2.150  6.67 mujs 256.24 jerry   n/a lua  2.11 python  2.84 perl  7.56 ruby  7.90
test-string-charlen-ascii.js        : duk-perf.O2.200  1.12 duk.O2.200  1.07 duk.O2.150  1.34 mujs  4.72 jerry  0.75 lua   n/a python   n/a perl   n/a ruby   n/a
test-string-charlen-nonascii.js     : duk-perf.O2.200  2.65 duk.O2.200  2.67 duk.O2.150  2.82 mujs  7.11 jerry  0.50 lua   n/a python   n/a perl   n/a ruby   n/a
test-string-compare.js              : duk-perf.O2.200  1.85 duk.O2.200  2.13 duk.O2.150  3.84 mujs 769.37 jerry   n/a lua  2.82 python  4.93 perl 16.59 ruby  5.43
test-string-decodeuri.js            : duk-perf.O2.200  3.61 duk.O2.200  3.60 duk.O2.150  3.72 mujs  2.13 jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-encodeuri.js            : duk-perf.O2.200  4.06 duk.O2.200  4.05 duk.O2.150  4.04 mujs  3.61 jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-garbage.js              : duk-perf.O2.200  5.15 duk.O2.200  4.94 duk.O2.150  5.38 mujs  1.72 jerry  1.81 lua  1.54 python  1.49 perl   n/a ruby   n/a
test-string-intern-grow-short.js    : duk-perf.O2.200 11.74 duk.O2.200 11.57 duk.O2.150 11.91 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-grow-short2.js   : duk-perf.O2.200  4.61 duk.O2.200  4.59 duk.O2.150  5.00 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-grow.js          : duk-perf.O2.200 20.53 duk.O2.200 20.26 duk.O2.150 19.92 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-grow2.js         : duk-perf.O2.200  1.79 duk.O2.200  1.79 duk.O2.150  1.79 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-match-short.js   : duk-perf.O2.200  2.59 duk.O2.200  2.64 duk.O2.150  2.50 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-match.js         : duk-perf.O2.200  0.22 duk.O2.200  0.23 duk.O2.150  0.26 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-miss-short.js    : duk-perf.O2.200  2.97 duk.O2.200  3.09 duk.O2.150  3.28 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-intern-miss.js          : duk-perf.O2.200  1.14 duk.O2.200  1.20 duk.O2.150  1.19 mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-string-plain-concat.js         : duk-perf.O2.200  0.89 duk.O2.200  0.86 duk.O2.150  1.09 mujs  1.03 jerry  0.52 lua  0.63 python  0.00 perl  0.40 ruby  0.77
test-string-uppercase.js            : duk-perf.O2.200  2.32 duk.O2.200  2.21 duk.O2.150  2.23 mujs  4.48 jerry   n/a lua   n/a python  1.27 perl   n/a ruby   n/a
test-textdecoder-ascii.js           : duk-perf.O2.200  2.84 duk.O2.200  2.79 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-textdecoder-nonascii.js        : duk-perf.O2.200  2.79 duk.O2.200  2.77 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-textencoder-ascii.js           : duk-perf.O2.200  3.98 duk.O2.200  4.19 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-textencoder-nonascii.js        : duk-perf.O2.200 11.27 duk.O2.200 11.21 duk.O2.150   n/a mujs   n/a jerry   n/a lua   n/a python   n/a perl   n/a ruby   n/a
test-try-catch-nothrow.js           : duk-perf.O2.200  2.65 duk.O2.200  2.59 duk.O2.150  2.93 mujs  2.21 jerry  3.18 lua   n/a python   n/a perl   n/a ruby   n/a
test-try-catch-throw.js             : duk-perf.O2.200 37.57 duk.O2.200 38.32 duk.O2.150 38.83 mujs 20.59 jerry 14.89 lua   n/a python   n/a perl   n/a ruby   n/a
test-try-finally-nothrow.js         : duk-perf.O2.200  2.97 duk.O2.200  3.39 duk.O2.150  3.71 mujs  2.06 jerry  3.63 lua   n/a python   n/a perl   n/a ruby   n/a
test-try-finally-throw.js           : duk-perf.O2.200 47.16 duk.O2.200 48.88 duk.O2.150 48.66 mujs 22.93 jerry 17.85 lua   n/a python   n/a perl   n/a ruby   n/a
```
