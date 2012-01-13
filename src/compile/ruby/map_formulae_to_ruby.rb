require_relative 'map_values_to_ruby'

class MapFormulaeToRuby < MapValuesToRuby
  
  attr_accessor :sheet_names
  
  FUNCTIONS = {
    '+' => 'add',
    '-' => 'subtract',
    '*' => 'multiply',
    '/' => 'divide',
    '^' => 'power',
    'COSH' => 'cosh',
    'PI' => 'pi',
    'SUM' => 'sum'
  }
  
  def arithmetic(left,operator,right)
    "#{FUNCTIONS[operator.last]}(#{map(left)},#{map(right)})"
  end
  
  def function(function_name,*arguments)
    if FUNCTIONS.has_key?(function_name)
      "#{FUNCTIONS[function_name]}(#{arguments.map { |a| map(a) }.join(",")})"
    else
      raise NotSupportedException.new("Function #{function_name} not supported")
    end
  end
  
  def cell(reference)
    reference.downcase
  end
  
  def sheet_reference(sheet,reference)
    puts "Looking for #{sheet.inspect} in #{sheet_names.inspect}"
    "#{sheet_names[sheet]}.#{map(reference)}"
  end
  
  alias :quoted_sheet_reference :sheet_reference

end
