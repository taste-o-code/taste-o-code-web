module FlashMatcher

  class HaveFlashMatcher
    def initialize(type, msg)
      @type = type
      @msg = msg
    end

    def matches?(page)
      @flash = page.find("#flash") if page.has_selector?('#flash')
      @flash.present? && @flash.has_selector?(".flash-#{@type}:contains('#{@msg}')")
    end

    def failure_message_for_should
      "expected flash of type #{@type} with message '#{@msg}'\n" + actual_content
    end

    def failure_message_for_should_not
      "expected no flash of type #{@type} with message '#{@msg}'\n" + actual_content
    end

    def actual_content
      flash_content = "\n#{@flash.native.to_xhtml}" if @flash.present?
      flash_content ? "found:\n#{flash_content}" : "found no flash on the page"
    end

  end

  def have_flash(type, msg)
    HaveFlashMatcher.new type, msg
  end

end