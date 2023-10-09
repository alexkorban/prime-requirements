require 'test_helper'

class NumberedTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  test "extract_class_and_seq" do
    class A; include Numbered; end
    assert_equal([HighLevelReq, "HLR15"], A.new.extract_class_and_seq("HLR15"))
    assert_equal([BusinessReq, "BR1554345"], A.new.extract_class_and_seq("BR1554345: bla bla"))
    assert_equal([UseCase, "UC1"], A.new.extract_class_and_seq("UC1: use case"))
    assert_equal([Component, "C5"], A.new.extract_class_and_seq("C5"))
  end
end
