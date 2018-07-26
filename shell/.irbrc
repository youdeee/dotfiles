require 'irb/completion'
require 'irb/ext/save-history'
require 'rubygems'
require 'activesupport'
require 'pp'
require 'what_methods' # what? でメソッドを調べる
require 'wirble' # カラーリングの設定

IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb_history')
IRB.conf[:AUTO_INDENT]=true

Wirble.init
Wirble.colorize