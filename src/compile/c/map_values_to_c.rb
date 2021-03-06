require_relative '../../util/not_supported_exception'

class MapValuesToC

  def map(ast)
    if ast.is_a?(Array)
      operator = ast[0]
      if respond_to?(operator)
        send(operator,*ast[1..-1])
      else
        raise NotSupportedException.new("#{operator} in #{ast.inspect} not supported")
      end
    else
      raise NotSupportedException.new("#{ast} not supported")
    end
  end
  
  def blank
    "BLANK"
  end

  def inlined_blank
    "BLANK"
  end
  
  def constant(name)
    name
  end
  
  alias :null :blank
    
  # FIXME: Refactor to do proper integer check
  def number(text)
    case text.to_f
    when 0; "ZERO"
    when 1; "ONE"
    when 2; "TWO"
    when 3; "THREE"
    when 4; "FOUR"
    when 5; "FIVE"
    when 6; "SIX"
    when 7; "SEVEN"
    when 8; "EIGHT"
    when 9; "NINE"
    when 10; "TEN"
    else   
      n = case text.to_s
      when /\./
        text.to_f.to_s
      when /e/i
        text.to_f.to_s
      else
        text.to_i.to_s
      end
      "EXCEL_NUMBER(#{n})"
    end
  end
  
  def percentage(text)
    "EXCEL_NUMBER(#{(text.to_f / 100.0).to_s})"
  end
  
  def string(text)
    "EXCEL_STRING(#{text.inspect})"
  end
  
  ERRORS = {
    "#NAME?" => "NAME",
    "#VALUE!" => "VALUE",
    "#DIV/0!" => "DIV0",
    "#REF!" => "REF",
    "#N/A" => "NA",
    "#NUM!" => "NUM",
    :"#NAME?" => "NAME",
    :"#VALUE!" => "VALUE",
    :"#DIV/0!" => "DIV0",
    :"#REF!" => "REF",
    :"#N/A" => "NA",
    :"#NUM!" => "NUM"
  }
  
  REVERSE_ERRORS = ERRORS.invert
  
  def error(text)
    ERRORS[text] || (raise NotSupportedException.new("#{text.inspect} error not recognised"))
  end
  
  def boolean_true
    "TRUE"
  end
  
  def boolean_false
    "FALSE"
  end
  
end
