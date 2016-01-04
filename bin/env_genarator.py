#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys


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


if __name__ == '__main__':
    if sys.argv:
        exe_type = sys.argv[1]
        if exe_type == 'emacs':
            genarate_path_for_emacs()
