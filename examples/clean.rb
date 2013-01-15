require 'ffi'
require 'fileutils'
include FileUtils

exit unless File.expand_path(Dir.pwd) == File.expand_path(File.dirname(__FILE__))

rm_f "Makefile"

%w{blank eu-html make_html make_html-html eu smallnumbers stringexample getsetranges excelspreadsheet}.each do |name|
  rm_f "#{name}.c"
  rm_f "#{name}.o"
  rm_f "#{name}.rb"
  rm_f FFI.map_library_name(name)
  rm_f "test_#{name}.rb"
  rm_rf name
end
  
