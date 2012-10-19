#!/bin/bash
find . -name Root -exec sed -i "" 's/oldusername/newusername/g' {} \;
