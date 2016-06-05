#!/bin/sh

cat <<EOF
Content-type: text/html

<h1>env</h1>
<pre>$(env)</pre>
EOF
