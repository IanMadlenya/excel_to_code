require_relative "map_values_to_ruby"

class CompileToRubyUnitTest
  

  attr_accessor :epsilon
  attr_accessor :delta

  def initialize
    @epsilon = 0.002
    @delta = 0.002
  end

  def self.rewrite(*args)
    self.new.rewrite(*args)
  end
  
  def rewrite(input, sloppy, sheet_names, constants,  o)
    mapper = MapValuesToRuby.new
    mapper.constants = constants
    input.each do |ref, ast|
      worksheet_c_name = sheet_names[ref.first.to_s] || ref.first.to_s #FIXME: Need to make it the actual c_name
      cell = ref.last
      value = mapper.map(ast)
      full_reference = worksheet_c_name.length > 0 ? "worksheet.#{worksheet_c_name}_#{cell.downcase}" : "worksheet.#{cell.downcase}"
      test_name = "test_#{worksheet_c_name}_#{cell.downcase}"
      if ast.first == :constant
        type = constants[ast[1]][0] || :constant
      else
        type = ast.first
      end

      case type
      when :blank
        if sloppy
          o.puts "  def #{test_name}; assert_includes([nil, 0], #{full_reference}); end"
        else
          o.puts "  def #{test_name}; assert_equal(#{value}, #{full_reference}); end"
        end
      when :string
        o.puts "  def #{test_name}; assert_equal(#{value.gsub(/(\\n|\\r|\r|\n)+/,'')}, #{full_reference}.to_s.gsub(/[\\n\\r]+/,'')); end"
      when :number
        if sloppy
          if value.to_f.abs <= 1
            if value.to_f == 0 
              o.puts "  def #{test_name}; assert_in_delta(#{value}, (#{full_reference}||0), #{delta}); end"
            else
              o.puts "  def #{test_name}; assert_in_delta(#{value}, #{full_reference}, #{delta}); end"
            end
          else
            o.puts "  def #{test_name}; assert_in_epsilon(#{value}, #{full_reference}, #{epsilon}); end"
          end
        else
          o.puts "  def #{test_name}; assert_equal(#{value}, #{full_reference}); end"
        end
      else
        o.puts "  def #{test_name}; assert_equal(#{value}, #{full_reference}); end"
      end
    end
  end
  
end
