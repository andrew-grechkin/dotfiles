#!/usr/bin/env ruby

require 'json'
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

def method
  case $options[:compact]
  when true then :generate
  else :pretty_generate
  end
end

buf = []

ARGF.each_line do |line|
  if !buf.empty? && line.start_with?('---')
    $options[:compact] = true
    puts JSON.generate(YAML.safe_load(buf.join(''), permitted_classes: [Date]))
    buf = []
  else
    buf << line
  end
end

puts JSON.send(method, YAML.safe_load(buf.join(''), permitted_classes: [Date]))
