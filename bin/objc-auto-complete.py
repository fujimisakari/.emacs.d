#! /usr/bin/env python
# coding: utf-8

from commands import getoutput
from optparse import OptionParser

# パラメータ設定
usage = "usage: %prog [options]"
parser = OptionParser(usage, version="ver:%s" % "%prog 1.0")
parser.add_option('-b', '--root-path', dest='root_path')
parser.add_option('-t', '--targetfile', dest='target_file')
parser.add_option('-f', '--framework', dest='framework')
parser.add_option('-s', '--sdk', dest='sdk')
parser.add_option('-p', '--pch', dest='pch')
opts, args = parser.parse_args()

clang_option_list = []

clang_option_list.append('-cc1')

# ターゲットがiOS 7 以上であることを示す
clang_option_list.append('-D__IPHONE_OS_VERSION_MIN_REQUIRED=70000')

# ARCを使用している場合に指定するオプション
clang_option_list.append('-fobjc-arc')

# ブロック構文を利用している場合に指定するオプション
clang_option_list.append('-fblocks')

# とりあえず入れとけてきなやつ
# clang_option_list.append('-fno-color-diagnostics')
clang_option_list.append('-Wreturn-type')
clang_option_list.append('-Wparentheses')
clang_option_list.append('-Wswitch')
clang_option_list.append('-Wno-unused-parameter')
clang_option_list.append('-Wunused-variable')
clang_option_list.append('-Wunused-value')

# iOS標準のフレームワークがあるディレクトリ指定
clang_option_list.append('-F')
clang_option_list.append(opts.framework)

# iOS標準のSDKがあるディレクトリ指定
clang_option_list.append('-isysroot')
clang_option_list.append(opts.sdk)

# プロジェクト内のpch（プリコンパイルヘッダ）のinclude
if opts.pch:
    clang_option_list.append('-include')
    clang_option_list.append(opts.pch)

# iOS標準クラスのヘッダーがあるディレクトリ指定(独自ヘッダー)
result = getoutput(r"find {} -name '*.h' | sed -e 's/^\(.*\/\).*/\1/' | uniq | sed -e 's/^\.//'".format(opts.root_path))
header_list = [x for x in result.split('\n')]
for header in header_list:
    clang_option_list.append("-I")
    clang_option_list.append(header)

print(','.join(clang_option_list))
