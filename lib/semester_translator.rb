require 'active_support'
require 'lookup'

module Cornell
  
  class SemesterTranslator
    attr_reader :year, :semester_code
    attr_writer :semester
    
    def initialize(input = {})
      if input.is_a?(Hash)
        parse_input_hash(input)
      elsif input.is_a?(String)
        parse_input_string(input)
      else
        raise ArgumentError, "Input must be a hash or a string."
      end
    end
    
    # Getter method for the semester name
    # Returns the full, capitalized name of the semester (Fall, Summer, Spring) if we can deduce it
    def semester
      @semester ||= Lookup::ACADEMIC_SEMESTER_CODES[semester_code]
    end
    
    
    def semester_code=(sc)
      @semester_code = sc if Lookup::ACADEMIC_SEMESTER_CODES.include?(sc)
    end
    
    def semester_code
      @semester_code ||= Lookup::ACADEMIC_SEMESTER_CODES.invert[@semester]
    end
    
    # Setter method for the term.
    # The Term is a compound value of a semester abbreviation (S, U, F), and a 2-digit year.
    # Examples are: U99 (Summer 1999), F03 (Fall 2003), etc.
    # This setter will also set values for the semester, semester code, and year, since all the information is contained within
    def term=(t)
      matches = t.match(Lookup::TERM_REGEX)
      if matches
        self.semester = Lookup::TERM_CODES[matches[1]]
        self.semester_code = Lookup::ACADEMIC_SEMESTER_CODES.invert[@semester]
        self.year = matches[2]
        @term = t
      end
    end
    
    # Getter method for the compound term.
    # Constructs the term from the semester and year information, if exists.
    def term
      if @term.blank? && Lookup::TERM_CODES.invert[self.semester] && !year.blank?
        @term = Lookup::TERM_CODES.invert[self.semester] + year.to_s[2,4]
      end
      @term
    end
    
    # Setter method for the year
    # Prefixes the year with the proper 2-digits
    # sets the value as an integer
    def year=(y)
      if y.to_s.size == 2
        y = '19' + y.to_s if y.to_i >= 90 # 1990's
        y = '20' + y.to_s if y.to_i < 90 # 2000's (I guess this will stop working in 2090...)
      end
      @year = y.to_i
    end
    
    private
    
    # Parse a passed string in the format of "{SEMESTER}-{YEAR}" or {SEMESTER} {YEAR}" and send it along to the normal 
    # initialization process.
    def parse_input_string(input)
      matches = input.match(/\A(fall|spring|summer){1}[\-|\s*]([0-9]{4})$/i)
      if matches
        input_params = {:year => matches[2], :semester => matches[1].downcase.capitalize}
      else
        input_params = {}
      end
      parse_input_hash(input_params)
    end
    
    # Initializes the various conversions for our semester values.
    def parse_input_hash(input = {})
      input.reverse_merge! :year => nil, :semester => nil, :semester_code => nil, :term => nil
      self.term = input[:term] if !input[:term].blank?
      self.semester = input[:semester].capitalize if @semester.blank? && input[:semester]
      self.semester_code = input[:semester_code] if @semester_code.blank?
      self.year = input[:year] if @year.blank? && !input[:year].blank?
    end
    
  end
  
end
