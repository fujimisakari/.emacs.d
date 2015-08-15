#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys

# PYTHON PATH
path_list = [
    # otherbu
    '{}/.pyenv/versions/otherbu/lib/python2.7/site-packages'.format(os.environ.get('HOME')),
    '{}/dev/otherbu'.format(os.environ.get('HOME')),
    '{}/dev/otherbu/module'.format(os.environ.get('HOME')),
    # media
    '{}/.pyenv/versions/media/lib/python2.7/site-packages'.format(os.environ.get('HOME')),
    '{}/dev/media'.format(os.environ.get('HOME')),
    '{}/dev/media/module'.format(os.environ.get('HOME')),
    # genju
    '{}/projects/genju-hime/application/'.format(os.environ.get('HOME')),
    '{}/projects/genju-hime/application/module'.format(os.environ.get('HOME')),
    '{}/projects/genju-hime/application/website'.format(os.environ.get('HOME')),
    '{}/projects/genju-hime/application/submodule'.format(os.environ.get('HOME')),
    '{}/projects/genju-hime/application/eventmodule'.format(os.environ.get('HOME')),
    '{}.pyenv/versions/genju/lib/python2.7/site-packages'.format(os.environ.get('HOME')),
    # punk
    '{}/.pyenv/versions/punk/lib/python2.7/site-packages'.format(os.environ.get('HOME')),
    '{}/projects/punk_server'.format(os.environ.get('HOME')),
    '{}/projects/punk_server/application'.format(os.environ.get('HOME')),
    '{}/projects/punk_server/application/module'.format(os.environ.get('HOME')),
    '{}/projects/punk_server/application/submodule'.format(os.environ.get('HOME')),
    # preregistration
    '{}/.pyenv/versions/preregistration/lib/python2.7/site-packages'.format(os.environ.get('HOME')),
    '{}/projects/preregistration'.format(os.environ.get('HOME')),
    '{}/projects/preregistration/application'.format(os.environ.get('HOME')),
    '{}/projects/preregistration/application/apps'.format(os.environ.get('HOME')),
    '{}/projects/preregistration/application/module'.format(os.environ.get('HOME')),
    '{}/projects/preregistration/application/submodule'.format(os.environ.get('HOME')),
]


def genarate_path_for_emacs():
    text_format = '(setenv "{}" "{}")'

    # PATH
    print text_format.format('PATH', os.environ.get('PATH'))

    # PYTHONPATH
    # set_list = []
    # for path in path_list:
    #     if os.path.exists(path):
    #         set_list.append(path)
    # print text_format.format('PYTHONPATH', ':'.join(set_list))


def genarate_path_for_pylint():
    text_format = """#! /usr/bin/env python

import sys
"""

    for path in path_list:
        if os.path.exists(path):
            text_format += 'sys.path.append("{}")\n'.format(path)

    print text_format


if __name__ == '__main__':
    if sys.argv:
        exe_type = sys.argv[1]
        if exe_type == 'emacs':
            genarate_path_for_emacs()
        elif exe_type == 'pylint':
            genarate_path_for_pylint()
