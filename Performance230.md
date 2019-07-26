# Duktape 2.3.0 performance measurement

## Octane

Octane sub-scores and overall score.  Higher is better, highest of 10 runs.
Omits a few Octane tests which fail to run (see Duktape repo tests/octane).

<table>
<tr>
<th>Test</th>
<th>duk.O2.230</th>
<th>duk.O2.220</th>
</tr>
<tr>
<td>Box2D</td>
<td>1005</td>
<td>994</td>
</tr>
<tr>
<td>CodeLoad</td>
<td>7386</td>
<td>7562</td>
</tr>
<tr>
<td>Crypto</td>
<td>311</td>
<td>297</td>
</tr>
<tr>
<td>DeltaBlue</td>
<td>232</td>
<td>232</td>
</tr>
<tr>
<td>EarleyBoyer</td>
<td>564</td>
<td>492</td>
</tr>
<tr>
<td>Gameboy</td>
<td>1818</td>
<td>1757</td>
</tr>
<tr>
<td>NavierStokes</td>
<td>775</td>
<td>779</td>
</tr>
<tr>
<td>PdfJS</td>
<td>910</td>
<td>918</td>
</tr>
<tr>
<td>RayTrace</td>
<td>427</td>
<td>429</td>
</tr>
<tr>
<td>Richards</td>
<td>181</td>
<td>178</td>
</tr>
<tr>
<td>Splay</td>
<td>1173</td>
<td>1163</td>
</tr>
<tr>
<td>SplayLatency</td>
<td>2753</td>
<td>3759</td>
</tr>
<tr>
<td>SCORE</td>
<td>823</td>
<td>830</td>
</tr>
</table>

## Duktape microbenchmarks, comparison to 2.2.0

Baseline is duk.O2.220, compared to duk.O2.230.  Lower is better, lowest of 5 runs.

<table>
<tr><th></th><th>duk.O2.230</th><th>duk.O2.220</th></tr>
<tr><td>test-add-fastint</td><td style="background-color: #88ff88; font-weight: bold"><strong>0.63</strong> &#9650;</td><td style="background-color: #eeeeee">0.71</td></tr>
<tr><td>test-add-float</td><td style="background-color: #ddffdd"><strong>0.61</strong> &#8657;</td><td style="background-color: #eeeeee">0.66</td></tr>
<tr><td>test-add-int</td><td style="background-color: #eeffee">0.63</td><td style="background-color: #eeeeee">0.67</td></tr>
<tr><td>test-add-nan-fastint</td><td style="background-color: #ffffff">0.66</td><td style="background-color: #eeeeee">0.68</td></tr>
<tr><td>test-add-nan</td><td style="background-color: #ddffdd"><strong>0.61</strong> &#8657;</td><td style="background-color: #eeeeee">0.66</td></tr>
<tr><td>test-add-string</td><td style="background-color: #ffffff">11.83</td><td style="background-color: #eeeeee">11.63</td></tr>
<tr><td>test-arith-add</td><td style="background-color: #ddffdd"><strong>2.47</strong> &#8657;</td><td style="background-color: #eeeeee">2.69</td></tr>
<tr><td>test-arith-add-string</td><td style="background-color: #ffffff">1.16</td><td style="background-color: #eeeeee">1.17</td></tr>
<tr><td>test-arith-div</td><td style="background-color: #ffffff">7.37</td><td style="background-color: #eeeeee">7.36</td></tr>
<tr><td>test-arith-mod</td><td style="background-color: #ffffff">6.61</td><td style="background-color: #eeeeee">6.58</td></tr>
<tr><td>test-arith-mul</td><td style="background-color: #ffffff">3.34</td><td style="background-color: #eeeeee">3.33</td></tr>
<tr><td>test-arith-sub</td><td style="background-color: #eeffee">2.59</td><td style="background-color: #eeeeee">2.69</td></tr>
<tr><td>test-array-append</td><td style="background-color: #ffffff">0.43</td><td style="background-color: #eeeeee">0.43</td></tr>
<tr><td>test-array-cons-list</td><td style="background-color: #ffffff">0.47</td><td style="background-color: #eeeeee">0.48</td></tr>
<tr><td>test-array-foreach</td><td style="background-color: #ffffff">2.12</td><td style="background-color: #eeeeee">2.09</td></tr>
<tr><td>test-array-literal-100</td><td style="background-color: #ffffff">2.29</td><td style="background-color: #eeeeee">2.33</td></tr>
<tr><td>test-array-literal-20</td><td style="background-color: #ffffff">0.54</td><td style="background-color: #eeeeee">0.54</td></tr>
<tr><td>test-array-literal-3</td><td style="background-color: #eeffee">0.20</td><td style="background-color: #eeeeee">0.21</td></tr>
<tr><td>test-array-pop</td><td style="background-color: #eeffee">1.42</td><td style="background-color: #eeeeee">1.47</td></tr>
<tr><td>test-array-push</td><td style="background-color: #ffffff">1.72</td><td style="background-color: #eeeeee">1.72</td></tr>
<tr><td>test-array-read</td><td style="background-color: #ffffff">1.65</td><td style="background-color: #eeeeee">1.67</td></tr>
<tr><td>test-array-read-lenloop</td><td style="background-color: #eeffee">1.70</td><td style="background-color: #eeeeee">1.77</td></tr>
<tr><td>test-array-sort</td><td style="background-color: #ffffff">2.99</td><td style="background-color: #eeeeee">3.07</td></tr>
<tr><td>test-array-write</td><td style="background-color: #ffffff">1.60</td><td style="background-color: #eeeeee">1.60</td></tr>
<tr><td>test-array-write-length</td><td style="background-color: #ffffff">1.42</td><td style="background-color: #eeeeee">1.45</td></tr>
<tr><td>test-assign-add</td><td style="background-color: #ffffff">3.70</td><td style="background-color: #eeeeee">3.78</td></tr>
<tr><td>test-assign-addto</td><td style="background-color: #ffffff">3.69</td><td style="background-color: #eeeeee">3.78</td></tr>
<tr><td>test-assign-addto-nan</td><td style="background-color: #ffffff">1.06</td><td style="background-color: #eeeeee">1.08</td></tr>
<tr><td>test-assign-boolean</td><td style="background-color: #ffffff">4.68</td><td style="background-color: #eeeeee">4.70</td></tr>
<tr><td>test-assign-const-int2</td><td style="background-color: #ddffdd"><strong>4.69</strong> &#8657;</td><td style="background-color: #eeeeee">5.12</td></tr>
<tr><td>test-assign-const-int</td><td style="background-color: #ffffff">2.38</td><td style="background-color: #eeeeee">2.41</td></tr>
<tr><td>test-assign-const</td><td style="background-color: #ddffdd"><strong>3.33</strong> &#8657;</td><td style="background-color: #eeeeee">3.66</td></tr>
<tr><td>test-assign-literal</td><td style="background-color: #ffffff">3.62</td><td style="background-color: #eeeeee">3.63</td></tr>
<tr><td>test-assign-proplhs-reg</td><td style="background-color: #ffffff">2.50</td><td style="background-color: #eeeeee">2.47</td></tr>
<tr><td>test-assign-proprhs</td><td style="background-color: #ffffff">2.66</td><td style="background-color: #eeeeee">2.62</td></tr>
<tr><td>test-assign-reg</td><td style="background-color: #ffffff">2.74</td><td style="background-color: #eeeeee">2.73</td></tr>
<tr><td>test-base64-decode</td><td style="background-color: #eeffee">1.37</td><td style="background-color: #eeeeee">1.47</td></tr>
<tr><td>test-base64-decode-whitespace</td><td style="background-color: #eeffee">1.67</td><td style="background-color: #eeeeee">1.77</td></tr>
<tr><td>test-base64-encode</td><td style="background-color: #88ff88; font-weight: bold"><strong>1.62</strong> &#9650;</td><td style="background-color: #eeeeee">1.89</td></tr>
<tr><td>test-bitwise-ops</td><td style="background-color: #eeffee">1.59</td><td style="background-color: #eeeeee">1.67</td></tr>
<tr><td>test-break-fast</td><td style="background-color: #ffffff">0.89</td><td style="background-color: #eeeeee">0.91</td></tr>
<tr><td>test-break-slow</td><td style="background-color: #ffffff">6.47</td><td style="background-color: #eeeeee">6.65</td></tr>
<tr><td>test-buffer-float32array-write</td><td style="background-color: #ffffff">2.78</td><td style="background-color: #eeeeee">2.79</td></tr>
<tr><td>test-buffer-nodejs-read</td><td style="background-color: #ffffff">2.10</td><td style="background-color: #eeeeee">2.14</td></tr>
<tr><td>test-buffer-nodejs-write</td><td style="background-color: #ffffff">2.76</td><td style="background-color: #eeeeee">2.72</td></tr>
<tr><td>test-buffer-object-read</td><td style="background-color: #eeffee">2.08</td><td style="background-color: #eeeeee">2.16</td></tr>
<tr><td>test-buffer-object-write</td><td style="background-color: #ffffff">2.75</td><td style="background-color: #eeeeee">2.71</td></tr>
<tr><td>test-buffer-plain-read</td><td style="background-color: #ffffff">1.76</td><td style="background-color: #eeeeee">1.74</td></tr>
<tr><td>test-buffer-plain-write</td><td style="background-color: #ffffff">1.61</td><td style="background-color: #eeeeee">1.65</td></tr>
<tr><td>test-call-apply</td><td style="background-color: #ffffff">2.14</td><td style="background-color: #eeeeee">2.18</td></tr>
<tr><td>test-call-basic-1</td><td style="background-color: #ffffff">5.86</td><td style="background-color: #eeeeee">5.87</td></tr>
<tr><td>test-call-basic-2</td><td style="background-color: #ffffff">5.88</td><td style="background-color: #eeeeee">5.87</td></tr>
<tr><td>test-call-basic-3</td><td style="background-color: #ffffff">7.70</td><td style="background-color: #eeeeee">7.74</td></tr>
<tr><td>test-call-basic-4</td><td style="background-color: #eeffee">15.65</td><td style="background-color: #eeeeee">16.52</td></tr>
<tr><td>test-call-bound-deep</td><td style="background-color: #ffffff">2.43</td><td style="background-color: #eeeeee">2.42</td></tr>
<tr><td>test-call-bound</td><td style="background-color: #ffffff">2.31</td><td style="background-color: #eeeeee">2.27</td></tr>
<tr><td>test-call-call</td><td style="background-color: #ffffff">1.91</td><td style="background-color: #eeeeee">1.95</td></tr>
<tr><td>test-call-native</td><td style="background-color: #ffffff">10.58</td><td style="background-color: #eeeeee">10.41</td></tr>
<tr><td>test-call-prop</td><td style="background-color: #ffffff">3.66</td><td style="background-color: #eeeeee">3.59</td></tr>
<tr><td>test-call-proxy-apply-1</td><td style="background-color: #ffffff">24.78</td><td style="background-color: #eeeeee">24.89</td></tr>
<tr><td>test-call-proxy-pass-1</td><td style="background-color: #ffffff">12.97</td><td style="background-color: #eeeeee">13.06</td></tr>
<tr><td>test-call-reg</td><td style="background-color: #ffffff">2.35</td><td style="background-color: #eeeeee">2.35</td></tr>
<tr><td>test-call-reg-new</td><td style="background-color: #ffffff">4.14</td><td style="background-color: #eeeeee">4.11</td></tr>
<tr><td>test-call-tail-1</td><td style="background-color: #ffeeee">(0.98)</td><td style="background-color: #eeeeee">0.95</td></tr>
<tr><td>test-call-tail-2</td><td style="background-color: #ffeeee">(1.13)</td><td style="background-color: #eeeeee">1.07</td></tr>
<tr><td>test-call-var</td><td style="background-color: #ffeeee">(5.38)</td><td style="background-color: #eeeeee">5.16</td></tr>
<tr><td>test-closure-inner-functions</td><td style="background-color: #ffffff">1.01</td><td style="background-color: #eeeeee">0.99</td></tr>
<tr><td>test-compile-mandel</td><td style="background-color: #ffffff">11.64</td><td style="background-color: #eeeeee">11.50</td></tr>
<tr><td>test-compile-mandel-nofrac</td><td style="background-color: #ffffff">8.77</td><td style="background-color: #eeeeee">8.72</td></tr>
<tr><td>test-compile-short</td><td style="background-color: #ffffff">4.37</td><td style="background-color: #eeeeee">4.50</td></tr>
<tr><td>test-compile-string-ascii</td><td style="background-color: #ffffff">7.00</td><td style="background-color: #eeeeee">7.12</td></tr>
<tr><td>test-continue-fast</td><td style="background-color: #eeffee">1.21</td><td style="background-color: #eeeeee">1.26</td></tr>
<tr><td>test-continue-slow</td><td style="background-color: #ffffff">6.82</td><td style="background-color: #eeeeee">6.87</td></tr>
<tr><td>test-empty-loop</td><td style="background-color: #eeffee">1.40</td><td style="background-color: #eeeeee">1.49</td></tr>
<tr><td>test-empty-loop-slowpath</td><td style="background-color: #ffeeee">(0.93)</td><td style="background-color: #eeeeee">0.89</td></tr>
<tr><td>test-empty-loop-step3</td><td style="background-color: #eeffee">1.50</td><td style="background-color: #eeeeee">1.58</td></tr>
<tr><td>test-enum-basic</td><td style="background-color: #ffffff">2.73</td><td style="background-color: #eeeeee">2.73</td></tr>
<tr><td>test-equals-fastint</td><td style="background-color: #ffffff">0.50</td><td style="background-color: #eeeeee">0.51</td></tr>
<tr><td>test-equals-nonfastint</td><td style="background-color: #ffffff">0.58</td><td style="background-color: #eeeeee">0.57</td></tr>
<tr><td>test-error-create</td><td style="background-color: #ffffff">1.34</td><td style="background-color: #eeeeee">1.34</td></tr>
<tr><td>test-fib-2</td><td style="background-color: #ffffff">2.88</td><td style="background-color: #eeeeee">2.91</td></tr>
<tr><td>test-fib</td><td style="background-color: #ffffff">5.48</td><td style="background-color: #eeeeee">5.34</td></tr>
<tr><td>test-func-bind</td><td style="background-color: #ffffff">1.64</td><td style="background-color: #eeeeee">1.65</td></tr>
<tr><td>test-func-tostring</td><td style="background-color: #ffffff">3.05</td><td style="background-color: #eeeeee">3.05</td></tr>
<tr><td>test-global-lookup</td><td style="background-color: #ffffff">6.18</td><td style="background-color: #eeeeee">6.16</td></tr>
<tr><td>test-hello-world</td><td style="background-color: #ffffff">0.00</td><td style="background-color: #eeeeee">0.00</td></tr>
<tr><td>test-hex-decode</td><td style="background-color: #ffffff">3.83</td><td style="background-color: #eeeeee">3.83</td></tr>
<tr><td>test-hex-encode</td><td style="background-color: #ffffff">2.78</td><td style="background-color: #eeeeee">2.74</td></tr>
<tr><td>test-jc-serialize-indented</td><td style="background-color: #ffffff">2.61</td><td style="background-color: #eeeeee">2.60</td></tr>
<tr><td>test-jc-serialize</td><td style="background-color: #ffffff">1.81</td><td style="background-color: #eeeeee">1.78</td></tr>
<tr><td>test-json-parse-hex</td><td style="background-color: #ffffff">3.20</td><td style="background-color: #eeeeee">3.19</td></tr>
<tr><td>test-json-parse-integer</td><td style="background-color: #ffffff">2.52</td><td style="background-color: #eeeeee">2.53</td></tr>
<tr><td>test-json-parse-number</td><td style="background-color: #ffffff">4.60</td><td style="background-color: #eeeeee">4.71</td></tr>
<tr><td>test-json-parse-string</td><td style="background-color: #ffffff">4.61</td><td style="background-color: #eeeeee">4.64</td></tr>
<tr><td>test-json-serialize-fastpath-loop</td><td style="background-color: #ffffff">2.83</td><td style="background-color: #eeeeee">2.82</td></tr>
<tr><td>test-json-serialize-forceslow</td><td style="background-color: #ffeeee">(7.59)</td><td style="background-color: #eeeeee">7.32</td></tr>
<tr><td>test-json-serialize-hex</td><td style="background-color: #ffffff">1.36</td><td style="background-color: #eeeeee">1.37</td></tr>
<tr><td>test-json-serialize-indented-deep100</td><td style="background-color: #ffdddd"><em>(1.25)</em> &#8659;</td><td style="background-color: #eeeeee">1.16</td></tr>
<tr><td>test-json-serialize-indented-deep25</td><td style="background-color: #ffffff">2.60</td><td style="background-color: #eeeeee">2.61</td></tr>
<tr><td>test-json-serialize-indented-deep500</td><td style="background-color: #ffffff">0.76</td><td style="background-color: #eeeeee">0.78</td></tr>
<tr><td>test-json-serialize-indented</td><td style="background-color: #ffffff">4.55</td><td style="background-color: #eeeeee">4.54</td></tr>
<tr><td>test-json-serialize</td><td style="background-color: #ffeeee">(5.56)</td><td style="background-color: #eeeeee">5.29</td></tr>
<tr><td>test-json-serialize-jsonrpc-message</td><td style="background-color: #eeffee">1.80</td><td style="background-color: #eeeeee">1.86</td></tr>
<tr><td>test-json-serialize-nofrac</td><td style="background-color: #ffffff">0.51</td><td style="background-color: #eeeeee">0.50</td></tr>
<tr><td>test-json-serialize-plainbuf</td><td style="background-color: #ffffff">2.37</td><td style="background-color: #eeeeee">2.42</td></tr>
<tr><td>test-json-serialize-slowpath-loop</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.93</td></tr>
<tr><td>test-json-string-bench</td><td style="background-color: #ffffff">2.53</td><td style="background-color: #eeeeee">2.50</td></tr>
<tr><td>test-json-string-stringify</td><td style="background-color: #ffffff">5.31</td><td style="background-color: #eeeeee">5.36</td></tr>
<tr><td>test-jx-serialize-bufobj-forceslow</td><td style="background-color: #ffffff">3.27</td><td style="background-color: #eeeeee">3.30</td></tr>
<tr><td>test-jx-serialize-bufobj</td><td style="background-color: #ffffff">1.19</td><td style="background-color: #eeeeee">1.20</td></tr>
<tr><td>test-jx-serialize-indented</td><td style="background-color: #ffffff">2.56</td><td style="background-color: #eeeeee">2.59</td></tr>
<tr><td>test-jx-serialize</td><td style="background-color: #ffffff">1.74</td><td style="background-color: #eeeeee">1.74</td></tr>
<tr><td>test-mandel-iter10-normal</td><td style="background-color: #ffffff">0.03</td><td style="background-color: #eeeeee">0.03</td></tr>
<tr><td>test-mandel-iter10-promise</td><td style="background-color: #ffffff">-</td><td style="background-color: #eeeeee">-</td></tr>
<tr><td>test-mandel</td><td style="background-color: #ddffdd"><strong>2.49</strong> &#8657;</td><td style="background-color: #eeeeee">2.70</td></tr>
<tr><td>test-mandel-promise</td><td style="background-color: #ffffff">-</td><td style="background-color: #eeeeee">-</td></tr>
<tr><td>test-math-clz32</td><td style="background-color: #eeffee">1.90</td><td style="background-color: #eeeeee">2.03</td></tr>
<tr><td>test-misc-1dcell</td><td style="background-color: #ffffff">3.32</td><td style="background-color: #eeeeee">3.39</td></tr>
<tr><td>test-object-garbage-2</td><td style="background-color: #eeffee">2.12</td><td style="background-color: #eeeeee">2.19</td></tr>
<tr><td>test-object-garbage</td><td style="background-color: #ffeeee">(3.10)</td><td style="background-color: #eeeeee">2.90</td></tr>
<tr><td>test-object-literal-100</td><td style="background-color: #eeffee">6.50</td><td style="background-color: #eeeeee">6.79</td></tr>
<tr><td>test-object-literal-20</td><td style="background-color: #ffffff">1.38</td><td style="background-color: #eeeeee">1.42</td></tr>
<tr><td>test-object-literal-3</td><td style="background-color: #ffffff">0.30</td><td style="background-color: #eeeeee">0.30</td></tr>
<tr><td>test-prop-read-1024</td><td style="background-color: #ffffff">2.95</td><td style="background-color: #eeeeee">2.97</td></tr>
<tr><td>test-prop-read-16</td><td style="background-color: #ffffff">2.96</td><td style="background-color: #eeeeee">2.97</td></tr>
<tr><td>test-prop-read-256</td><td style="background-color: #ffffff">2.97</td><td style="background-color: #eeeeee">2.98</td></tr>
<tr><td>test-prop-read-32</td><td style="background-color: #ffffff">2.99</td><td style="background-color: #eeeeee">2.97</td></tr>
<tr><td>test-prop-read-48</td><td style="background-color: #ffffff">2.96</td><td style="background-color: #eeeeee">2.97</td></tr>
<tr><td>test-prop-read-4</td><td style="background-color: #ffeeee">(3.15)</td><td style="background-color: #eeeeee">3.02</td></tr>
<tr><td>test-prop-read-64</td><td style="background-color: #ffffff">2.97</td><td style="background-color: #eeeeee">2.98</td></tr>
<tr><td>test-prop-read-8</td><td style="background-color: #ffffff">2.98</td><td style="background-color: #eeeeee">2.98</td></tr>
<tr><td>test-prop-read-inherited</td><td style="background-color: #ffffff">4.31</td><td style="background-color: #eeeeee">4.28</td></tr>
<tr><td>test-prop-read</td><td style="background-color: #ffeeee">(3.20)</td><td style="background-color: #eeeeee">3.07</td></tr>
<tr><td>test-prop-write-1024</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.90</td></tr>
<tr><td>test-prop-write-16</td><td style="background-color: #ffffff">2.93</td><td style="background-color: #eeeeee">2.93</td></tr>
<tr><td>test-prop-write-256</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.89</td></tr>
<tr><td>test-prop-write-32</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.90</td></tr>
<tr><td>test-prop-write-48</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.89</td></tr>
<tr><td>test-prop-write-4</td><td style="background-color: #eeffee">2.83</td><td style="background-color: #eeeeee">2.97</td></tr>
<tr><td>test-prop-write-64</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.90</td></tr>
<tr><td>test-prop-write-8</td><td style="background-color: #ffffff">2.91</td><td style="background-color: #eeeeee">2.89</td></tr>
<tr><td>test-prop-write</td><td style="background-color: #ffffff">2.93</td><td style="background-color: #eeeeee">2.98</td></tr>
<tr><td>test-proxy-get</td><td style="background-color: #ffffff">1.50</td><td style="background-color: #eeeeee">1.52</td></tr>
<tr><td>test-random</td><td style="background-color: #ffffff">1.43</td><td style="background-color: #eeeeee">1.43</td></tr>
<tr><td>test-reflect-ownkeys-sorted</td><td style="background-color: #ffffff">0.79</td><td style="background-color: #eeeeee">0.78</td></tr>
<tr><td>test-reflect-ownkeys-unsorted</td><td style="background-color: #ffeeee">(0.83)</td><td style="background-color: #eeeeee">0.80</td></tr>
<tr><td>test-regexp-case-insensitive-compile</td><td style="background-color: #ffffff">0.64</td><td style="background-color: #eeeeee">0.65</td></tr>
<tr><td>test-regexp-case-insensitive-execute</td><td style="background-color: #ffffff">1.42</td><td style="background-color: #eeeeee">1.42</td></tr>
<tr><td>test-regexp-case-sensitive-compile</td><td style="background-color: #ffffff">1.19</td><td style="background-color: #eeeeee">1.21</td></tr>
<tr><td>test-regexp-case-sensitive-execute</td><td style="background-color: #ffffff">1.04</td><td style="background-color: #eeeeee">1.04</td></tr>
<tr><td>test-regexp-compile</td><td style="background-color: #ffffff">1.64</td><td style="background-color: #eeeeee">1.64</td></tr>
<tr><td>test-regexp-execute</td><td style="background-color: #ffffff">1.11</td><td style="background-color: #eeeeee">1.12</td></tr>
<tr><td>test-regexp-string-parse</td><td style="background-color: #eeffee">5.55</td><td style="background-color: #eeeeee">5.73</td></tr>
<tr><td>test-reg-readwrite-object</td><td style="background-color: #ffffff">3.11</td><td style="background-color: #eeeeee">3.09</td></tr>
<tr><td>test-reg-readwrite-plain</td><td style="background-color: #ffffff">2.00</td><td style="background-color: #eeeeee">2.01</td></tr>
<tr><td>test-strict-equals-fastint</td><td style="background-color: #ffffff">0.51</td><td style="background-color: #eeeeee">0.51</td></tr>
<tr><td>test-strict-equals-nonfastint</td><td style="background-color: #ffffff">0.57</td><td style="background-color: #eeeeee">0.57</td></tr>
<tr><td>test-string-array-concat</td><td style="background-color: #ffffff">4.54</td><td style="background-color: #eeeeee">4.58</td></tr>
<tr><td>test-string-arridx</td><td style="background-color: #ffffff">1.18</td><td style="background-color: #eeeeee">1.19</td></tr>
<tr><td>test-string-charlen-ascii</td><td style="background-color: #ffffff">1.08</td><td style="background-color: #eeeeee">1.05</td></tr>
<tr><td>test-string-charlen-nonascii</td><td style="background-color: #ffffff">2.60</td><td style="background-color: #eeeeee">2.57</td></tr>
<tr><td>test-string-compare</td><td style="background-color: #eeffee">1.83</td><td style="background-color: #eeeeee">1.92</td></tr>
<tr><td>test-string-decodeuri</td><td style="background-color: #ffffff">3.54</td><td style="background-color: #eeeeee">3.53</td></tr>
<tr><td>test-string-encodeuri</td><td style="background-color: #ffffff">3.59</td><td style="background-color: #eeeeee">3.56</td></tr>
<tr><td>test-string-garbage</td><td style="background-color: #eeffee">2.63</td><td style="background-color: #eeeeee">2.75</td></tr>
<tr><td>test-string-intern-grow2</td><td style="background-color: #ffeeee">(0.54)</td><td style="background-color: #eeeeee">0.52</td></tr>
<tr><td>test-string-intern-grow</td><td style="background-color: #ffffff">5.14</td><td style="background-color: #eeeeee">5.15</td></tr>
<tr><td>test-string-intern-grow-short2</td><td style="background-color: #ffffff">3.06</td><td style="background-color: #eeeeee">3.06</td></tr>
<tr><td>test-string-intern-grow-short</td><td style="background-color: #ffffff">3.11</td><td style="background-color: #eeeeee">3.12</td></tr>
<tr><td>test-string-intern-match</td><td style="background-color: #ffffff">0.16</td><td style="background-color: #eeeeee">0.16</td></tr>
<tr><td>test-string-intern-match-short</td><td style="background-color: #ffffff">1.23</td><td style="background-color: #eeeeee">1.25</td></tr>
<tr><td>test-string-intern-miss</td><td style="background-color: #ffffff">0.27</td><td style="background-color: #eeeeee">0.27</td></tr>
<tr><td>test-string-intern-miss-short</td><td style="background-color: #ffffff">1.49</td><td style="background-color: #eeeeee">1.49</td></tr>
<tr><td>test-string-literal-intern</td><td style="background-color: #ffeeee">(2.72)</td><td style="background-color: #eeeeee">2.58</td></tr>
<tr><td>test-string-number-list</td><td style="background-color: #ffeeee">(0.58)</td><td style="background-color: #eeeeee">0.56</td></tr>
<tr><td>test-string-plain-concat</td><td style="background-color: #ffffff">0.41</td><td style="background-color: #eeeeee">0.40</td></tr>
<tr><td>test-string-scan-nonascii</td><td style="background-color: #ffffff">3.02</td><td style="background-color: #eeeeee">3.02</td></tr>
<tr><td>test-string-uppercase</td><td style="background-color: #ffffff">2.12</td><td style="background-color: #eeeeee">2.15</td></tr>
<tr><td>test-symbol-tostring</td><td style="background-color: #88ff88; font-weight: bold"><strong>3.32</strong> &#9650;</td><td style="background-color: #eeeeee">3.99</td></tr>
<tr><td>test-textdecoder-ascii</td><td style="background-color: #88ff88; font-weight: bold"><strong>1.86</strong> &#9650;</td><td style="background-color: #eeeeee">2.13</td></tr>
<tr><td>test-textdecoder-nonascii</td><td style="background-color: #ffffff">2.63</td><td style="background-color: #eeeeee">2.64</td></tr>
<tr><td>test-textencoder-ascii</td><td style="background-color: #ffffff">4.31</td><td style="background-color: #eeeeee">4.23</td></tr>
<tr><td>test-textencoder-nonascii</td><td style="background-color: #eeffee">9.77</td><td style="background-color: #eeeeee">10.45</td></tr>
<tr><td>test-try-catch-nothrow</td><td style="background-color: #ffffff">3.15</td><td style="background-color: #eeeeee">3.16</td></tr>
<tr><td>test-try-catch-throw</td><td style="background-color: #ffeeee">(24.07)</td><td style="background-color: #eeeeee">22.88</td></tr>
<tr><td>test-try-finally-nothrow</td><td style="background-color: #ffffff">3.71</td><td style="background-color: #eeeeee">3.74</td></tr>
<tr><td>test-try-finally-throw</td><td style="background-color: #ffdddd"><em>(32.48)</em> &#8659;</td><td style="background-color: #eeeeee">30.13</td></tr>
</table>

## Setup

Measurement host:

* "Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz" laptop

Duktape is compiled with:

* gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3) 
* `gcc -O2`
* duk.O2: defaults + debugger and executor interrupt enabled, fastints enabled

Note that:

* These are microbenchmarks, and don't necessarily represent application
  performance very well.  Microbenchmarks are useful for measuring how well
  different parts of the engine work.

* Only relative numbers matter.  Loop counts differ between test cases so
  the numbers for two tests are not directly comparable.  Absolute numbers
  may also change between test runs if test target is different.

* The measurement process is not very accurate: it's based on running the
  test multiple times and measuring time using the `time` command.
