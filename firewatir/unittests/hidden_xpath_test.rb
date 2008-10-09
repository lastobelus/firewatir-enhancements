# feature tests for Input Hidden elements
# revision: $Revision: 1.0 $

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_Hidden_Fields_XPath < Test::Unit::TestCase
    def setup
        goto_page("forms3.html")
    end
    
    def test_hidden
        
        # test using name and ID
        assert( browser.hidden(:xpath,"//input[@type='hidden' and @name='hid1']").exists? )
        assert( browser.hidden(:xpath,"//input[@type='hidden' and @id='hidden_1']").exists? )
        assert_false( browser.hidden(:xpath,"//input[@type='hidden' and @name='hidden_44']").exists? )
        assert_false( browser.hidden(:xpath,"//input[@type='hidden' and @id='hidden_55']").exists? )
        
        browser.hidden(:xpath,"//input[@type='hidden' and @name='hid1']").value = 444
        browser.hidden(:xpath,"//input[@type='hidden' and @id='hidden_1']").value = 555
        
        browser.button(:xpath , "//input[@type='button' and @value='Show Hidden']").click
        
        assert_equal("444"  , browser.text_field(:xpath , "//input[@name='vis1']").value ) 
        assert_equal("555"  , browser.text_field(:xpath ,"//input[@name='vis2']").value )
                
        #  test the over-ridden append method
        browser.hidden(:xpath,"//input[@type='hidden' and @name='hid1']").append("a")
        browser.button(:xpath , "//input[@type='button' and @value='Show Hidden']").click
        assert_equal("444a"  , browser.text_field(:xpath , "//input[@name='vis1']").value ) 
        assert_equal("555"  , browser.text_field(:xpath ,"//input[@name='vis2']").value )
        
        #  test the over-ridden clear method
        browser.hidden(:xpath,"//input[@type='hidden' and @name='hid1']").clear
        browser.button(:xpath , "//input[@type='button' and @value='Show Hidden']").click
        assert_equal(""  , browser.text_field(:xpath , "//input[@name='vis1']").value ) 
        assert_equal("555"  , browser.text_field(:xpath ,"//input[@name='vis2']").value )
        
        # test using a form
        #assert( browser.form(:name , "has_a_hidden").hidden(:name ,"hid1").exists? )
        #assert( browser.form(:name , "has_a_hidden").hidden(:id,"hidden_1").exists? )
        #assert_false( browser.form(:name , "has_a_hidden").hidden(:name,"hidden_44").exists? )
        #assert_false( browser.form(:name , "has_a_hidden").hidden(:id,"hidden_55").exists? )
        
        #browser.form(:name , "has_a_hidden").hidden(:name ,"hid1").value = 222
        #browser.form(:name , "has_a_hidden").hidden(:id,"hidden_1").value = 333
        
        #browser.button(:value , "Show Hidden").click
        
        #assert_equal("222"  , browser.text_field(:name , "vis1").value ) 
        #assert_equal("333"  , browser.text_field(:name ,"vis2").value )
        
        # iterators
        #assert_equal(2, browser.hiddens.length)
        #count =1
        #browser.hiddens.each do |h|
        #    case count
        #    when 1
        #        assert_equal( "", h.id)
        #        assert_equal( "hid1", h.name)
        #    when 2
        #        assert_equal( "", h.name)
        #        assert_equal( "hidden_1", h.id)
        #    end
        #    count+=1
        #end
        
        #assert_equal("hid1" , browser.hiddens[1].name )
        #assert_equal("hidden_1" , browser.hiddens[2].id )
    end
end
