#! /bin/bash

# ~/.pyenv/shims/epylint "$1" 2>/dev/null
# ~/.pyenv/shims/pylint -f parseable -r n --disable=C,R,I --msg-template="{path}:{line}: {category} ({msg_id}, {symbol}, {obj}) {msg}" "$1" 2>/dev/null
~/.pyenv/shims/pylint -f parseable -r n --msg-template="{path}:{line}: {category} ({msg_id}, {symbol}, {obj}) {msg}" "$1" 2>/dev/null
~/.pyenv/shims/pyflakes "$1"
# ~/.pyenv/shims/pep8 --ignore=E221,E501,E701,E202 --repeat "$1"
~/.pyenv/shims/pep8 --ignore=E501 --repeat "$1"

true
