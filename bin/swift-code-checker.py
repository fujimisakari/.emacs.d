#! /usr/bin/env python
# coding: utf-8

import re
from commands import getoutput
from optparse import OptionParser

# パラメータ設定
usage = "usage: %prog [options]"
parser = OptionParser(usage, version="ver:%s" % "%prog 1.0")
parser.add_option('-b', '--root-path', dest='root_path')
parser.add_option('-t', '--targetfile', dest='target_file')
parser.add_option('-o', '--objcheader', dest='objc_header')
opts, args = parser.parse_args()

# swift_option_list = []

# swift_option_list.append('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift')
# swift_option_list.append('-frontend -parse')
# swift_option_list.append('-sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk')
# swift_option_list.append('-F libPods.a')
# swift_option_list.append('-parse')
# swift_option_list.append('-DDEBUG=1')
# swift_option_list.append('-target i386-apple-ios8.1')
# if opts.objc_header:
#     swift_option_list.append('-import-objc-header')
#     swift_option_list.append(opts.objc_header)

# # Pods配下のswiftコードをimportする
# regex = r'find {}/Pods -name "*.swift" | sed -e "s/^\(.*\/\).*/\1/" | uniq | sed -e "s/^\.//"'
# result = getoutput(regex.format(opts.root_path))
# include_list = [u'-I {}'.format(x.replace(' ', r'\ ')) for x in result.split('\n')]
# include_str = ' '.join(include_list)
# # swift_option_list.append('-I /Users/fujimo/dev/swift/Todo/Pods')
# # swift_option_list.append('-L /Users/fujimo/dev/swift/Todo/Pods')

# # # iOS標準クラスのヘッダーがあるディレクトリ指定(独自ヘッダー)
# # regex = r"find {} -name '*.h' | sed -e 's/^\(.*\/\).*/\1/' | uniq | sed -e 's/^\.//' | grep -v '_frameworks'"
# # result = getoutput(regex.format(opts.root_path))
# # include_list = [u'-I {}'.format(x.replace(' ', r'\ ')) for x in result.split('\n')]
# # include_str = ' '.join(include_list)
# # swift_option_list.append(include_str)

# # code-checkの対象ファイル
# swift_option_list.append(opts.target_file)

# チェックコマンド実行
project_name = opts.root_path.split('/')[-1].capitalize()
swift_option_list = ['xctool',
                     '-project',
                     '{}/{}.xcodeproj'.format(opts.root_path, project_name),
                     '-scheme', project_name,
                     '-sdk', 'iphonesimulator',
                     '-reporter', 'plain',
                     'build']
command_result = getoutput(' '.join(swift_option_list))
command_result = command_result.split('Failures:')[0]

# コマンド結果を整形
result_list = []
result_filter = re.compile(r'^.+swift:[0-9]+:[0-9]+:.*')
file_name = opts.target_file.split('_')[0]
for row_text in command_result.split('\n'):
    if result_filter.match(row_text) and file_name in row_text:
        result_list.append(row_text)
print('\n'.join(result_list))
