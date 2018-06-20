#!/usr/bin/env ruby
# encoding: utf-8

# Copyright 2015-2018, Hörmet Yiltiz <hyiltiz@github.com>
# Released under GNU GPL version 3 or later.

vim = 'nvim'
puts "Testing #{vim} performance..."

PLOT_WIDTH = 64
LOG = "./vim-plugins-profile.#{$$}.log"

XDG_CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || File.join(ENV['HOME'], '.config')

VIMFILES_DIR = File.join(XDG_CONFIG_HOME, 'nvim')
puts "Assuming your vimfiles folder is #{VIMFILES_DIR}."

puts "Generating #{vim} startup profile..."
system(vim, '--startuptime', LOG, '-c', 'q')

plug_dir="plugged"

# parse
exec_times_by_name = Hash.new(0)
lines = File.readlines(LOG).select { |line| line =~ /sourcing.*#{Regexp.escape(plug_dir)}/ }

lines.each do |line|
  trace_time, source_time, exec_time, _, path = line.split(' ')
  name = path.split('plugged/')[1].split('/')[0]
  time = exec_time.to_f
  exec_times_by_name[name] += time
end

# plot
max = exec_times_by_name.values.max
relatives = exec_times_by_name.reduce({}) do |hash, (name, time)|
  hash.merge!(name => time/max.to_f)
end
max_name_length = relatives.keys.map(&:length).max
puts
Hash[ relatives.sort_by { |k, v| -v } ].each do |name, rel_time|
  time = exec_times_by_name[name]
  puts "#{name.rjust(max_name_length)}: (#{time.round(3).to_s.ljust(5)}ms) #{'*' * (rel_time*PLOT_WIDTH)}"
end

File.delete(LOG)
