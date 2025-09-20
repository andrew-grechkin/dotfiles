#!/usr/bin/env ruby

# TBH json core gem is a piece of garbage in ruby, a bit disappointing
# yaml module as well but it's a different story
# require 'json'

require 'json-dump'
require 'optparse'
require 'yaml'

$options = {}

OptionParser.new do |opts|
  opts.banner = 'Usage: yaml2json [options] [file]...'

  opts.on('-c', '--compact-output', 'Compact output') do
    $options[:compact] = true
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

buf = []

ARGF.each_line do |line|
  if !buf.empty? && line.start_with?('---')
    $options[:compact] = true
    puts JSONDump.dump(YAML.safe_load(buf.join(''), permitted_classes: [Date]))
    buf = []
  else
    buf << line
  end
end

puts JSONDump.dump(
  YAML.safe_load(buf.join(''), permitted_classes: [Date]),
  pretty: !$options[:compact]
)
