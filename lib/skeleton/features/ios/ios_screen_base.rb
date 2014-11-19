require 'calabash-cucumber/ibase'

class IOSScreenBase < Calabash::IBase

  def self.element(element_name, &block)
    define_method(element_name.to_s, *block)
  end

  class << self
    alias :value :element
    alias :action :element
    alias :trait :element
  end

  element(:loading_screen)            { 'LOADING' }

  # The progress bar of the application is a custom view
  def wait_for_progress
    wait_for { element_does_not_exist "* marked:'#{loading_screen}'" }
  end

  def has_text?(text)
    !query("* {text CONTAINS[c] '#{text}'}").empty? or !query("* {accessibilityLabel CONTAINS[c] '#{text}'}").empty?
  end

  def drag_to direction

    # iOS swipe command doesn't work.
    # For a workaround we need to use the scroll function, but it only work after a swipe command

    # iOS swipe :up and :down are the opposite of the Android directions
    # Setting swipe_opt that will define the swipe 'force'
    swipe_opt = nil
    case direction
    when :left
      swipe_opt = {:'swipe-delta' => {:horizontal=>{:dx => 280} }, :offset => { :x => 300, :y => 300 } }
    when :right
      swipe_opt = {:'swipe-delta' => {:horizontal=>{:dx => 250} }, :offset => { :x => 50, :y => 300 } }
    when :up
      direction = :down
      swipe_opt = {:'swipe-delta' => {:vertical=>{:dy => 200} }, :offset => { :x => 160, :y => 100 } }
    when :down
      direction = :up
      swipe_opt = {:'swipe-delta' => {:vertical=>{:dy => 200} }, :offset => { :x => 160, :y => 400 } }
    end

    swipe(direction, swipe_opt)

    sleep(1)
  end

  # In the iOS, an element could be found from its text or its accessibilityLabel
  # so this function looks for these two properties on the screen. When the query
  # looks for just a part of the text (CONTAINS[c]) then we need to specify if
  # we will look in accessibilityLabel or in any other propertie (marked)
  def ios_element_exists? query
    second_query = nil

    if query.include? "CONTAINS[c]"
      if query.include? "marked"
        second_query = query.gsub( 'marked', 'accessibilityLabel' )
      end
      if query.include? "accessibilityLabel"
        second_query = query.gsub( 'accessibilityLabel', 'marked' )
      end
    end

    if second_query.nil?
      return element_exists(query)
    else
      element_exists(query) or element_exists(second_query)
    end
  end

  def drag_until_element_is_visible_with_special_query direction, element
    drag_until_element_is_visible direction, element, "* {accessibilityLabel CONTAINS[c] '#{element}'}"
  end

  def drag_until_element_is_visible direction, element, query = nil, limit = 15
    i = 0

    element_query = ""
    if query.nil?
      element_query = "* marked:'#{element}'"
    else
      element_query = query
    end

    sleep(1)
    while( !ios_element_exists?(element_query) and i < limit) do
      drag_to direction
      i = i + 1
    end

    raise ("Executed #{limit} moviments #{direction.to_s} and the element '#{element}' was not found on this view!") unless i < limit
  end

  def drag_for_specified_number_of_times direction, times
    times.times do
      drag_to direction
    end
  end

  def is_on_page? page_text
    begin
      wait_for(:timeout => 5) { has_text? page_text }
    rescue
      raise "Unexpected Page. Expected was: '#{page_text}'"
    end
  end

  def enter text, element, query = nil
    if query.nil?
      query = "* marked:'#{element}'"
    end

    touch query
    sleep(1)
    keyboard_enter_text text
    done
  end

  def touch_screen_element element
    begin
      wait_for(:timeout => 5) { element_exists("* marked:'#{element}'") }
      touch "* marked:'#{element}'"
    rescue
      raise "Element #{element} not found on the view"
    end
  end

  def touch_element_by_index id, index
    wait_for(:timeout => 5) { element_exists("* marked:'#{id}' index:#{index}") }
    touch("* marked:'#{id}' index:#{index}")
  end

end