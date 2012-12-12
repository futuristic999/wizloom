class TestsController < ApplicationController
 
   
  def testEditor
    template = "/mockups/test_beejii_editor.html"
    render :template => template
  end

  def testTemplate
    template = "/journals/sandbox/custom_templates/input_template.html"



    render :template=>template
  end

  def testTablelessTemplate
    template = "/journals/sandbox/custom_templates/tableless_template.html"
    render :template => template
  end   


  def runningLogInputMode
    template = "/mockups/running_log_input_mode.html"
    render :template => template
  end

end
