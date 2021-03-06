# Lib files

## Overview

Files in the `lib` directory are intended to be sourced by larger scripts.

As such they should not include a `#!/bin/bash` header nor be directly executed.

Due to the lack of the header, the files should be named with a `sh` extension to help with file type recognition.

## Ensuring lib scripts are sourced only once

Use parameter expansion to determine if a guard variable is set.

``` sh
# Parameter expansion
# ${parameter+word}
# Substitute word in all cases except for parameter being unset
if [ -z ${var+x} ]; then
    echo "var is unset"
else
    echo "var is set to '$var'"
fi
```

This allows for the following guard clause.

```sh
# Note the explicit return as by default it will return 1 from the test
[ -z "${__SCRIPT_NAME__+.}" ] && readonly __SCRIPT_NAME__= || return 0
```
