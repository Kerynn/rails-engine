class SearchError 
  attr_reader :status, :error_message, :code

  def initialize(status, error_message, code)
    @status = status 
    @error_message = error_message
    @code = code
  end
end