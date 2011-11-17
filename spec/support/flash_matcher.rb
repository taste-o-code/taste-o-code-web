module FlashMatcher

  class HaveFlashMatcher
    def initialize(type, msg)
      @type = type
      @msg = msg
    end

    def matches?(page)
      page.has_css? ".flash-#{@type}", :text => @msg
    end

    def failure_message_for_should
      "expected flash of type #{@type} with message '#{@msg}'."
    end

    def failure_message_for_should_not
      "expected no flash of type #{@type} with message '#{@msg}'."
    end

  end

  def have_flash(type, msg)
    HaveFlashMatcher.new type, msg
  end

end