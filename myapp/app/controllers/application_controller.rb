class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end
  require 'pry'
  include ErrorHandlers
end
