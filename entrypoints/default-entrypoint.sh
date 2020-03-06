#!/bin/bash

# Execute entrypoint script
echo "**Yay! Testing for ${OS_VERSION}!**" > /tmp/testing.txt
chmod u=rw,g=r,o=r /tmp/testing.txt
