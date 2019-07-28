# Duktape 2.4.0 performance measurement

## Octane

Octane sub-scores and overall score.  Higher is better, highest of 10 runs.
Omits a few Octane tests which fail to run (see Duktape repo tests/octane).

<table>
<tr>
<th>Test</th>
<th>duk.O2.240</th>
<th>duk.O2.230</th>
</tr>
<tr>
<td>Box2D</td>
<td>511</td>
<td>516</td>
</tr>
<tr>
<td>CodeLoad</td>
<td>4802</td>
<td>4469</td>
</tr>
<tr>
<td>Crypto</td>
<td>154</td>
<td>155</td>
</tr>
<tr>
<td>DeltaBlue</td>
<td>129</td>
<td>130</td>
</tr>
<tr>
<td>EarleyBoyer</td>
<td>311</td>
<td>310</td>
</tr>
<tr>
<td>Gameboy</td>
<td>881</td>
<td>885</td>
</tr>
<tr>
<td>NavierStokes</td>
<td>358</td>
<td>354</td>
</tr>
<tr>
<td>PdfJS</td>
<td>484</td>
<td>482</td>
</tr>
<tr>
<td>RayTrace</td>
<td>277</td>
<td>271</td>
</tr>
<tr>
<td>Richards</td>
<td>107</td>
<td>109</td>
</tr>
<tr>
<td>Splay</td>
<td>770</td>
<td>775</td>
</tr>
<tr>
<td>SplayLatency</td>
<td>4364</td>
<td>4388</td>
</tr>
<tr>
<td>SCORE</td>
<td>498</td>
<td>495</td>
</tr>
</table>

## Duktape microbenchmarks, comparison to 2.3.0

Baseline is duk.O2.230, compared to duk.O2.240.  Lower is better, lowest of 5 runs.

<table>
<tr><th></th><th>duk.O2.240</th><th>duk.O2.230</th></tr>
<tr><td>test-add-fastint</td><td style="background-color: #ffffff">1.80</td><td style="background-color: #eeeeee">1.78</td></tr>
<tr><td>test-add-float</td><td style="background-color: #ffffff">1.78</td><td style="background-color: #eeeeee">1.78</td></tr>
<tr><td>test-add-int</td><td style="background-color: #eeffee">1.77</td><td style="background-color: #eeeeee">1.83</td></tr>
<tr><td>test-add-nan-fastint</td><td style="background-color: #ffffff">1.80</td><td style="background-color: #eeeeee">1.79</td></tr>
<tr><td>test-add-nan</td><td style="background-color: #ffffff">1.78</td><td style="background-color: #eeeeee">1.78</td></tr>
<tr><td>test-add-string</td><td style="background-color: #ffffff">25.93</td><td style="background-color: #eeeeee">25.67</td></tr>
<tr><td>test-arith-add</td><td style="background-color: #ffffff">7.18</td><td style="background-color: #eeeeee">7.06</td></tr>
<tr><td>test-arith-add-string</td><td style="background-color: #ffffff">2.59</td><td style="background-color: #eeeeee">2.57</td></tr>
<tr><td>test-arith-div</td><td style="background-color: #ffffff">10.16</td><td style="background-color: #eeeeee">10.45</td></tr>
<tr><td>test-arith-mod</td><td style="background-color: #ffffff">9.54</td><td style="background-color: #eeeeee">9.49</td></tr>
<tr><td>test-arith-mul</td><td style="background-color: #ffffff">7.99</td><td style="background-color: #eeeeee">7.80</td></tr>
<tr><td>test-arith-sub</td><td style="background-color: #ffffff">7.06</td><td style="background-color: #eeeeee">7.21</td></tr>
<tr><td>test-array-append</td><td style="background-color: #ffffff">1.47</td><td style="background-color: #eeeeee">1.44</td></tr>
<tr><td>test-array-cons-list</td><td style="background-color: #ffffff">1.04</td><td style="background-color: #eeeeee">1.03</td></tr>
<tr><td>test-array-foreach</td><td style="background-color: #ffeeee">(4.00)</td><td style="background-color: #eeeeee">3.86</td></tr>
<tr><td>test-array-literal-100</td><td style="background-color: #ffffff">4.28</td><td style="background-color: #eeeeee">4.22</td></tr>
<tr><td>test-array-literal-20</td><td style="background-color: #ffffff">1.03</td><td style="background-color: #eeeeee">1.03</td></tr>
<tr><td>test-array-literal-3</td><td style="background-color: #ffeeee">(0.47)</td><td style="background-color: #eeeeee">0.45</td></tr>
<tr><td>test-array-pop</td><td style="background-color: #ffffff">2.96</td><td style="background-color: #eeeeee">2.97</td></tr>
<tr><td>test-array-push</td><td style="background-color: #ffffff">3.22</td><td style="background-color: #eeeeee">3.14</td></tr>
<tr><td>test-array-read</td><td style="background-color: #ffffff">4.80</td><td style="background-color: #eeeeee">4.71</td></tr>
<tr><td>test-array-read-lenloop</td><td style="background-color: #ffffff">5.52</td><td style="background-color: #eeeeee">5.42</td></tr>
<tr><td>test-array-sort</td><td style="background-color: #ffeeee">(5.27)</td><td style="background-color: #eeeeee">4.99</td></tr>
<tr><td>test-array-write</td><td style="background-color: #ffffff">4.54</td><td style="background-color: #eeeeee">4.50</td></tr>
<tr><td>test-array-write-length</td><td style="background-color: #ffffff">4.32</td><td style="background-color: #eeeeee">4.34</td></tr>
<tr><td>test-assign-add</td><td style="background-color: #ffeeee">(11.66)</td><td style="background-color: #eeeeee">11.19</td></tr>
<tr><td>test-assign-addto</td><td style="background-color: #ffeeee">(11.61)</td><td style="background-color: #eeeeee">11.22</td></tr>
<tr><td>test-assign-addto-nan</td><td style="background-color: #ffffff">2.84</td><td style="background-color: #eeeeee">2.85</td></tr>
<tr><td>test-assign-boolean</td><td style="background-color: #ffeeee">(10.11)</td><td style="background-color: #eeeeee">9.75</td></tr>
<tr><td>test-assign-const-int2</td><td style="background-color: #ffffff">20.39</td><td style="background-color: #eeeeee">20.93</td></tr>
<tr><td>test-assign-const-int</td><td style="background-color: #eeffee">10.21</td><td style="background-color: #eeeeee">10.69</td></tr>
<tr><td>test-assign-const</td><td style="background-color: #eeffee">10.15</td><td style="background-color: #eeeeee">10.50</td></tr>
<tr><td>test-assign-literal</td><td style="background-color: #ffffff">12.18</td><td style="background-color: #eeeeee">11.87</td></tr>
<tr><td>test-assign-proplhs-reg</td><td style="background-color: #ffeeee">(6.23)</td><td style="background-color: #eeeeee">5.95</td></tr>
<tr><td>test-assign-proprhs</td><td style="background-color: #ffffff">7.11</td><td style="background-color: #eeeeee">7.00</td></tr>
<tr><td>test-assign-reg</td><td style="background-color: #ffffff">10.02</td><td style="background-color: #eeeeee">10.12</td></tr>
<tr><td>test-base64-decode</td><td style="background-color: #ffffff">1.12</td><td style="background-color: #eeeeee">1.13</td></tr>
<tr><td>test-base64-decode-whitespace</td><td style="background-color: #ffffff">1.35</td><td style="background-color: #eeeeee">1.37</td></tr>
<tr><td>test-base64-encode</td><td style="background-color: #ffffff">1.31</td><td style="background-color: #eeeeee">1.32</td></tr>
<tr><td>test-bitwise-ops</td><td style="background-color: #ffffff">5.10</td><td style="background-color: #eeeeee">5.04</td></tr>
<tr><td>test-break-fast</td><td style="background-color: #ffffff">3.65</td><td style="background-color: #eeeeee">3.64</td></tr>
<tr><td>test-break-slow</td><td style="background-color: #ffffff">15.80</td><td style="background-color: #eeeeee">15.92</td></tr>
<tr><td>test-buffer-float32array-write</td><td style="background-color: #ffffff">9.44</td><td style="background-color: #eeeeee">9.56</td></tr>
<tr><td>test-buffer-nodejs-read</td><td style="background-color: #ffffff">6.79</td><td style="background-color: #eeeeee">6.82</td></tr>
<tr><td>test-buffer-nodejs-write</td><td style="background-color: #ffffff">8.65</td><td style="background-color: #eeeeee">8.82</td></tr>
<tr><td>test-buffer-object-read</td><td style="background-color: #ffffff">6.82</td><td style="background-color: #eeeeee">6.83</td></tr>
<tr><td>test-buffer-object-write</td><td style="background-color: #ffffff">8.63</td><td style="background-color: #eeeeee">8.81</td></tr>
<tr><td>test-buffer-plain-read</td><td style="background-color: #ffeeee">(5.27)</td><td style="background-color: #eeeeee">4.96</td></tr>
<tr><td>test-buffer-plain-write</td><td style="background-color: #ffffff">4.91</td><td style="background-color: #eeeeee">5.01</td></tr>
<tr><td>test-call-apply</td><td style="background-color: #ffffff">4.06</td><td style="background-color: #eeeeee">4.07</td></tr>
<tr><td>test-call-basic-1</td><td style="background-color: #ffffff">10.52</td><td style="background-color: #eeeeee">10.23</td></tr>
<tr><td>test-call-basic-2</td><td style="background-color: #ffffff">10.50</td><td style="background-color: #eeeeee">10.26</td></tr>
<tr><td>test-call-basic-3</td><td style="background-color: #ffffff">12.58</td><td style="background-color: #eeeeee">12.74</td></tr>
<tr><td>test-call-basic-4</td><td style="background-color: #eeffee">27.13</td><td style="background-color: #eeeeee">28.46</td></tr>
<tr><td>test-call-bound-deep</td><td style="background-color: #ffffff">4.33</td><td style="background-color: #eeeeee">4.31</td></tr>
<tr><td>test-call-bound</td><td style="background-color: #ffffff">4.20</td><td style="background-color: #eeeeee">4.17</td></tr>
<tr><td>test-call-call</td><td style="background-color: #ffffff">3.64</td><td style="background-color: #eeeeee">3.55</td></tr>
<tr><td>test-call-closure-1</td><td style="background-color: #ffffff">2.94</td><td style="background-color: #eeeeee">2.93</td></tr>
<tr><td>test-call-native</td><td style="background-color: #ffeeee">(20.84)</td><td style="background-color: #eeeeee">19.69</td></tr>
<tr><td>test-call-prop</td><td style="background-color: #ffffff">7.16</td><td style="background-color: #eeeeee">7.02</td></tr>
<tr><td>test-call-proxy-apply-1</td><td style="background-color: #ffffff">44.90</td><td style="background-color: #eeeeee">44.40</td></tr>
<tr><td>test-call-proxy-pass-1</td><td style="background-color: #ffffff">22.91</td><td style="background-color: #eeeeee">22.63</td></tr>
<tr><td>test-call-reg</td><td style="background-color: #ffffff">4.26</td><td style="background-color: #eeeeee">4.16</td></tr>
<tr><td>test-call-reg-new</td><td style="background-color: #ffffff">7.70</td><td style="background-color: #eeeeee">7.57</td></tr>
<tr><td>test-call-tail-1</td><td style="background-color: #ffeeee">(2.06)</td><td style="background-color: #eeeeee">1.99</td></tr>
<tr><td>test-call-tail-2</td><td style="background-color: #ffeeee">(2.20)</td><td style="background-color: #eeeeee">2.13</td></tr>
<tr><td>test-call-var</td><td style="background-color: #ffeeee">(9.48)</td><td style="background-color: #eeeeee">8.95</td></tr>
<tr><td>test-cbor-decode-1</td><td style="background-color: #ffffff">3.71</td><td style="background-color: #eeeeee">3.72</td></tr>
<tr><td>test-cbor-decode-2</td><td style="background-color: #ffffff">7.02</td><td style="background-color: #eeeeee">7.07</td></tr>
<tr><td>test-cbor-decode-3</td><td style="background-color: #ffeeee">(10.10)</td><td style="background-color: #eeeeee">9.80</td></tr>
<tr><td>test-cbor-decode-fastints</td><td style="background-color: #ffffff">1.11</td><td style="background-color: #eeeeee">1.10</td></tr>
<tr><td>test-cbor-decode-largeobj</td><td style="background-color: #ffffff">3.31</td><td style="background-color: #eeeeee">3.34</td></tr>
<tr><td>test-cbor-decode-strings</td><td style="background-color: #ffffff">1.34</td><td style="background-color: #eeeeee">1.34</td></tr>
<tr><td>test-cbor-encode-1</td><td style="background-color: #eeffee">9.12</td><td style="background-color: #eeeeee">9.69</td></tr>
<tr><td>test-cbor-encode-2</td><td style="background-color: #eeffee">13.81</td><td style="background-color: #eeeeee">14.72</td></tr>
<tr><td>test-cbor-encode-3</td><td style="background-color: #eeffee">9.86</td><td style="background-color: #eeeeee">10.57</td></tr>
<tr><td>test-cbor-encode-double</td><td style="background-color: #88ff88; font-weight: bold"><strong>0.94</strong> &#9650;</td><td style="background-color: #eeeeee">1.06</td></tr>
<tr><td>test-cbor-encode-float</td><td style="background-color: #88ff88; font-weight: bold"><strong>0.95</strong> &#9650;</td><td style="background-color: #eeeeee">1.07</td></tr>
<tr><td>test-cbor-encode-half-float</td><td style="background-color: #eeffee">0.99</td><td style="background-color: #eeeeee">1.03</td></tr>
<tr><td>test-cbor-encode-largeobj</td><td style="background-color: #ddffdd"><strong>6.12</strong> &#8657;</td><td style="background-color: #eeeeee">6.62</td></tr>
<tr><td>test-cbor-encode-largestr</td><td style="background-color: #88ff88; font-weight: bold"><strong>1.49</strong> &#9650;</td><td style="background-color: #eeeeee">2.19</td></tr>
<tr><td>test-cbor-encode-simple</td><td style="background-color: #eeffee">4.12</td><td style="background-color: #eeeeee">4.38</td></tr>
<tr><td>test-closure-inner-functions</td><td style="background-color: #88ff88; font-weight: bold"><strong>1.46</strong> &#9650;</td><td style="background-color: #eeeeee">1.76</td></tr>
<tr><td>test-compile-mandel</td><td style="background-color: #ffffff">20.67</td><td style="background-color: #eeeeee">20.80</td></tr>
<tr><td>test-compile-mandel-nofrac</td><td style="background-color: #ffffff">14.00</td><td style="background-color: #eeeeee">14.17</td></tr>
<tr><td>test-compile-short</td><td style="background-color: #eeffee">7.09</td><td style="background-color: #eeeeee">7.32</td></tr>
<tr><td>test-compile-string-ascii</td><td style="background-color: #ffffff">9.54</td><td style="background-color: #eeeeee">9.59</td></tr>
<tr><td>test-continue-fast</td><td style="background-color: #ffffff">5.62</td><td style="background-color: #eeeeee">5.62</td></tr>
<tr><td>test-continue-slow</td><td style="background-color: #ffffff">17.82</td><td style="background-color: #eeeeee">17.90</td></tr>
<tr><td>test-empty-loop</td><td style="background-color: #ffffff">6.36</td><td style="background-color: #eeeeee">6.45</td></tr>
<tr><td>test-empty-loop-slowpath</td><td style="background-color: #ffffff">2.06</td><td style="background-color: #eeeeee">2.03</td></tr>
<tr><td>test-empty-loop-step3</td><td style="background-color: #ffffff">6.39</td><td style="background-color: #eeeeee">6.54</td></tr>
<tr><td>test-enum-basic</td><td style="background-color: #eeffee">5.11</td><td style="background-color: #eeeeee">5.46</td></tr>
<tr><td>test-equals-fastint</td><td style="background-color: #ffeeee">(1.53)</td><td style="background-color: #eeeeee">1.48</td></tr>
<tr><td>test-equals-nonfastint</td><td style="background-color: #ffffff">1.55</td><td style="background-color: #eeeeee">1.53</td></tr>
<tr><td>test-error-create</td><td style="background-color: #ffffff">2.36</td><td style="background-color: #eeeeee">2.36</td></tr>
<tr><td>test-fib-2</td><td style="background-color: #ffffff">5.53</td><td style="background-color: #eeeeee">5.50</td></tr>
<tr><td>test-fib</td><td style="background-color: #ffffff">9.29</td><td style="background-color: #eeeeee">9.07</td></tr>
<tr><td>test-func-bind</td><td style="background-color: #ffffff">2.88</td><td style="background-color: #eeeeee">2.84</td></tr>
<tr><td>test-func-tostring</td><td style="background-color: #ffffff">5.64</td><td style="background-color: #eeeeee">5.56</td></tr>
<tr><td>test-global-lookup</td><td style="background-color: #ffeeee">(12.30)</td><td style="background-color: #eeeeee">11.91</td></tr>
<tr><td>test-hello-world</td><td style="background-color: #ffffff">0.00</td><td style="background-color: #eeeeee">0.00</td></tr>
<tr><td>test-hex-decode</td><td style="background-color: #ffffff">2.73</td><td style="background-color: #eeeeee">2.73</td></tr>
<tr><td>test-hex-encode</td><td style="background-color: #ffffff">2.22</td><td style="background-color: #eeeeee">2.18</td></tr>
<tr><td>test-jc-serialize-indented</td><td style="background-color: #ffffff">5.16</td><td style="background-color: #eeeeee">5.18</td></tr>
<tr><td>test-jc-serialize</td><td style="background-color: #ffffff">2.97</td><td style="background-color: #eeeeee">2.95</td></tr>
<tr><td>test-json-parse-hex</td><td style="background-color: #ffffff">2.58</td><td style="background-color: #eeeeee">2.58</td></tr>
<tr><td>test-json-parse-integer</td><td style="background-color: #ffffff">4.24</td><td style="background-color: #eeeeee">4.32</td></tr>
<tr><td>test-json-parse-number</td><td style="background-color: #ffffff">8.66</td><td style="background-color: #eeeeee">8.49</td></tr>
<tr><td>test-json-parse-string</td><td style="background-color: #ffffff">3.00</td><td style="background-color: #eeeeee">3.00</td></tr>
<tr><td>test-json-serialize-fastpath-loop</td><td style="background-color: #ffffff">5.39</td><td style="background-color: #eeeeee">5.34</td></tr>
<tr><td>test-json-serialize-forceslow</td><td style="background-color: #ffffff">10.69</td><td style="background-color: #eeeeee">10.78</td></tr>
<tr><td>test-json-serialize-hex</td><td style="background-color: #ffffff">1.09</td><td style="background-color: #eeeeee">1.10</td></tr>
<tr><td>test-json-serialize-indented-deep100</td><td style="background-color: #ffffff">2.00</td><td style="background-color: #eeeeee">1.95</td></tr>
<tr><td>test-json-serialize-indented-deep25</td><td style="background-color: #ffffff">5.03</td><td style="background-color: #eeeeee">5.09</td></tr>
<tr><td>test-json-serialize-indented-deep500</td><td style="background-color: #ffffff">1.26</td><td style="background-color: #eeeeee">1.24</td></tr>
<tr><td>test-json-serialize-indented</td><td style="background-color: #ffffff">9.28</td><td style="background-color: #eeeeee">9.31</td></tr>
<tr><td>test-json-serialize-jsonrpc-message</td><td style="background-color: #ffffff">1.38</td><td style="background-color: #eeeeee">1.38</td></tr>
<tr><td>test-json-serialize-largeobj</td><td style="background-color: #ffffff">5.27</td><td style="background-color: #eeeeee">5.14</td></tr>
<tr><td>test-json-serialize-nofrac</td><td style="background-color: #ffffff">0.89</td><td style="background-color: #eeeeee">0.88</td></tr>
<tr><td>test-json-serialize-plainbuf</td><td style="background-color: #ffffff">4.67</td><td style="background-color: #eeeeee">4.58</td></tr>
<tr><td>test-json-serialize-simple</td><td style="background-color: #ffffff">6.80</td><td style="background-color: #eeeeee">6.72</td></tr>
<tr><td>test-json-serialize-slowpath-loop</td><td style="background-color: #ffffff">5.26</td><td style="background-color: #eeeeee">5.31</td></tr>
<tr><td>test-json-string-bench</td><td style="background-color: #ffffff">4.80</td><td style="background-color: #eeeeee">4.71</td></tr>
<tr><td>test-json-string-stringify</td><td style="background-color: #ffffff">4.20</td><td style="background-color: #eeeeee">4.23</td></tr>
<tr><td>test-jx-serialize-bufobj-forceslow</td><td style="background-color: #ffffff">5.52</td><td style="background-color: #eeeeee">5.51</td></tr>
<tr><td>test-jx-serialize-bufobj</td><td style="background-color: #ffffff">1.64</td><td style="background-color: #eeeeee">1.65</td></tr>
<tr><td>test-jx-serialize-indented</td><td style="background-color: #ffffff">5.13</td><td style="background-color: #eeeeee">5.16</td></tr>
<tr><td>test-jx-serialize</td><td style="background-color: #ffffff">2.95</td><td style="background-color: #eeeeee">2.96</td></tr>
<tr><td>test-mandel-iter10-normal</td><td style="background-color: #88ff88; font-weight: bold"><strong>0.08</strong> &#9650;</td><td style="background-color: #eeeeee">0.09</td></tr>
<tr><td>test-mandel-iter10-promise</td><td style="background-color: #ffffff">-</td><td style="background-color: #eeeeee">-</td></tr>
<tr><td>test-mandel</td><td style="background-color: #ffffff">8.71</td><td style="background-color: #eeeeee">8.76</td></tr>
<tr><td>test-mandel-promise</td><td style="background-color: #ffffff">-</td><td style="background-color: #eeeeee">-</td></tr>
<tr><td>test-math-clz32</td><td style="background-color: #ffffff">4.08</td><td style="background-color: #eeeeee">3.97</td></tr>
<tr><td>test-misc-1dcell</td><td style="background-color: #ffffff">7.91</td><td style="background-color: #eeeeee">7.69</td></tr>
<tr><td>test-object-garbage-2</td><td style="background-color: #ffffff">3.70</td><td style="background-color: #eeeeee">3.76</td></tr>
<tr><td>test-object-garbage</td><td style="background-color: #ffffff">7.38</td><td style="background-color: #eeeeee">7.40</td></tr>
<tr><td>test-object-literal-100</td><td style="background-color: #ffffff">10.69</td><td style="background-color: #eeeeee">10.84</td></tr>
<tr><td>test-object-literal-20</td><td style="background-color: #ffffff">2.36</td><td style="background-color: #eeeeee">2.39</td></tr>
<tr><td>test-object-literal-3</td><td style="background-color: #ffffff">0.57</td><td style="background-color: #eeeeee">0.58</td></tr>
<tr><td>test-prop-read-1024</td><td style="background-color: #ffffff">7.85</td><td style="background-color: #eeeeee">7.71</td></tr>
<tr><td>test-prop-read-16</td><td style="background-color: #ffffff">7.84</td><td style="background-color: #eeeeee">7.70</td></tr>
<tr><td>test-prop-read-256</td><td style="background-color: #ffffff">7.85</td><td style="background-color: #eeeeee">7.70</td></tr>
<tr><td>test-prop-read-32</td><td style="background-color: #ffffff">7.82</td><td style="background-color: #eeeeee">7.70</td></tr>
<tr><td>test-prop-read-48</td><td style="background-color: #ffffff">7.84</td><td style="background-color: #eeeeee">7.69</td></tr>
<tr><td>test-prop-read-4</td><td style="background-color: #ffffff">7.88</td><td style="background-color: #eeeeee">7.72</td></tr>
<tr><td>test-prop-read-64</td><td style="background-color: #ffffff">7.82</td><td style="background-color: #eeeeee">7.69</td></tr>
<tr><td>test-prop-read-8</td><td style="background-color: #ffffff">7.82</td><td style="background-color: #eeeeee">7.70</td></tr>
<tr><td>test-prop-read-inherited</td><td style="background-color: #ffffff">9.85</td><td style="background-color: #eeeeee">9.78</td></tr>
<tr><td>test-prop-read</td><td style="background-color: #ffffff">7.92</td><td style="background-color: #eeeeee">7.75</td></tr>
<tr><td>test-prop-write-1024</td><td style="background-color: #ffffff">6.93</td><td style="background-color: #eeeeee">6.84</td></tr>
<tr><td>test-prop-write-16</td><td style="background-color: #ffffff">6.93</td><td style="background-color: #eeeeee">6.82</td></tr>
<tr><td>test-prop-write-256</td><td style="background-color: #ffffff">6.95</td><td style="background-color: #eeeeee">6.82</td></tr>
<tr><td>test-prop-write-32</td><td style="background-color: #ffffff">6.93</td><td style="background-color: #eeeeee">6.82</td></tr>
<tr><td>test-prop-write-48</td><td style="background-color: #ffffff">6.94</td><td style="background-color: #eeeeee">6.83</td></tr>
<tr><td>test-prop-write-4</td><td style="background-color: #ffffff">7.01</td><td style="background-color: #eeeeee">6.85</td></tr>
<tr><td>test-prop-write-64</td><td style="background-color: #ffffff">6.92</td><td style="background-color: #eeeeee">6.81</td></tr>
<tr><td>test-prop-write-8</td><td style="background-color: #ffffff">6.93</td><td style="background-color: #eeeeee">6.80</td></tr>
<tr><td>test-prop-write</td><td style="background-color: #ffffff">7.02</td><td style="background-color: #eeeeee">6.88</td></tr>
<tr><td>test-proxy-get</td><td style="background-color: #ffffff">2.86</td><td style="background-color: #eeeeee">2.80</td></tr>
<tr><td>test-random</td><td style="background-color: #ffeeee">(2.78)</td><td style="background-color: #eeeeee">2.62</td></tr>
<tr><td>test-reflect-ownkeys-sorted</td><td style="background-color: #ffffff">1.32</td><td style="background-color: #eeeeee">1.30</td></tr>
<tr><td>test-reflect-ownkeys-unsorted</td><td style="background-color: #ffffff">1.36</td><td style="background-color: #eeeeee">1.36</td></tr>
<tr><td>test-regexp-case-insensitive-compile</td><td style="background-color: #ff8888; font-weight: bold"><em>(0.84)</em> &#9660;</td><td style="background-color: #eeeeee">0.74</td></tr>
<tr><td>test-regexp-case-insensitive-execute</td><td style="background-color: #ffeeee">(2.50)</td><td style="background-color: #eeeeee">2.37</td></tr>
<tr><td>test-regexp-case-sensitive-compile</td><td style="background-color: #ffeeee">(2.04)</td><td style="background-color: #eeeeee">1.98</td></tr>
<tr><td>test-regexp-case-sensitive-execute</td><td style="background-color: #ffffff">2.00</td><td style="background-color: #eeeeee">2.02</td></tr>
<tr><td>test-regexp-compile</td><td style="background-color: #ffffff">2.84</td><td style="background-color: #eeeeee">2.82</td></tr>
<tr><td>test-regexp-execute</td><td style="background-color: #ffffff">2.34</td><td style="background-color: #eeeeee">2.35</td></tr>
<tr><td>test-regexp-string-parse</td><td style="background-color: #ffffff">13.52</td><td style="background-color: #eeeeee">13.59</td></tr>
<tr><td>test-reg-readwrite-object</td><td style="background-color: #eeffee">7.76</td><td style="background-color: #eeeeee">8.04</td></tr>
<tr><td>test-reg-readwrite-plain</td><td style="background-color: #ffffff">7.73</td><td style="background-color: #eeeeee">7.55</td></tr>
<tr><td>test-strict-equals-fastint</td><td style="background-color: #ffeeee">(1.61)</td><td style="background-color: #eeeeee">1.55</td></tr>
<tr><td>test-strict-equals-nonfastint</td><td style="background-color: #ffffff">1.61</td><td style="background-color: #eeeeee">1.60</td></tr>
<tr><td>test-string-array-concat</td><td style="background-color: #ffffff">14.06</td><td style="background-color: #eeeeee">13.90</td></tr>
<tr><td>test-string-arridx</td><td style="background-color: #ffffff">2.67</td><td style="background-color: #eeeeee">2.64</td></tr>
<tr><td>test-string-charlen-ascii</td><td style="background-color: #ffffff">1.79</td><td style="background-color: #eeeeee">1.82</td></tr>
<tr><td>test-string-charlen-nonascii</td><td style="background-color: #ffffff">2.66</td><td style="background-color: #eeeeee">2.64</td></tr>
<tr><td>test-string-compare</td><td style="background-color: #88ff88; font-weight: bold"><strong>5.81</strong> &#9650;</td><td style="background-color: #eeeeee">7.10</td></tr>
<tr><td>test-string-decodeuri</td><td style="background-color: #ffffff">9.04</td><td style="background-color: #eeeeee">8.83</td></tr>
<tr><td>test-string-encodeuri</td><td style="background-color: #ffffff">8.61</td><td style="background-color: #eeeeee">8.65</td></tr>
<tr><td>test-string-garbage</td><td style="background-color: #ffffff">5.96</td><td style="background-color: #eeeeee">5.91</td></tr>
<tr><td>test-string-intern-grow2</td><td style="background-color: #ffffff">0.89</td><td style="background-color: #eeeeee">0.90</td></tr>
<tr><td>test-string-intern-grow</td><td style="background-color: #ffffff">7.52</td><td style="background-color: #eeeeee">7.50</td></tr>
<tr><td>test-string-intern-grow-short2</td><td style="background-color: #ffffff">5.42</td><td style="background-color: #eeeeee">5.40</td></tr>
<tr><td>test-string-intern-grow-short</td><td style="background-color: #ffffff">5.53</td><td style="background-color: #eeeeee">5.54</td></tr>
<tr><td>test-string-intern-match</td><td style="background-color: #ffffff">0.26</td><td style="background-color: #eeeeee">0.26</td></tr>
<tr><td>test-string-intern-match-short</td><td style="background-color: #ffffff">2.10</td><td style="background-color: #eeeeee">2.11</td></tr>
<tr><td>test-string-intern-miss</td><td style="background-color: #ffeeee">(0.53)</td><td style="background-color: #eeeeee">0.51</td></tr>
<tr><td>test-string-intern-miss-short</td><td style="background-color: #ffffff">2.59</td><td style="background-color: #eeeeee">2.58</td></tr>
<tr><td>test-string-literal-intern</td><td style="background-color: #ffffff">4.96</td><td style="background-color: #eeeeee">4.85</td></tr>
<tr><td>test-string-number-list</td><td style="background-color: #ffffff">0.85</td><td style="background-color: #eeeeee">0.83</td></tr>
<tr><td>test-string-plain-concat</td><td style="background-color: #ffffff">0.90</td><td style="background-color: #eeeeee">0.91</td></tr>
<tr><td>test-string-scan-nonascii</td><td style="background-color: #ff8888; font-weight: bold"><em>(4.64)</em> &#9660;</td><td style="background-color: #eeeeee">4.20</td></tr>
<tr><td>test-string-uppercase</td><td style="background-color: #ffffff">4.39</td><td style="background-color: #eeeeee">4.35</td></tr>
<tr><td>test-symbol-tostring</td><td style="background-color: #ffffff">6.08</td><td style="background-color: #eeeeee">5.99</td></tr>
<tr><td>test-textdecoder-ascii</td><td style="background-color: #ffeeee">(4.18)</td><td style="background-color: #eeeeee">3.98</td></tr>
<tr><td>test-textdecoder-nonascii</td><td style="background-color: #ffffff">2.85</td><td style="background-color: #eeeeee">2.77</td></tr>
<tr><td>test-textencoder-ascii</td><td style="background-color: #ffffff">13.24</td><td style="background-color: #eeeeee">13.30</td></tr>
<tr><td>test-textencoder-nonascii</td><td style="background-color: #ffffff">20.36</td><td style="background-color: #eeeeee">20.42</td></tr>
<tr><td>test-try-catch-nothrow</td><td style="background-color: #ffffff">7.83</td><td style="background-color: #eeeeee">7.91</td></tr>
<tr><td>test-try-catch-throw</td><td style="background-color: #ffffff">43.60</td><td style="background-color: #eeeeee">43.26</td></tr>
<tr><td>test-try-finally-nothrow</td><td style="background-color: #ffffff">9.76</td><td style="background-color: #eeeeee">9.76</td></tr>
<tr><td>test-try-finally-throw</td><td style="background-color: #ffffff">57.75</td><td style="background-color: #eeeeee">57.40</td></tr>
</table>

## Setup

Measurement host:

* "Intel(R) Core(TM) i5-8600K CPU @ 3.60GHz"
  (Changed from previous performance test.)

Duktape is compiled with:

* gcc version 8.3.0 (Debian 8.3.0-6)
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
