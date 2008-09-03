# feature tests for Select Boxes
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_SelectList < Test::Unit::TestCase
  include Watir::Exception
  
  def setup
    goto_page "selectboxes1.html"
  end
  
  def test_SelectList_exists
    assert(browser.select_list(:name, "sel1").exists?)   
    assert(!browser.select_list(:name, "missing").exists?)   
    assert(!browser.select_list(:id, "missing").exists?)   
  end
  
  def test_SelectList_enabled
    assert(browser.select_list(:name, "sel1").enabled?)   
    assert_raises(UnknownObjectException) { browser.selectBox(:name, "NoName").enabled? }  
    assert(!browser.select_list(:id, 'selectbox_4').enabled?)
  end
  
  def test_SelectList_class_name
    assert_raises(UnknownObjectException) { browser.select_list(:name, "missing").class_name }  
    assert_equal("list_style" , browser.select_list(:name, "sel1").class_name)   
    assert_equal("" , browser.selectBox(:name, "sel2").class_name  )
  end
  
  def test_Option_text_select
    assert_raises(UnknownObjectException) { browser.select_list(:name, "sel1").option(:text, "missing item").select }  
    assert_raises(UnknownObjectException) { browser.select_list(:name, "sel1").option(:text, /missing/).select }  
    assert_raises(MissingWayOfFindingObjectException) { browser.select_list(:name, "sel1").option(:missing, "Option 1").select }
    
    # the select method keeps any currently selected items - use the clear selection method first
    browser.select_list( :name , "sel1").clearSelection
    browser.select_list( :name , "sel1").option(:text, "Option 1").select
    assert_equal( ["Option 1" ] , browser.select_list(:name, "sel1").getSelectedItems)   
  end    
  
  def xtest_option_class_name
    # the option object doesnt inherit from element, so this doesnt work
    assert_raises(UnknownObjectException) { browser.select_list(:name, "sel1").option(:text, "missing item").class_name }  
    assert_equal("list_style" , browser.select_list(:name, "sel2").option(:value , 'o2').class_name)   
    assert_equal("" , browser.select_list(:name, "sel2").option(:value , 'o1').class_name)   
  end
  
  def test_includes
    assert browser.select_list(:name, 'sel1').includes?('Option 1')
    assert ! browser.select_list(:name, 'sel1').includes?('Option 6')
  end  
  
  def test_selected
    assert ! browser.select_list(:name, 'sel1').selected?('Option 1')
    assert browser.select_list(:name, 'sel1').selected?('Option 3')
  end
  
  def test_selected_not_found
    selectbox = browser.select_list(:name, 'sel1')
    assert_raises(Watir::Exception::UnknownObjectException) {selectbox.selected?('Option Not Exists')}
  end
    
end

# Tests for the old interface
class TC_Selectbox < Test::Unit::TestCase
  include Watir::Exception
  
  def setup
    goto_page "selectboxes1.html"
  end
  
  def test_selectBox_Exists
    assert(browser.selectBox(:name, "sel1").exists?)   
    assert(!browser.selectBox(:name, "missing").exists?)   
    assert(!browser.selectBox(:id, "missing").exists?)   
  end
  
  def test_selectBox_enabled
    assert(browser.selectBox(:name, "sel1").enabled?)   
    assert_raises(UnknownObjectException) { browser.selectBox(:name, "NoName").enabled? }  
  end
  
  def test_SelectList_class_name
    assert_raises(UnknownObjectException) { browser.select_list(:name, "missing").class_name }  
    assert_equal("list_style" , browser.select_list(:name, "sel1").class_name)   
    assert_equal("" , browser.selectBox(:name, "sel2").class_name  )
  end
  
  def test_selectBox_getAllContents
    assert_raises(UnknownObjectException) { browser.selectBox(:name, "NoName").getAllContents }  
    assert_equal( ["Option 1" ,"Option 2" , "Option 3" , "Option 4"] , 
    browser.selectBox(:name, "sel1").getAllContents)   
  end
  
  def test_selectBox_getSelectedItems
    assert_raises(UnknownObjectException) { browser.selectBox(:name, "NoName").getSelectedItems }  
    assert_equal( ["Option 3" ] , 
    browser.selectBox(:name, "sel1").getSelectedItems)   
    assert_equal( ["Option 3" , "Option 6" ] , 
    browser.selectBox(:name, "sel2").getSelectedItems)   
  end
  
  def test_clearSelection
    assert_raises(UnknownObjectException) { browser.selectBox(:name, "NoName").clearSelection }  
    browser.selectBox( :name , "sel1").clearSelection
    
    # the box sel1 has no ability to have a de-selected item
    assert_equal( ["Option 3" ] , browser.selectBox(:name, "sel1").getSelectedItems)   
    
    browser.selectBox( :name , "sel2").clearSelection
    assert_equal( [ ] , browser.selectBox(:name, "sel2").getSelectedItems)   
  end
  
  def test_selectBox_select
    assert_raises(NoValueFoundException) { browser.selectBox(:name, "sel1").select("missing item") }  
    assert_raises(NoValueFoundException) { browser.selectBox(:name, "sel1").select(/missing/) }  
    
    # the select method keeps any currently selected items - use the clear selectcion method first
    browser.selectBox( :name , "sel1").clearSelection
    browser.selectBox( :name , "sel1").select("Option 1")
    assert_equal( ["Option 1" ] , browser.selectBox(:name, "sel1").getSelectedItems)   
    
    browser.selectBox( :name , "sel1").clearSelection
    browser.selectBox( :name , "sel1").select(/2/)
    assert_equal( ["Option 2" ] , browser.selectBox(:name, "sel1").getSelectedItems)   
    
    browser.selectBox( :name , "sel2").clearSelection
    browser.selectBox( :name , "sel2").select(/2/)
    browser.selectBox( :name , "sel2").select(/4/)
    assert_equal( ["Option 2" , "Option 4" ] , 
    browser.selectBox(:name, "sel2").getSelectedItems)   
    
    # these are to test the onchange event
    # the event shouldnt get fired, as this is the selected item
    browser.selectBox( :name , "sel3").select( /3/ )
    assert(!browser.text.include?("Pass") )
  end
  
  def test_selectBox_select2
    # the event should get fired
    browser.selectBox( :name , "sel3").select( /2/ )
    assert(browser.text.include?("PASS") )
  end
  
  def test_selectBox_select_using_value
    assert_raises(UnknownObjectException) { browser.select_list(:name, "NoName").getSelectedItems }  
    assert_raises(NoValueFoundException) { browser.select_list(:name, "sel1").select_value("missing item") }  
    assert_raises(NoValueFoundException) { browser.select_list(:name, "sel1").select_value(/missing/) }  
    
    # the select method keeps any currently selected items - use the clear selectcion method first
    browser.select_list( :name , "sel1").clearSelection
    browser.select_list( :name , "sel1").select_value("o1")
    assert_equal( ["Option 1" ] , browser.select_list(:name, "sel1").getSelectedItems)   
    
    browser.select_list( :name , "sel1").clearSelection
    browser.select_list( :name , "sel1").select_value(/2/)
    assert_equal( ["Option 2" ] , browser.select_list(:name, "sel1").getSelectedItems)   
    
    browser.select_list( :name , "sel2").clearSelection
    browser.select_list( :name , "sel2").select_value(/4/)
    browser.select_list( :name , "sel2").select_value(/2/)
    assert_equal( ["Option 2" , "Option 4" ] , 
    browser.select_list(:name, "sel2").getSelectedItems)   
    
    # these are to test the onchange event
    # the event shouldnt get fired, as this is the selected item
    browser.select_list( :name , "sel3").select_value( /3/ )
    assert(!browser.text.include?("Pass") )
  end
  
  def test_select_list_select_using_value2
    # the event should get fired
    browser.select_list( :name , "sel3").select_value( /2/ )
    assert(browser.text.include?("PASS") )
  end
  
  def test_select_list_properties
    assert_raises(UnknownObjectException) { browser.select_list(:index, 199).value }  
    assert_raises(UnknownObjectException) { browser.select_list(:index, 199).name }  
    assert_raises(UnknownObjectException) { browser.select_list(:index, 199).id }  
    assert_raises(UnknownObjectException) { browser.select_list(:index, 199).disabled }  
    assert_raises(UnknownObjectException) { browser.select_list(:index, 199).type }  
    
    assert_equal("o3"   ,    browser.select_list(:index, 1).value)  
    assert_equal("sel1" ,    browser.select_list(:index, 1).name )  
    assert_equal(""     ,    browser.select_list(:index, 1).id )  
    assert_equal("select-one",         browser.select_list(:index, 1).type )  
    assert_equal("select-multiple",    browser.select_list(:index, 2).type )  
    
    browser.select_list(:index,1).select(/1/)
    assert_equal("o1"   ,    browser.select_list(:index, 1).value)  
    
    assert(! browser.select_list(:index, 1).disabled )
    assert( browser.select_list(:index, 4).disabled )
    assert( browser.select_list(:id, 'selectbox_4').disabled )
  end
  
  def test_select_list_iterator
    assert_equal(4, browser.select_lists.length)
    assert_equal("o3"   ,    browser.select_lists[1].value)  
    assert_equal("sel1" ,    browser.select_lists[1].name )  
    assert_equal("select-one",         browser.select_lists[1].type )  
    assert_equal("select-multiple" ,   browser.select_lists[2].type )  
    
    index=1
    browser.select_lists.each do |l|
      assert_equal( browser.select_list(:index, index).name , l.name )
      assert_equal( browser.select_list(:index, index).id , l.id )
      assert_equal( browser.select_list(:index, index).type , l.type )
      assert_equal( browser.select_list(:index, index).value , l.value )
      index+=1
    end
    assert_equal( index-1, browser.select_lists.length)
  end
end

class TC_Select_Options < Test::Unit::TestCase
  
  def setup
    goto_page "select_tealeaf.html"
  end
  
  def test_options_text
    browser.select_list(:name, 'op_numhits').option(:text, '>=').select
    assert(browser.select_list(:name, 'op_numhits').option(:text, '>=').selected)
  end
end

