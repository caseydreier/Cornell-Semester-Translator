require 'test_helper'

module Cornell
  
  class SemesterTranslatorTest < ActiveSupport::TestCase
    
    test "should raise an error if input parameter is anything but a hash or a string" do
      assert_raise ArgumentError do
        sem = SemesterTranslator.new(["I am not", "a valid parameter"])
      end
    end
    
    test "should return year 2009 and semester name from given term" do
      sem = SemesterTranslator.new(:term => 'U09')
      assert_equal 'Summer', sem.semester
      assert_equal '2009', sem.year.to_s
    end
    
    test "should return a year from 1990's and proper semester name from given term only" do
      sem = SemesterTranslator.new(:term => 'F96')
      assert_equal 'Fall', sem.semester
      assert_equal '1996', sem.year.to_s      
    end
    
    test "providing a term should overwrite other values when passed into the method" do
      sem = SemesterTranslator.new(:term => 'S08', :year => "2000")
      assert_equal 'Spring', sem.semester
      assert_equal '2008', sem.year.to_s
    end
    
    test "passing an invalid term should return nil for everything" do
      sem = SemesterTranslator.new(:term => 'Fall09')
      assert_nil sem.year
      assert_nil sem.semester
      assert_nil sem.term
      assert_nil sem.semester_code
    end
    
    test "given only a year, return nils from methods asking for a semester" do
       sem = SemesterTranslator.new(:year => '2000')
       assert_equal 2000,sem.year
       assert_nil sem.semester
       assert_nil sem.term
       assert_nil sem.semester_code
    end
    
    test "providing a semester code should also return equivalent values for semester name, but not term or year" do
      sem = SemesterTranslator.new(:semester_code => 70)
      assert_equal 'Fall', sem.semester
      assert_nil sem.term
      assert_nil sem.year
    end
    
    test "given a semester name, we should also return semester code" do
      sem = SemesterTranslator.new(:semester => 'Fall')
      assert_equal 70, sem.semester_code
      assert_nil sem.term
      assert_nil sem.year      
    end
    
    test "given a semester code and a year, we should have a full set of translations" do
      sem = SemesterTranslator.new(:semester_code => 70, :year => '2009')
      assert_equal 70, sem.semester_code
      assert_equal 'Fall', sem.semester
      assert_equal 'F09', sem.term
      assert_equal 2009, sem.year
    end
    
    test "given a string in the format of 'semester'-'year', return a full set of conversions" do
      sem = SemesterTranslator.new('Fall-2007')
      assert_equal 'Fall', sem.semester
      assert_equal '2007', sem.year.to_s   
      assert_equal 'F07', sem.term
      assert_equal 70, sem.semester_code   
    end
    
    test "the string input type should work regardless of case, or if there's a space or a hyphen in the middle" do
      sem = SemesterTranslator.new('SPRING-2004')
      assert_equal 'Spring', sem.semester
      assert_equal '2004', sem.year.to_s   
      assert_equal 'S04', sem.term
      assert_equal 20, sem.semester_code
      
      sem = SemesterTranslator.new('SuMMeR 1999')
      assert_equal 'Summer', sem.semester
      assert_equal '1999', sem.year.to_s   
      assert_equal 'U99', sem.term
      assert_equal 65, sem.semester_code
    end
    
  end
  
end

