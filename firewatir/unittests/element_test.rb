# feature tests for Tables
# revision: $Revision: 1.0 $

require 'test/unit'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class ElementTest < Test::Unit::TestCase  
  def setup
    goto_page("table_bodies.html")
  end

  #TODO: These tests should be rewritten using mocks.
  #I do not know which mock framework to use in FireWatir, so will do it later
  
  def test_get_collection_jssh_names
    table = browser.table(:id, "table_with_two_bodies")
    table.locate
    
    jssh_names = table.get_collection_jssh_names('tBodies')
    
    assert_equal 2, jssh_names.length    
    assert_equal table.element_name + ".tBodies[0]", jssh_names[0]
    assert_equal table.element_name + ".tBodies[1]", jssh_names[1]
  end
  
  def test_get_collection_length
    table_with_one_body = browser.table(:id, "table_with_one_body")
    table_with_one_body.locate
        
    assert_equal 1, table_with_one_body.get_collection_length('tBodies')
    
    table_with_two_bodies = browser.table(:id, "table_with_two_bodies")
    table_with_two_bodies.locate
    
    assert_equal 2, table_with_two_bodies.get_collection_length('tBodies')
  end
    
end