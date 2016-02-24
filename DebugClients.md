# Known Duktape debug client implementations

If you've implemented a debug client or integrated Duktape debugging with your
project, open an issue on the Duktape Wiki to be added here.

Table columns:

- "Debug client/proxy" links to main page of the debug client or proxy.
- "Transport" describes the transport(s) supported by the debug client.
- "Protocol" indicates how the debug client talks to Duktape: either "binary" for direct implementation of the binary dvalue protocol, or "json" if the debug client relies on the JSON proxy.
- "Description" provides additional information.

<table>
<tr>
<th>Debug client/proxy</th>
<th>Transport</th>
<th>Protocol</th>
<th>Description</th>
</tr>
<tr>
<td><a href="https://github.com/svaarala/duktape/tree/master/debugger/duk_debug.js">duk_debug.js</a></td>
<td>TCP</td>
<td>binary</td>
<td><code>duk_debug.js</code> provides a Node.js based combined debug client and web UI.  Bundled with Duktape.</td>
</tr>
<tr>
<td><a href="https://github.com/svaarala/duktape/tree/master/debugger/duk_debug.js">duk_debug.js</a></td>
<td>TCP</td>
<td>binary</td>
<td><code>duk_debug.js</code> also provides a Node.js based JSON debug proxy.  Bundled with Duktape.</td>
</tr>
<tr>
<td><a href="https://github.com/svaarala/duktape/tree/master/debugger/duk_debug_proxy.js">duk_debug_proxy.js</a></td>
<td>TCP</td>
<td>binary</td>
<td>A JSON debug proxy written in <a href="https://github.com/creationix/dukluv">DukLuv</a>, should be quite portable and easy to bundle with your application (DukLuv is also MIT licensed).  Bundled with Duktape.</td>
</tr>
<tr>
<td><a href="https://wiki.allseenalliance.org/develop/hackfests/alljoyn-js">AllJoyn.js</a></td>
<td>AllJoyn custom</td>
<td>binary</td>
<td>Provides both a console and a Python UI.  Debug transport is local to target and exposes an AllJoyn schema for debugging.</td>
</tr>
<tr>
<td><a href="http://forums.spheredev.org/index.php/topic,1215.0.html">Minisphere</a></td>
<td>TCP</td>
<td>binary</td>
<td><a href="https://github.com/fatcerberus/minisphere">Minisphere</a> provides both a GUI and console debug clients.
Screenshots:
<a href="https://camo.githubusercontent.com/60a760f4841d6ee438b15767ca55128df7ecaf5d/687474703a2f2f693137322e70686f746f6275636b65742e636f6d2f616c62756d732f7732342f6661746365726265727573312f72616e67656572726f722e706e67">screenshot1</a>,
<a href="https://drive.google.com/folderview?id=0BxPKLRqQOUSNbFRvenU1V2hkYjQ&usp=drive_web">screenshot2</a>,
<a href="https://camo.githubusercontent.com/086d09f4bbf7c59cc41dbc3a8eb9d50aa2b73fa3/687474703a2f2f692e696d6775722e636f6d2f796b75387652482e706e67">screenshot3</a>.</td>
</tr>
<tr>
<td><a href="https://github.com/dzzie/duk4vb">duk4vb</a></td>
<td>TCP</td>
<td>binary</td>
<td>Debugger for Duktape running with Visual Basic 6.
Screenshots:
<a href="https://raw.githubusercontent.com/dzzie/duk4vb/master/vb_examples/with_debug/screenshot.png">screenshot1</a>.</td>
</tr>
<tr>
<td><a href="https://github.com/harold-b/musashi-vscode-deubgger">Musashi debugger</a></td>
<td>TCP</td>
<td>binary</td>
<td>Visual Studio Code debugger extension for Duktape runtime.  Screenshots:
<a href="https://github.com/harold-b/musashi-vscode-deubgger/blob/master/img/musa-debug.gif">screenshot1</a>.</td>
</tr>
</table>
