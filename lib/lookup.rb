module Cornell
  class SemesterTranslator
    # This module contains various constants that apply to the various ways of defining
    # semesters at Cornell University.
    module Lookup
      ACADEMIC_SEMESTER_CODES = {
        10 => 'Winter',
        11 => 'Winter Transfer Credit',
        20 => 'Spring',
        21 => 'Spring Transfer Credit',
        22 => 'Spring Transfer Credit',
        23 => 'Spring Transfer Credit',
        30 => '3 Week',
        35 => 'Sum E',
        40 => '6 Week',
        50 => '8 Week',
        60 => 'Special',
        65 => 'Summer',
        66 => 'Summer Transfer Credit',
        67 => 'Summer Transfer Credit',
        68 => 'Summer Transfer Credit',
        70 => 'Fall',
        71 => 'Fall Transfer Credit',
        72 => 'Fall Transfer Credit'      
      }
    
      TERM_CODES = {
        'S' => 'Spring',
        'U' => 'Summer',
        'F' => 'Fall'
      }
    
      SEMESTER_NAMES = ['Spring','Summer','Fall']
    
      TERM_REGEX     = /^([USF]{1})([0-9]{2})$/

    end

  end
end