#! /bin/bash

if [ "$3" ]; then
  ~/.emacs.d/bin/swift-code-checker.py --root-path "$1" --targetfile "$2" --objcheader "$3"
else
  ~/.emacs.d/bin/swift-code-checker.py --root-path "$1" --targetfile "$2"
fi

cd "$1" && swiftlint | grep "$2"
