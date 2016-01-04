#! /usr/bin/env python
# coding: utf-8

from commands import getoutput
from optparse import OptionParser

# パラメータ設定
usage = "usage: %prog [options]"
parser = OptionParser(usage, version="ver:%s" % "%prog 1.0")
parser.add_option('-t', '--targetfile', dest='target_file')
parser.add_option('-o', '--objcheader', dest='objc_header')
opts, args = parser.parse_args()

swift_option_list = []

swift_option_list.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift')
swift_option_list.append('-frontend -parse')
swift_option_list.append('-sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk')
swift_option_list.append('-F libPods.a')
swift_option_list.append('-target i386-apple-ios8.1')
if opts.objc_header:
    swift_option_list.append('-import-objc-header')
    swift_option_list.append(opts.objc_header)

# flymakeの対象ファイル
swift_option_list.append(opts.target_file)

# コマンド実行
print ' '.join(swift_option_list)
flymake_result = getoutput(' '.join(swift_option_list))
print flymake_result
